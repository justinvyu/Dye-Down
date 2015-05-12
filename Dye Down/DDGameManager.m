//
//  DDGameManager.m
//  Dye Down
//
//  Created by Justin Yu on 5/8/15.
//  Copyright (c) 2015 Justin Yu. All rights reserved.
//

#import "DDGameManager.h"

#import "Lane.h"
#import "Runner.h"
#import "Wave.h"
#import "GameScene.h"
#import "Utils.h"
#import "JYConstants.h"

@interface DDGameManager ()

@property (nonatomic, strong) GameScene *scene;

@property (nonatomic, strong) Runner *runner;
@property (nonatomic, strong) NSMutableArray *runnerFrames;

@property (nonatomic, readwrite) BOOL gameHasStarted;
@property (nonatomic, strong) NSMutableArray *waves;

@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, readwrite) CGFloat waveSpawnInterval; // Rate of spawn
@property (nonatomic, readwrite) CGFloat waveTravelDuration; // Speed of wave

@property (nonatomic, strong) NSArray *colorArray;

@end

@implementation DDGameManager

#define VIEW _scene.view

- (void)startNewGameSessionWithGameScene:(GameScene *)scene {
    
    _scene = scene;
    
    if (_waves) {
        [_waves makeObjectsPerformSelector:@selector(removeFromParent)];
    }
    if (_runner) {
        [_runner removeFromParent];
    }
    
    int numberOfFrames = 25;
    NSMutableArray *runnerFrames = [[NSMutableArray alloc] initWithCapacity:numberOfFrames];
    for (int i = 1; i <= numberOfFrames; i++) {
        NSString *fileString = [NSString stringWithFormat:@"guy_%d.png", i];
        UIImage *runnerImage = [UIImage imageNamed:fileString];
        SKTexture *frameTexture = [SKTexture textureWithImage:runnerImage];
        [runnerFrames addObject:frameTexture];
    }
    _runnerFrames = runnerFrames;
    _waves = [[NSMutableArray alloc] init];
    _score = 0;
    
    _waveSpawnInterval = JYBaseWaveSpawnWaitDuration;
    _waveTravelDuration = JYBaseWaveAnimationDuration;
    
    _colorArray = [Utils generateColorArrayAgainstCurrent:self.colorArray];
    [self setupLanes];
    [self setupRunner];
}

- (void)setupLanes {
    
    Lane *leftLane = [[Lane alloc] initWithRect:CGRectMake(ANCHOR_HORIZONTAL_OFFSET(VIEW),
                                                           ANCHOR_VERTICAL_OFFSET(VIEW),
                                                           VIEW.frame.size.width/3,
                                                           VIEW.frame.size.height)
                           atHorizontalPosition:0
                                          color:_colorArray[0]];
    
    Lane *middleLane = [[Lane alloc] initWithRect:CGRectMake(ANCHOR_HORIZONTAL_OFFSET(VIEW) + VIEW.frame.size.width/3,
                                                             ANCHOR_VERTICAL_OFFSET(VIEW),
                                                             VIEW.frame.size.width/3,
                                                             VIEW.frame.size.height)
                             atHorizontalPosition:1
                                            color:_colorArray[1]];
    Lane *rightLane = [[Lane alloc] initWithRect:CGRectMake(ANCHOR_HORIZONTAL_OFFSET(VIEW) + 2 * VIEW.frame.size.width/3,
                                                            ANCHOR_VERTICAL_OFFSET(VIEW),
                                                            VIEW.frame.size.width/3,
                                                            VIEW.frame.size.height)
                            atHorizontalPosition:2
                                           color:_colorArray[2]];
    
    [_scene addChild:leftLane];
    [_scene addChild:middleLane];
    [_scene addChild:rightLane];
}

- (void)startSpawningWaves {
    
    _gameHasStarted = YES;
    SKAction *wait = [SKAction waitForDuration:_waveSpawnInterval];
    SKAction *sequence = [SKAction sequence:@[wait, [SKAction performSelector:@selector(spawnWave) onTarget:self]]];
    SKAction *repeat = [SKAction repeatActionForever:sequence];
    [_scene runAction:repeat withKey:@"spawnWaves"];
}

- (void)spawnWave {
    
    CGRect rect = CGRectMake(ANCHOR_HORIZONTAL_OFFSET(VIEW),
                             -ANCHOR_VERTICAL_OFFSET(VIEW) + 50,
                             VIEW.frame.size.width, 10);
    
    Wave *wave = [[Wave alloc] initWithRect:rect andColorArray:_colorArray];
    
    CGPathRef bodyPath = CGPathCreateWithRect(CGRectInset(rect, 0, -5), nil);
    wave.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:bodyPath];
    wave.physicsBody.categoryBitMask = waveCategory;
    wave.physicsBody.contactTestBitMask = runnerCategory;
    wave.physicsBody.affectedByGravity = NO;

    SKAction *moveDown = [SKAction moveToY:-VIEW.frame.size.height-100 duration:_waveTravelDuration];
    SKAction *remove = [SKAction removeFromParent];
    SKAction *removeFromArray = [SKAction runBlock:^{
        [self.waves removeObject:wave];
    }];
    SKAction *sequence = [SKAction sequence:@[moveDown, remove, removeFromArray]];

    [_scene addChild:wave];

    [_waves addObject:wave];
    [wave runAction:sequence];
}

- (void)setupRunner {
    
    _runner = [[Runner alloc] initAtHorizontalPosition:1];
    _runner.physicsBody = [SKPhysicsBody bodyWithTexture:_runnerFrames[0] size:_runner.size];
    _runner.physicsBody.categoryBitMask = runnerCategory;
    _runner.physicsBody.contactTestBitMask = waveCategory;
    _runner.physicsBody.dynamic = false;
    _runner.physicsBody.affectedByGravity = NO;
    [_scene addChild:_runner];
}

- (void)moveRunnerToHorizontalPosition:(NSInteger)position {
    
    [_runner moveToHorizontalPosition:position];
    _runner.horizontalPosition = position;
}

- (void)handleContactBetweenRunner:(Runner *)runner andWave:(Wave *)wave {
    
    if (runner.horizontalPosition == wave.colorPosition) {
        
        _score++;
        [_delegate scoreDidChange:_score];
    } else {
        // Lose
        
        _gameHasStarted = NO;
        [self.waves makeObjectsPerformSelector:@selector(removeAllActions)];
        
        [_scene removeActionForKey:@"spawnWaves"];
        [_runner removeActionForKey:@"run"];
        
        [_delegate gameHasEndedWithScore:_score];
    }
}

@end
