//
//  GameScene.m
//  Dye Down
//
//  Created by Justin Yu on 3/23/15.
//  Copyright (c) 2015 Justin Yu. All rights reserved.
//

#import "GameScene.h"

#import "AppDelegate.h"
#import "SKColor+ColorAdditions.h"
#import "SKAction+SKActionAdditions.h"

#import "Runner.h"
#import "Wave.h"

#import "JYBannerNode.h"
#import "JYConstants.h"
#import "Utils.h"

@interface GameScene () 

// Manager
@property (nonatomic, strong) DDGameManager *manager;

// UI Nodes
@property (strong, nonatomic) NSMutableArray *menuNodeArray;

@property (strong, nonatomic) SKSpriteNode *playButton;
@property (strong, nonatomic) SKSpriteNode *leaderboardButton;
@property (strong, nonatomic) SKSpriteNode *settingsButton;
@property (strong, nonatomic) SKSpriteNode *rateButton;
@property (strong, nonatomic) SKLabelNode *titleLabel;
@property (strong, nonatomic) SKLabelNode *scoreLabel;

@end

@implementation GameScene

#pragma mark - Initializing sprites/UI

-(void)didMoveToView:(SKView *)view {
    
    self.anchorPoint = CGPointMake(0.5, 0.5);
    self.backgroundColor = [SKColor whiteColor];//[SKColor colorWithWhite:1 alpha:0.8f];
    self.physicsWorld.contactDelegate = self;
    
    _manager = [[DDGameManager alloc] init];
    _manager.delegate = self;
    
//  self.gameStart = YES;
    
    [self setupHomeScreen];
}

#pragma mark - Menu UI

- (void)setupHomeScreen {
    
//    [self clearPreviousSession];
//    [self initializeGameSession];
    
    [_manager startNewGameSessionWithGameScene:self];
    
    SKTexture *playButtonTexture = [SKTexture textureWithImageNamed:@"play"];
    self.playButton = [[SKSpriteNode alloc] initWithTexture:playButtonTexture color:[SKColor clearColor] size:CGSizeMake(80., 80.)];
    [self.menuNodeArray addObject:self.playButton];
    
    SKTexture *leaderboardButtonTexture = [SKTexture textureWithImageNamed:@"leaderboard"];
    self.leaderboardButton = [[SKSpriteNode alloc] initWithTexture:leaderboardButtonTexture color:[SKColor clearColor]
                                                              size:CGSizeMake(JYButtonSize, JYButtonSize)];
    self.leaderboardButton.position = CGPointMake(-self.view.frame.size.width/3, -60);
    [self.menuNodeArray addObject:self.leaderboardButton];

    SKTexture *settingsButtonTexture = [SKTexture textureWithImageNamed:@"share"];
    self.settingsButton = [[SKSpriteNode alloc] initWithTexture:settingsButtonTexture color:[SKColor clearColor]
                                                           size:CGSizeMake(JYButtonSize, JYButtonSize)];
    self.settingsButton.position = CGPointMake(0, -90.0);
    [self.menuNodeArray addObject:self.settingsButton];
    
    SKTexture *rateButtonTexture = [SKTexture textureWithImageNamed:@"rate"];
    self.rateButton = [[SKSpriteNode alloc] initWithTexture:rateButtonTexture color:[SKColor clearColor]
                                                       size:CGSizeMake(JYButtonSize, JYButtonSize)];
    self.rateButton.position = CGPointMake(self.view.frame.size.width / 3, -60);
    [self.menuNodeArray addObject:self.rateButton];
    
    CGFloat textWidth = [Utils widthForLabelWithText:@"DYE DOWN" constraintSize:CGSizeMake(MAXFLOAT, MAXFLOAT) font:TITLE_FONT];
    CGFloat textHeight = [Utils heightForLabelWithText:@"DYE DOWN" constraintSize:CGSizeMake(MAXFLOAT, MAXFLOAT) font:TITLE_FONT];
    JYBannerNode *textBanner = [[JYBannerNode alloc] initWithTitle:@"DYE DOWN" size:CGSizeMake(textWidth + 60, textHeight + 20)];
    
    //    SKSpriteNode *textBanner = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"banner.png"] size:CGSizeMake(textWidth + 60, textHeight + 20)];
    //    textBanner.zPosition = 0;
    //SKSpriteNode *textBanner = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"banner"] size:CGSizeMake(350, 200)];
    textBanner.position = CGPointMake(0, JYButtonSize + 15 + textHeight / 2);
    [self.menuNodeArray addObject:textBanner];
    
    SKAction *fadeIn = [SKAction fadeInWithDuration:JYFadeAnimationDuration];
    for (id object in self.menuNodeArray) {
        if ([object isKindOfClass:[SKSpriteNode class]]) {
            ((SKSpriteNode *)object).alpha = 0.0;
            [(SKSpriteNode *)object runAction:fadeIn];
        }
    }
    
    [self addChild:self.playButton];
    [self addChild:self.leaderboardButton];
    [self addChild:self.settingsButton];
    [self addChild:self.rateButton];
    [self addChild:textBanner];
}

