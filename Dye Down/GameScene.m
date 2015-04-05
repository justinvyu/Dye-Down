//
//  GameScene.m
//  Dye Down
//
//  Created by Justin Yu on 3/23/15.
//  Copyright (c) 2015 Justin Yu. All rights reserved.
//

#import "GameScene.h"
#import "Lane.h"
#import "AppDelegate.h"

#import "SKColor+ColorAdditions.h"

#define ANCHOR_HORIZONTAL_OFFSET -self.view.frame.size.width/2
#define ANCHOR_VERTICAL_OFFSET -self.view.frame.size.height/2

@interface GameScene ()

@property (strong, nonatomic) SKSpriteNode *_runner;
@property (strong, nonatomic) NSMutableArray *_runnerFrames;

@property (strong, nonatomic) Lane *leftLane;
@property (strong, nonatomic) Lane *middleLane;
@property (strong, nonatomic) Lane *rightLane;

@property (nonatomic) CGFloat previousHue;

@end

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    
    self.anchorPoint = CGPointMake(0.5, 0.5);
    self.backgroundColor = [UIColor whiteColor];

    self._runnerFrames = [[NSMutableArray alloc] init];
    
    int numberOfFrames = 25;
    for (int i = 1; i <= numberOfFrames; i++) {
        NSString *fileString = [NSString stringWithFormat:@"guy_%d.png", i];
        UIImage *runnerImage = [UIImage imageNamed:fileString];
        SKTexture *frameTexture = [SKTexture textureWithImage:runnerImage];
        [self._runnerFrames addObject:frameTexture];
    }
    
    [self setupLanes];
    [self setupRunner];
}

#define TIME 4.0f

- (void)spawnBar {
    
    SKAction *moveDown = [SKAction moveToY:-self.view.frame.size.height-100 duration:TIME];
    SKAction *remove = [SKAction removeFromParent];
    
    SKAction *sequence = [SKAction sequence:@[moveDown, remove]];
    
    SKShapeNode *bar = [SKShapeNode shapeNodeWithRect:CGRectMake(ANCHOR_HORIZONTAL_OFFSET,
                                                                 -ANCHOR_VERTICAL_OFFSET+50,
                                                                 self.view.frame.size.width, 50)];
    bar.fillColor = [SKColor blackColor];
    
    [self addChild:bar];
    [bar runAction:sequence];
}

#pragma mark - Set up running animation

- (void)setupRunner {
    
    self._runner = [SKSpriteNode spriteNodeWithTexture:self._runnerFrames[0]];
    self._runner.size = CGSizeMake(120., 120.);
    self._runner.position = CGPointMake(0, 0);
    
    SKAction *runningAnimation = [SKAction animateWithTextures:self._runnerFrames timePerFrame:0.03f resize:YES restore:NO];
    SKAction *repeat = [SKAction repeatActionForever:runningAnimation];
    
    [self addChild:self._runner];
    [self._runner runAction:repeat withKey:@"running"];
}

#pragma mark - Change Colors

- (void)paletteChange {
    
    UIView *whiteView = [[UIView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:whiteView];
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.alpha = 0.8f;
    [UIView animateWithDuration: 0.2f
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
        NSLog(@"changing");
        [self paletteChange];
        return;
    }
    
//    NSLog(@"%0.5f hue, %0.5f saturation, %0.5f brightness, %0.5f alpha", hue, saturation, brightness, alpha);
    int interval = 85;
    
    CGFloat leftHue = (hue * 256 - interval);
    if (leftHue < 0) {
        leftHue = (256 + leftHue)/256;
    } else {
        leftHue = leftHue / 256;
    }
//    NSLog(@"leftHue : %f", leftHue);
    
    CGFloat rightHue = (hue * 256 + interval);
    if (rightHue > 256) {
        rightHue = (rightHue - 256) / 256;
    } else {
        rightHue /= 256;
    }
//    NSLog(@"rightHue : %f", rightHue);
    
    self.previousHue = hue*256;
    
    self.leftLane.color = [SKColor colorWithHue:leftHue saturation:saturation brightness:brightness alpha:alpha];
    self.rightLane.color = [SKColor colorWithHue:rightHue saturation:saturation brightness:brightness alpha:alpha];
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
    
    self.leftLane = leftLane;
    self.middleLane = middleLane;
    self.rightLane = rightLane;
    
    SKColor *middleColor = [SKColor randomColor];
    middleLane.color = middleColor;
    
    CGFloat hue;
    CGFloat saturation;
    CGFloat brightness;
    CGFloat alpha;
    
    [middleColor getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    
    self.previousHue = hue;
    
    NSLog(@"%0.5f hue, %0.5f saturation, %0.5f brightness, %0.5f alpha", hue, saturation, brightness, alpha);
    int interval = 60;
    
    CGFloat leftHue = (hue * 256 - interval);
    if (leftHue < 0) {
        leftHue = (256 + leftHue)/256;
    } else {
        leftHue = leftHue / 256;
    }
    NSLog(@"leftHue : %f", leftHue);
    
    CGFloat rightHue = (hue * 256 + interval);
    if (rightHue < 256) {
        rightHue = ((int)rightHue % 256) / 256;
    }
    NSLog(@"rightHue : %f", rightHue);
    
    leftLane.color = [SKColor colorWithHue:leftHue saturation:saturation brightness:brightness alpha:alpha];
    rightLane.color = [SKColor colorWithHue:rightHue saturation:saturation brightness:brightness alpha:alpha];
    
    [self addChild:leftLane];
    [self addChild:middleLane];
    [self addChild:rightLane];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self paletteChange];
}

-(void)update:(CFTimeInterval)currentTime {

    
}

@end
