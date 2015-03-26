//
//  GameScene.m
//  Dye Down
//
//  Created by Justin Yu on 3/23/15.
//  Copyright (c) 2015 Justin Yu. All rights reserved.
//

#import "GameScene.h"
#import "Lane.h"

#define ANCHOR_HORIZONTAL_OFFSET -self.view.frame.size.width/2
#define ANCHOR_VERTICAL_OFFSET -self.view.frame.size.height/2

@implementation GameScene {
    
    SKSpriteNode *_runner;
    NSMutableArray *_runnerFrames;
}

-(void)didMoveToView:(SKView *)view {
    
    self.anchorPoint = CGPointMake(0.5, 0.5);
    self.backgroundColor = [UIColor whiteColor];
    
    _runnerFrames = [[NSMutableArray alloc] initWithCapacity:4];
    
    int numberOfFrames = 6;
    for (int i = 1; i < numberOfFrames; i++) {
        NSString *fileString = [NSString stringWithFormat:@"runner_%d.png", i];
        UIImage *runnerImage = [UIImage imageNamed:fileString];
        SKTexture *frameTexture = [SKTexture textureWithImage:runnerImage];
        [_runnerFrames addObject:frameTexture];
    }
    
    [self setupLanes];
    [self setupRunner];
    
}

#define TIME 2.0f

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
    
    SKTexture *temp = _runnerFrames[0];
    _runner = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:CGSizeMake(40., 40.)];
    _runner.texture = temp;
    _runner.position = CGPointMake(0, 100);
    
    SKAction *runningAnimation = [SKAction animateWithTextures:_runnerFrames timePerFrame:0.1f resize:YES restore:YES];
    SKAction *repeat = [SKAction repeatActionForever:runningAnimation];
    
    [self addChild:_runner];
    [_runner runAction:repeat withKey:@"running"];
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
    
    [self addChild:leftLane];
    [self addChild:middleLane];
    [self addChild:rightLane];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    
}

-(void)update:(CFTimeInterval)currentTime {

    
}

@end