- (void)hideMenuOverlay {
    
    SKAction *fade = [SKAction fadeOutWithDuration:JYFadeAnimationDuration];
    
    for (id object in self.menuNodeArray) {
        if ([object isKindOfClass:[SKSpriteNode class]]) {
            [(SKSpriteNode *)object runAction:fade];
        }
    }
}

//#pragma mark - Resetting And Starting the Field/Field Elements
//
//- (void)clearPreviousSession {
//    [self.waves makeObjectsPerformSelector:@selector(removeFromParent)];
//    self.waves = nil;
//    [self._runner removeFromParent];
//    self._runner = nil;
//    
//    [self.menuNodeArray makeObjectsPerformSelector:@selector(removeFromParent)];
//    self.menuNodeArray = nil;
//    self.score = 0;
//
//    [self.scoreLabel removeFromParent];
//    self.scoreLabel = nil;
//    self.scoreLabel.text = @"0";
//    // Powerups
//}
//
//- (void)initializeGameSession {
//    
//    self.intervalBetweenWaves = 0.8f;
//    self.waveAnimationDuration = 1.8f;
//    
//    [self setupRunner];
//    [self setupLanes];
//    
//    [self._runner moveToHorizontalPosition:1];
//    //    [self setupPauseButton];
//    
//}

//- (void)setupLanes {
//    
//    Lane *leftLane = [[Lane alloc] initWithRect:CGRectMake(ANCHOR_HORIZONTAL_OFFSET,
//                                                           ANCHOR_VERTICAL_OFFSET,
//                                                           self.view.frame.size.width/3,
//                                                           self.view.frame.size.height)
//                           atHorizontalPosition:0];
//    
//    Lane *middleLane = [[Lane alloc] initWithRect:CGRectMake(ANCHOR_HORIZONTAL_OFFSET + self.view.frame.size.width/3,
//                                                             ANCHOR_VERTICAL_OFFSET,
//                                                             self.view.frame.size.width/3,
//                                                             self.frame.size.height)
//                             atHorizontalPosition:1];
//    Lane *rightLane = [[Lane alloc] initWithRect:CGRectMake(ANCHOR_HORIZONTAL_OFFSET + 2 * self.view.frame.size.width/3,
//                                                            ANCHOR_VERTICAL_OFFSET,
//                                                            self.view.frame.size.width/3,
//                                                            self.view.frame.size.height)
//                            atHorizontalPosition:2];
//    
//    self.leftLane = leftLane;
//    self.middleLane = middleLane;
//    self.rightLane = rightLane;
//    
//    self.colors = [Utils generateColorArrayAgainstCurrent:self.colors];
//    
//    self.leftLane.color = self.colors[0];
//    self.middleLane.color = self.colors[1];
//    self.rightLane.color = self.colors[2];
//
//    [self addChild:leftLane];
//    [self addChild:middleLane];
//    [self addChild:rightLane];
//}

