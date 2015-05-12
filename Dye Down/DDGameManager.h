//
//  DDGameManager.h
//  Dye Down
//
//  Created by Justin Yu on 5/8/15.
//  Copyright (c) 2015 Justin Yu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@protocol DDGameManagerDelegate <NSObject>

@optional
- (void)scoreDidChange:(NSInteger)score;
- (void)gameHasEndedWithScore:(NSInteger)score;

@end

@class GameScene;
@class Runner;
@class Wave;

@interface DDGameManager : NSObject

@property (nonatomic, readonly) NSInteger score;
@property (nonatomic, readonly) CGFloat waveSpawnInterval; // Rate of spawn
@property (nonatomic, readonly) CGFloat waveTravelDuration; // Speed of wave

@property (nonatomic, strong) Wave *currentWave;
@property (nonatomic, readonly) BOOL gameHasStarted;    

- (void)startNewGameSessionWithGameScene:(GameScene *)scene;

- (void)moveRunnerToHorizontalPosition:(NSInteger)position;

- (void)startSpawningWaves;

- (void)handleContactBetweenRunner:(Runner *)runner andWave:(Wave *)wave;

@property (nonatomic, strong) id<DDGameManagerDelegate> delegate;

@end
