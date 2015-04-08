//
//  GameScene.m
//  Dye Down
//
//  Created by Justin Yu on 3/23/15.
//  Copyright (c) 2015 Justin Yu. All rights reserved.
//

#import "GameScene.h"
#import "Lane.h"
#import "Runner.h"
#import "Wave.h"

#import "AppDelegate.h"
#import "SKColor+ColorAdditions.h"

#define ANCHOR_HORIZONTAL_OFFSET -self.view.frame.size.width/2
#define ANCHOR_VERTICAL_OFFSET -self.view.frame.size.height/2

#define TIME 4.0f

static const uint32_t runnerCategory = 0;
static const uint32_t waveCategory = 1;
static const uint32_t powerupCategory = 2;

@interface GameScene () <SKPhysicsContactDelegate>

@property (strong, nonatomic) Runner *_runner;
@property (strong, nonatomic) NSMutableArray *_runnerFrames;

@property (nonatomic) NSUInteger score;
@property (strong, nonatomic) SKLabelNode *scoreLabel;

@property (strong, nonatomic) NSArray *colors;

@property (strong, nonatomic) Lane *leftLane;
@property (strong, nonatomic) Lane *middleLane;
@property (strong, nonatomic) Lane *rightLane;

@property (strong, nonatomic) UISwipeGestureRecognizer *swipeRightGesture;
@property (strong, nonatomic) UISwipeGestureRecognizer *swipeLeftGesture;

@property (nonatomic) CGFloat previousHue;

@end

@implementation GameScene

#pragma mark - Initializing sprites/UI

-(void)didMoveToView:(SKView *)view {
    
    self.anchorPoint = CGPointMake(0.5, 0.5);
    self.backgroundColor = [UIColor whiteColor];
    self.physicsWorld.contactDelegate = self;
    self._runnerFrames = [[NSMutableArray alloc] init];
    
    int numberOfFrames = 25;
    for (int i = 1; i <= numberOfFrames; i++) {
        NSString *fileString = [NSString stringWithFormat:@"guy_%d.png", i];
        UIImage *runnerImage = [UIImage imageNamed:fileString];
        SKTexture *frameTexture = [SKTexture textureWithImage:runnerImage];
        [self._runnerFrames addObject:frameTexture];
    }
    
    self.swipeLeftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeft:)];
    [self.swipeLeftGesture setDirection:UISwipeGestureRecognizerDirectionLeft];
    
    self.swipeRightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRight:)];
    [self.swipeRightGesture setDirection:UISwipeGestureRecognizerDirectionRight];
    
    [self.view addGestureRecognizer:self.swipeRightGesture];
    [self.view addGestureRecognizer:self.swipeLeftGesture];
    
    self.scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Market Deco"];
    self.scoreLabel.fontSize = 36.0f;
    self.scoreLabel.zPosition = 1;
    self.scoreLabel.position = CGPointMake(0, 200);
    self.score = 0;
    
    [self setupLanes];
    [self setupRunner];
    
    [self addChild:self.scoreLabel];
    SKAction *spawn = [SKAction runBlock:^{
        [self spawnWave];
        [SKAction waitForDuration:TIME];
    }];
    [self runAction:[SKAction repeatActionForever:spawn]];
}

#pragma mark - Properties

- (void)setScore:(NSUInteger)score {
    
    _score = score;
    self.scoreLabel.text = [NSString stringWithFormat:@"%d", score];
}

#pragma mark - UISwipeGestureRecognizer

- (void)handleSwipeLeft:(UISwipeGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan ||
        gesture.state == UIGestureRecognizerStateEnded ||
        gesture.state == UIGestureRecognizerStateChanged) {
        if (self._runner.horizontalPosition != 0) {
            self._runner.horizontalPosition--;
        }
    }
}

- (void)handleSwipeRight:(UISwipeGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan ||
        gesture.state == UIGestureRecognizerStateEnded ||
        gesture.state == UIGestureRecognizerStateChanged) {
        if (self._runner.horizontalPosition != 2) {
            self._runner.horizontalPosition++;
        }
    }
}


- (void)spawnWave {
    
    SKAction *moveDown = [SKAction moveToY:-self.view.frame.size.height-100 duration:TIME];
    SKAction *remove = [SKAction removeFromParent];
    
    SKAction *sequence = [SKAction sequence:@[moveDown, remove]];
    
    CGRect rect = CGRectMake(ANCHOR_HORIZONTAL_OFFSET,
                             -ANCHOR_VERTICAL_OFFSET+50,
                             self.view.frame.size.width, 30);
    Wave *wave = [[Wave alloc] initWithRect:rect andColorArray:self.colors];
    
    wave.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:wave.path];
    wave.physicsBody.categoryBitMask = waveCategory;
    wave.physicsBody.contactTestBitMask = runnerCategory;
    wave.physicsBody.affectedByGravity = NO;
    
    [self addChild:wave];
    [wave runAction:sequence];
}

#pragma mark - Physics Delegate

- (void)didBeginContact:(SKPhysicsContact *)contact {
    SKNode *nodeA = contact.bodyA.node;
    if ([nodeA isKindOfClass:[Runner class]]) {
        SKNode *nodeB = contact.bodyB.node;
        if ([nodeB isKindOfClass:[Wave class]]) {
            // runner hit a wave
            [self handleContactBetweenRunner:(Runner *)nodeA andWave:(Wave *)nodeB];
        }
    }
}

#pragma mark - Set up running animation