- (void)setupScoreLabel {
    
    self.scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Market Deco"];
    self.scoreLabel.fontSize = 36.0f;
    self.scoreLabel.zPosition = 1;
    self.scoreLabel.text = @"0";
    
    self.scoreLabel.position = CGPointMake(0, self.view.frame.size.height / 3);
    [self addChild:self.scoreLabel];
}

#pragma mark - Properties

- (NSMutableArray *)menuNodeArray {
    if (!_menuNodeArray) {
        _menuNodeArray = [[NSMutableArray alloc] init];
    }
    return _menuNodeArray;
}

//- (void)paletteChange {
//    
//    // Remove all current waves
//    [self.waves makeObjectsPerformSelector:@selector(removeFromParent)];
//    self.waves = nil;
//    
//    UIView *whiteView = [[UIView alloc] initWithFrame:self.view.frame];
//    [self.view addSubview:whiteView];
//    whiteView.backgroundColor = [UIColor whiteColor];
//    whiteView.alpha = 0.8f;
//    [UIView animateWithDuration: 0.4f
//                     animations: ^{
//                         whiteView.alpha = 0.0f;
//                     }
//                     completion: ^(BOOL finished) {
//                         [whiteView removeFromSuperview];
//                     }
//     ];
//    
//    SKLabelNode *changeLabel = [SKLabelNode labelNodeWithFontNamed:@"Market Deco"];
//    changeLabel.text = @"PALETTE CHANGE";
//    changeLabel.position = CGPointMake(0, 100);
//    [self addChild:changeLabel];
//    
//    SKAction *wait = [SKAction waitForDuration:1.0f];
//    SKAction *removeLabel = [SKAction fadeOutWithDuration:0.5f];
//    [changeLabel runAction:[SKAction sequence:@[wait, removeLabel]]];
//    
//    SKColor *middleColor = [SKColor randomColor];
//    self.middleLane.color = middleColor;
//    
//    CGFloat hue;
//    CGFloat saturation;
//    CGFloat brightness;
//    CGFloat alpha;
//    
//    [middleColor getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
//    
//    if ((hue * 256) + 80 > self.previousHue && (hue * 256) - 80 < self.previousHue) {
//        [self paletteChange];
//        return;
//    }
//    
//    //    NSLog(@"%0.5f hue, %0.5f saturation, %0.5f brightness, %0.5f alpha", hue, saturation, brightness, alpha);
//    
//    CGFloat leftHue = (hue * 256 - HUE_INTERVAL);
//    if (leftHue < 0) {
//        leftHue = (256 + leftHue)/256;
//    } else {
//        leftHue = leftHue / 256;
//    }
//    //    NSLog(@"leftHue : %f", leftHue);
//    
//    CGFloat rightHue = (hue * 256 + HUE_INTERVAL);
//    if (rightHue > 256) {
//        rightHue = (rightHue - 256) / 256;
//    } else {
//        rightHue /= 256;
//    }
//    //    NSLog(@"rightHue : %f", rightHue);
//    
//    self.previousHue = hue*256;
//    
//    self.leftLane.color = [SKColor colorWithHue:leftHue saturation:saturation brightness:brightness alpha:alpha];
//    self.rightLane.color = [SKColor colorWithHue:rightHue saturation:saturation brightness:brightness alpha:alpha];
//    
//    self.colors = @[self.leftLane.color, self.middleLane.color, self.rightLane.color];
//}

#pragma mark - DDManagerDelegate

- (void)gameHasEndedWithScore:(NSInteger)score {
    
    [self setupHomeScreen];
}

- (void)scoreDidChange:(NSInteger)score {
    
    self.scoreLabel.text = [NSString stringWithFormat:@"%d", (int)score];
}

#pragma mark - Physics Delegate

