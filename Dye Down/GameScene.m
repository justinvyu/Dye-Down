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

#import "JYConstants.h"

@interface GameScene () <SKPhysicsContactDelegate>

// Data
@property (strong, nonatomic) NSMutableArray *_runnerFrames;
@property (nonatomic) NSUInteger score;
@property (strong, nonatomic) NSMutableArray *waves;

// Nodes
@property (strong, nonatomic) Runner *_runner;
@property (strong, nonatomic) SKLabelNode *scoreLabel;
@property (strong ,nonatomic) SKSpriteNode *pauseButton;
@property (strong, nonatomic) Lane *leftLane;
@property (strong, nonatomic) Lane *middleLane;
@property (strong, nonatomic) Lane *rightLane;

// Gestures
@property (strong, nonatomic) UISwipeGestureRecognizer *swipeRightGesture;
@property (strong, nonatomic) UISwipeGestureRecognizer *swipeLeftGesture;

// Color
@property (strong, nonatomic) NSArray *colors;
@property (nonatomic) CGFloat previousHue;
@property (nonatomic) NSUInteger waveSpeed;

// Utils
//@property (nonatomic) BOOL gameStart;
//@property (nonatomic) CFTimeInterval startTime;
//@property (nonatomic) CFTimeInterval timePassed;
@property (nonatomic) NSUInteger intervalBetweenWaves;
@property (strong, nonatomic) Wave *currentWave;

@end

@implementation GameScene

#pragma mark - Initializing sprites/UI

-(void)didMoveToView:(SKView *)view {
    
    self.anchorPoint = CGPointMake(0.5, 0.5);
    self.backgroundColor = [UIColor whiteColor];
    self.physicsWorld.contactDelegate = self;
    self._runnerFrames = [[NSMutableArray alloc] init];
    self.intervalBetweenWaves = 2.0f;
//    self.gameStart = YES;
    
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
    
    [self setupScoreLabel];
    [self setupLanes];
    [self setupRunner];
    [self setupScoreLabel];
    [self setupPauseButton];
    
    SKAction *wait = [SKAction waitForDuration:self.intervalBetweenWaves];
    SKAction *sequence = [SKAction sequence:@[wait, [SKAction performSelector:@selector(spawnWave) onTarget:self]]];
    SKAction *repeat = [SKAction repeatActionForever:sequence];
    [self runAction:repeat];
    
    self.scoreLabel.text = @"0";

    
    //[self runAction:[SKAction repeatActionForever:spawn]];
}

#pragma mark - Properties

- (NSUInteger)score {
    if (!_score) {
        _score = 0;
    }
    return _score;
}

#pragma mark - UISwipeGestureRecognizer

- (void)handleSwipeLeft:(UISwipeGestureRecognizer *)gesture {
    
    if (gesture.state == UIGestureRecognizerStateBegan ||
        gesture.state == UIGestureRecognizerStateEnded ||
        gesture.state == UIGestureRecognizerStateChanged) {
        if (self._runner.horizontalPosition != 0) {
            //NSLog(@"Horizontal Position: %d", (int)self._runner.horizontalPosition);
            self._runner.horizontalPosition--;
        }
    }
}

- (void)handleSwipeRight:(UISwipeGestureRecognizer *)gesture {
    
    if (gesture.state == UIGestureRecognizerStateBegan ||
        gesture.state == UIGestureRecognizerStateEnded ||
        gesture.state == UIGestureRecognizerStateChanged) {
        if (self._runner.horizontalPosition != 2) {
            //NSLog(@"Horizontal Position: %d", (int)self._runner.horizontalPosition);
            self._runner.horizontalPosition++;
        }
    }
}

#pragma mark - Spawning Waves

- (void)spawnWave {
    
    SKAction *moveDown = [SKAction moveToY:-self.view.frame.size.height-100 duration:self.waveSpeed];
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
    // Add to waves array
}

#pragma mark - Physics Delegate

- (void)didBeginContact:(SKPhysicsContact *)contact {
    
    SKNode *nodeA = contact.bodyA.node;
    if ([nodeA isKindOfClass:[Runner class]]) {
        SKNode *nodeB = contact.bodyB.node;
        if ([nodeB isKindOfClass:[Wave class]]) {
            // runner hit a wave
            if (![nodeB isEqual:self.currentWave]) {
                self.currentWave = (Wave *)nodeB;
                [self handleContactBetweenRunner:(Runner *)nodeA andWave:(Wave *)nodeB];
            }
        }
    }
}

#pragma mark - Create runner

- (void)setupRunner {
    
    self._runner = [[Runner alloc] initAtHorizontalPosition:1];
    self._runner.physicsBody = [SKPhysicsBody bodyWithTexture:self._runnerFrames[0] size:self._runner.size];
    self._runner.physicsBody.categoryBitMask = runnerCategory;
    self._runner.physicsBody.contactTestBitMask = waveCategory;
    self._runner.physicsBody.dynamic = false;
    self._runner.physicsBody.affectedByGravity = NO;
    [self addChild:self._runner];
}

#pragma mark - Create pause button

- (void)setupPauseButton {
    
    self.pauseButton = [SKSpriteNode spriteNodeWithImageNamed:@"pause"];
    self.pauseButton.zPosition = 1;
    self.pauseButton.position = CGPointMake(0, 0);//CGPointMake(ANCHOR_HORIZONTAL_OFFSET, ANCHOR_VERTICAL_OFFSET);
    [self addChild:self.pauseButton];
}

#pragma mark - Setup score label

- (void)setupScoreLabel {
    
    self.scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Market Deco"];
    self.scoreLabel.fontSize = 36.0f;
    self.scoreLabel.zPosition = 1;
    
    self.scoreLabel.position = CGPointMake(0, self.view.frame.size.height / 3);
    [self addChild:self.scoreLabel];
}

- (SKLabelNode *)scoreLabel {
    if (!_scoreLabel) {
        _scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Market Deco"];
        _scoreLabel.fontSize = 36.0f;
        _scoreLabel.zPosition = 1;
        _scoreLabel.text = @"0";
        
        _scoreLabel.position = CGPointMake(0, self.view.frame.size.height / 3);
        [self addChild:_scoreLabel];
    }
    return _scoreLabel;
}

#pragma mark - Change Colors

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

#pragma mark - Handling contact

- (void)handleContactBetweenRunner:(Runner *)runner andWave:(Wave *)wave {

    if (runner.horizontalPosition == wave.colorPosition) {
        [self match];
    } else {
        [self lose];
    }
}

#pragma mark - Matching

- (void)match {
    
    self.score++;
    self.scoreLabel.text = [NSString stringWithFormat:@"%d", (int)self.score];
    NSLog(@"%@", self.scoreLabel.text);
}

#pragma mark - Losing

- (void)lose {
    
    NSLog(@"YOU LOSE");
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // Testing
}

-(void)update:(CFTimeInterval)currentTime {
    
//    if (self.gameStart) {
//        self.startTime = currentTime;
//        self.gameStart = NO;
//    }
//    
//    self.timePassed = currentTime - self.startTime;
//    NSLog(@"%f", self.timePassed);
//    if ((int)(self.timePassed) % 10 == 9) {
//        [self paletteChange];
//    }
}

@end