- (void)setupRunner {
    
    self._runner = [[Runner alloc] initAtHorizontalPosition:1];
    self._runner.physicsBody = [SKPhysicsBody bodyWithTexture:self._runnerFrames[0] size:self._runner.size];
    self._runner.physicsBody.categoryBitMask = runnerCategory;
    self._runner.physicsBody.contactTestBitMask = waveCategory;
    self._runner.physicsBody.dynamic = false;
    self._runner.physicsBody.affectedByGravity = NO;
    [self addChild:self._runner];
}

#pragma mark - Change Colors

#define HUE_INTERVAL 60

- (void)paletteChange {
    
    UIView *whiteView = [[UIView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:whiteView];
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.alpha = 0.8f;
    [UIView animateWithDuration: 0.4f
                     animations: ^{
                         whiteView.alpha = 0.0f;
                     }
                     completion: ^(BOOL finished) {
                         [whiteView removeFromSuperview];
                     }
     ];
    
    SKLabelNode *changeLabel = [SKLabelNode labelNodeWithFontNamed:@"Market Deco"];
    changeLabel.text = @"PALETTE CHANGE";
    changeLabel.position = CGPointMake(0, 100);
    [self addChild:changeLabel];
    
    SKAction *wait = [SKAction waitForDuration:1.0f];
    SKAction *removeLabel = [SKAction fadeOutWithDuration:0.5f];
    [changeLabel runAction:[SKAction sequence:@[wait, removeLabel]]];
    
    SKColor *middleColor = [SKColor randomColor];
    self.middleLane.color = middleColor;
    
    CGFloat hue;
    CGFloat saturation;
    CGFloat brightness;
    CGFloat alpha;
    
    [middleColor getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    
    if ((hue * 256) + 80 > self.previousHue && (hue * 256) - 80 < self.previousHue) {
        [self paletteChange];
        return;
    }
    
//    NSLog(@"%0.5f hue, %0.5f saturation, %0.5f brightness, %0.5f alpha", hue, saturation, brightness, alpha);
    
    CGFloat leftHue = (hue * 256 - HUE_INTERVAL);
    if (leftHue < 0) {
        leftHue = (256 + leftHue)/256;
    } else {
        leftHue = leftHue / 256;
    }
//    NSLog(@"leftHue : %f", leftHue);
    
    CGFloat rightHue = (hue * 256 + HUE_INTERVAL);
    if (rightHue > 256) {
        rightHue = (rightHue - 256) / 256;
    } else {
        rightHue /= 256;
    }
//    NSLog(@"rightHue : %f", rightHue);
    
    self.previousHue = hue*256;
    
    self.leftLane.color = [SKColor colorWithHue:leftHue saturation:saturation brightness:brightness alpha:alpha];
    self.rightLane.color = [SKColor colorWithHue:rightHue saturation:saturation brightness:brightness alpha:alpha];
    
    self.colors = @[self.leftLane.color, self.middleLane.color, self.rightLane.color];
}

#pragma mark - Set up three lanes

- (void)setupLanes {
    
    Lane *leftLane = [[Lane alloc] initWithRect:CGRectMake(ANCHOR_HORIZONTAL_OFFSET,
                                                           ANCHOR_VERTICAL_OFFSET,
                                                           self.view.frame.size.width/3,
                                                           self.view.frame.size.height)
                           atHorizontalPosition:0];
    
    Lane *middleLane = [[Lane alloc] initWithRect:CGRectMake(ANCHOR_HORIZONTAL_OFFSET + self.view.frame.size.width/3,
                                                             ANCHOR_VERTICAL_OFFSET,
                                                             self.view.frame.size.width/3,
                                                             self.frame.size.height)
                             atHorizontalPosition:1];
    Lane *rightLane = [[Lane alloc] initWithRect:CGRectMake(ANCHOR_HORIZONTAL_OFFSET + 2 * self.view.frame.size.width/3,
                                                            ANCHOR_VERTICAL_OFFSET,
                                                            self.view.frame.size.width/3,
                                                            self.view.frame.size.height)
                            atHorizontalPosition:2];
    
    leftLane.zPosition = -1;
    middleLane.zPosition = -1;
    rightLane.zPosition = -1;
    
    self.leftLane = leftLane;
    self.middleLane = middleLane;
    self.rightLane = rightLane;
    
    SKColor *middleColor = [SKColor randomColor];
    self.middleLane.color = middleColor;
    
    CGFloat hue;
    CGFloat saturation;
    CGFloat brightness;
    CGFloat alpha;
    
    [middleColor getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    
    self.previousHue = hue;
        
    CGFloat leftHue = (hue * 256 - HUE_INTERVAL);
    if (leftHue < 0) {
        leftHue = (256 + leftHue)/256;
    } else {
        leftHue /= 256;
    }
    
    CGFloat rightHue = (hue * 256 + HUE_INTERVAL);
    if (rightHue > 256) {
        rightHue = (rightHue - 256) / 256;
    } else {
        rightHue /= 256;
    }
    NSLog(@"rightHue : %f", rightHue);
    
    self.leftLane.color = [SKColor colorWithHue:leftHue saturation:saturation brightness:brightness alpha:alpha];
    self.rightLane.color = [SKColor colorWithHue:rightHue saturation:saturation brightness:brightness alpha:alpha];
    
    self.colors = @[self.leftLane.color, self.middleLane.color, self.rightLane.color];

    [self addChild:leftLane];
    [self addChild:middleLane];
    [self addChild:rightLane];
}

- (void)handleContactBetweenRunner:(Runner *)runner andWave:(Wave *)wave {
    NSLog(@"Handling...");
    if (runner.horizontalPosition == wave.colorPosition) {
        NSLog(@"Match!");
    } else {
        NSLog(@"YOU LOSE");
        [self._runner removeFromParent];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //[self paletteChange];
    // TESTING
    //[self spawnWave];
}

-(void)update:(CFTimeInterval)currentTime {

}

@end