- (void)didBeginContact:(SKPhysicsContact *)contact {
    
    SKNode *nodeA = contact.bodyA.node;
    if ([nodeA isKindOfClass:[Runner class]]) {
        SKNode *nodeB = contact.bodyB.node;
        if ([nodeB isKindOfClass:[Wave class]]) {
            // runner hit a wave
            if (![nodeB isEqual:_manager.currentWave]) {
                _manager.currentWave = (Wave *)nodeB;
                [_manager handleContactBetweenRunner:(Runner *)nodeA andWave:(Wave *)nodeB];
            }
        }
    }
}

#pragma mark - Replaying

- (void)setupReplayScreen {
    
    
}

#pragma mark - Button Touches (Home Screen / Replay)

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInNode:self];
    SKNode *touchNode = [self nodeAtPoint:touchPoint];
    
    if (self.playButton) {
        if ([self.playButton isEqual:touchNode]) {
            SKAction *resize = [SKAction resizeToWidth:95. height:95. duration:JYButtonAnimationDuration];
            [self.playButton runAction:resize];
        } else {
            SKAction *resize = [SKAction resizeToWidth:80. height:80. duration:JYButtonAnimationDuration];
            [self.playButton runAction:resize];
        }
    }
    
    if (self.rateButton) {
        if ([self.rateButton isEqual:touchNode]) { //[nodes containsObject:self.playButton]) {
            SKAction *resize = [SKAction resizeToWidth:JYButtonSize + 10. height:JYButtonSize + 10. duration:JYButtonAnimationDuration];
            [self.rateButton runAction:resize];
        } else {
            SKAction *resize = [SKAction resizeToWidth:JYButtonSize height:JYButtonSize duration:JYButtonAnimationDuration];
            [self.rateButton runAction:resize];
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.view];
    SKNode *touchNode = [self nodeAtPoint:touchPoint];
    
    if (self.playButton) {
        if ([self.playButton isEqual:touchNode]) { //[nodes containsObject:self.playButton]) {
            SKAction *resize = [SKAction resizeToWidth:95. height:95. duration:JYButtonAnimationDuration];
            [self.playButton runAction:resize];
        }
    }
    
    if ([self.rateButton isEqual:touchNode]) { //[nodes containsObject:self.playButton]) {
//        NSLog(@"Touched");
        SKAction *resize = [SKAction resizeToWidth:JYButtonSize + 10. height:JYButtonSize + 10. duration:JYButtonAnimationDuration];
        [self.rateButton runAction:resize];
    }
    
    if (_manager.gameHasStarted) {
        
        if (touchPoint.x >= 0 && touchPoint.x < LANE_WIDTH && touchPoint.y >= 0 && touchPoint.y <= HEIGHT(self.view)) {
            
                [_manager moveRunnerToHorizontalPosition:0];
        } else if (touchPoint.x > LANE_WIDTH && touchPoint.x < 2*LANE_WIDTH && touchPoint.y >= 0 && touchPoint.y <= HEIGHT(self.view)) {
            
                [_manager moveRunnerToHorizontalPosition:1];
        } else if (touchPoint.x > 2*LANE_WIDTH && touchPoint.x < WIDTH(self.view) && touchPoint.y >= 0 && touchPoint.y <= HEIGHT(self.view)) {
            
                [_manager moveRunnerToHorizontalPosition:2];
        }
    }
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInNode:self];
    
    if (self.playButton && self.playButton == [self nodeAtPoint:touchPoint]) {
        
        SKAction *resize = [SKAction resizeToWidth:80. height:80. duration:JYButtonAnimationDuration];
        [self.playButton runAction:resize];
        
        [self hideMenuOverlay];
        [_manager startSpawningWaves];
        [self setupScoreLabel];
    }
    
    if (self.rateButton && [self.rateButton isEqual:[self nodeAtPoint:touchPoint]]) {
        
        SKAction *resize = [SKAction resizeToWidth:JYButtonSize height:JYButtonSize duration:JYButtonAnimationDuration];
        [self.rateButton runAction:resize];
    }
}

@end