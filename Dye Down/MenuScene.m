//
//  MenuScene.m
//  Dye Down
//
//  Created by Justin Yu on 3/24/15.
//  Copyright (c) 2015 Justin Yu. All rights reserved.
//

#import "MenuScene.h"
#import "GameScene.h"
#import "AppDelegate.h"

#import "SKColor+ColorAdditions.h"

@interface MenuScene ()

@property (strong, nonatomic) SKSpriteNode *playButton;
@property (strong, nonatomic) SKSpriteNode *leaderboardButton;
@property (strong, nonatomic) SKSpriteNode *settingsButton;
@property (strong, nonatomic) SKSpriteNode *rateButton;

@property (strong, nonatomic) NSMutableArray *_runnerFrames;
@property (strong, nonatomic) SKLabelNode *titleLabel;

@end

@implementation MenuScene

#define BUTTON_SIZE 50.

- (void)didMoveToView:(SKView *)view {
    
    self.backgroundColor = [SKColor randomColor];
    
    self._runnerFrames = [[NSMutableArray alloc] init];
    
    int numberOfFrames = 25;
    for (int i = 1; i <= numberOfFrames; i++) {
        NSString *fileString = [NSString stringWithFormat:@"guy_%d.png", i];
        UIImage *runnerImage = [UIImage imageNamed:fileString];
        SKTexture *frameTexture = [SKTexture textureWithImage:runnerImage];
        [self._runnerFrames addObject:frameTexture];
    }
    
    self.anchorPoint = CGPointMake(.5, .5);
    
    SKTexture *playButtonTexture = [SKTexture textureWithImageNamed:@"play"];
    self.playButton = [[SKSpriteNode alloc] initWithTexture:playButtonTexture color:[SKColor clearColor] size:CGSizeMake(80., 80.)];
    [self addChild:self.playButton];
    
    SKTexture *leaderboardButtonTexture = [SKTexture textureWithImageNamed:@"leaderboard"];
    self.leaderboardButton = [[SKSpriteNode alloc] initWithTexture:leaderboardButtonTexture color:[SKColor clearColor] size:CGSizeMake(BUTTON_SIZE, BUTTON_SIZE)];
    self.leaderboardButton.position = CGPointMake(-80, -80);
    [self addChild:self.leaderboardButton];
    
    SKTexture *settingsButtonTexture = [SKTexture textureWithImageNamed:@"settings"];
    self.settingsButton = [[SKSpriteNode alloc] initWithTexture:settingsButtonTexture color:[SKColor clearColor] size:CGSizeMake(BUTTON_SIZE, BUTTON_SIZE)];
    self.settingsButton.position = CGPointMake(0, -100);
    [self addChild:self.settingsButton];
    
    SKTexture *rateButtonTexture = [SKTexture textureWithImageNamed:@"rate"];
    self.rateButton = [[SKSpriteNode alloc] initWithTexture:rateButtonTexture color:[SKColor clearColor] size:CGSizeMake(BUTTON_SIZE, BUTTON_SIZE)];
    self.rateButton.position = CGPointMake(80, -80);
    [self addChild:self.rateButton];
    
    self.titleLabel = [SKLabelNode labelNodeWithText:@"DYE DOWN"];
    self.titleLabel.fontColor = [SKColor whiteColor];
    self.titleLabel.fontName = @"Market Deco";
    self.titleLabel.position = CGPointMake(0, self.view.frame.size.height/4);
    [self addChild:self.titleLabel];
    
    [self setupRunner];
    
}

#pragma mark - Set up running animation

- (void)setupRunner {
    
    SKSpriteNode *runner = [SKSpriteNode spriteNodeWithTexture:self._runnerFrames[0]];
    runner.size = CGSizeMake(120., 120.);
    runner.position = CGPointMake(0, -200);
    
    SKAction *runningAnimation = [SKAction animateWithTextures:self._runnerFrames timePerFrame:0.03f resize:YES restore:NO];
    SKAction *repeat = [SKAction repeatActionForever:runningAnimation];
    
    [self addChild:runner];
    [runner runAction:repeat withKey:@"running"];
}

#define BUTTON_ANIMATION_DURATION 0.2f

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInNode:self];
    
    if ([self.playButton isEqual:[self nodeAtPoint:touchPoint]]) {
        SKAction *resize = [SKAction resizeToWidth:95. height:95. duration:BUTTON_ANIMATION_DURATION];
        [self.playButton runAction:resize];
    } else {
        SKAction *resize = [SKAction resizeToWidth:80. height:80. duration:BUTTON_ANIMATION_DURATION];
        [self.playButton runAction:resize];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInNode:self];
    
    if ([self.playButton isEqual:[self nodeAtPoint:touchPoint]]) {
        SKAction *resize = [SKAction resizeToWidth:95. height:95. duration:BUTTON_ANIMATION_DURATION];
        [self.playButton runAction:resize];
    } else {
        SKAction *resize = [SKAction resizeToWidth:80. height:80. duration:BUTTON_ANIMATION_DURATION];
        [self.playButton runAction:resize];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInNode:self];
    
    SKTransition *transition = [SKTransition crossFadeWithDuration:0.5f];
    
    if (self.playButton == [self nodeAtPoint:touchPoint]) {
        GameScene *game = [[GameScene alloc] initWithSize:self.view.frame.size];
        [self.view presentScene:game transition:transition];
    }
}

@end
