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

@property (strong, nonatomic) SKShapeNode *leftLane;
@property (strong, nonatomic) SKShapeNode *middleLane;
@property (strong, nonatomic) SKShapeNode *rightLane;

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
    
    SKShapeNode *bar = [SKShapeNode shapeNodeWithRect:CGRectMake(ANCHOR_HORIZONTAL_OFFSET, -ANCHOR_VERTICAL_OFFSET+50, self.view.frame.size.width, 50)];
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

#

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
    
    SKColor *middleColor = [SKColor randomColor];
    middleLane.color = middleColor;
    
    /*
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat alpha;
    [middleColor getRed:&red green:&green blue:&blue alpha:&alpha];
    
    NSLog(@"%f red, %f green, %f blue, %f alpha", red, green, blue, alpha);
    
    int interval = 60;
    
    CGFloat leftRed = red * 256 - interval;
    if (leftRed < 0) {
        leftRed = (256 + leftRed) / 256;
    } else {
        leftRed /= 256;
    }
    NSLog(@"%f", leftRed);
    
    CGFloat rightRed = (red * 256) + interval;
    if (rightRed > 256) {
        rightRed = ((int)rightRed % 256) / 256;
    } else {
        rightRed = rightRed / 256;
    }
    NSLog(@"%f", rightRed);
    
    CGFloat leftBlue = blue * 256 - interval;
    if (leftBlue < 0) {
        leftBlue = (256 + leftBlue) / 256;
    } else {
        leftBlue /= 256;
    }
    NSLog(@"%f", leftBlue);
    
    CGFloat rightBlue = (blue * 256) + interval;
    if (rightBlue > 256) {
        rightBlue = ((int)rightBlue % 256) / 256;
    } else {
        rightBlue = rightBlue / 256;
    }
    NSLog(@"%f", rightBlue);
    
    CGFloat leftGreen = green * 256 - interval;
    if (leftGreen < 0) {
        leftGreen = (256 + leftGreen) / 256;
    } else {
        leftGreen /= 256;
    }
    NSLog(@"%f", leftGreen);
    
    CGFloat rightGreen = (green * 256) + interval;
    if (rightGreen > 256) {
        rightGreen = ((int)rightGreen % 256) / 256;
    } else {
        rightGreen = rightGreen / 256;
    }
    NSLog(@"%f", rightGreen);
    
    leftLane.color = [SKColor colorWithRed:leftRed green:leftGreen blue:leftBlue alpha:alpha];
    rightLane.color = [SKColor colorWithRed:rightRed green:rightGreen blue:rightBlue alpha:alpha];
    */
    
    
     
    [self addChild:leftLane];
    [self addChild:middleLane];
    [self addChild:rightLane];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    
}

-(void)update:(CFTimeInterval)currentTime {

    
}

@end
