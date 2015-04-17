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
#import "MenuScene.h"

#import "AppDelegate.h"
#import "SKColor+ColorAdditions.h"
#import "SKAction+SKActionAdditions.h"

#import "JYConstants.h"

@interface GameScene () <SKPhysicsContactDelegate>

// Data
@property (strong, nonatomic) NSMutableArray *_runnerFrames;
@property (nonatomic) NSUInteger score;
@property (strong, nonatomic) NSMutableArray *waves;

// Nodes
@property (strong, nonatomic) Runner *_runner;
@property (strong, nonatomic) Lane *leftLane;
@property (strong, nonatomic) Lane *middleLane;
@property (strong, nonatomic) Lane *rightLane;

// UI Nodes
@property (strong, nonatomic) NSMutableArray *menuNodeArray;
@property (strong, nonatomic) SKSpriteNode *playButton;
@property (strong, nonatomic) SKSpriteNode *leaderboardButton;
@property (strong, nonatomic) SKSpriteNode *settingsButton;
@property (strong, nonatomic) SKSpriteNode *rateButton;
@property (strong, nonatomic) SKLabelNode *titleLabel;
@property (strong, nonatomic) SKLabelNode *scoreLabel;
//@property (strong ,nonatomic) SKSpriteNode *pauseButton;

// Gestures
@property (strong, nonatomic) UISwipeGestureRecognizer *swipeRightGesture;
@property (strong, nonatomic) UISwipeGestureRecognizer *swipeLeftGesture;

// Color
@property (strong, nonatomic) NSArray *colors;
@property (nonatomic) CGFloat previousHue;

// Utils
//@property (nonatomic) BOOL gameStart;
//@property (nonatomic) CFTimeInterval startTime;
//@property (nonatomic) CFTimeInterval timePassed;
@property (nonatomic) NSUInteger intervalBetweenWaves;
@property (nonatomic) NSUInteger waveSpeed;
@property (strong, nonatomic) Wave *currentWave;

@end

@implementation GameScene

#pragma mark - Initializing sprites/UI

-(void)didMoveToView:(SKView *)view {
    
    self.anchorPoint = CGPointMake(0.5, 0.5);
    self.backgroundColor = [SKColor colorWithWhite:0.9 alpha:0.8f];
    self.physicsWorld.contactDelegate = self;
    self._runnerFrames = [[NSMutableArray alloc] init];
    
//    self.gameStart = YES;
    
    int numberOfFrames = 25;
    for (int i = 1; i <= numberOfFrames; i++) {
        NSString *fileString = [NSString stringWithFormat:@"guy_%d.png", i];
        UIImage *runnerImage = [UIImage imageNamed:fileString];
        SKTexture *frameTexture = [SKTexture textureWithImage:runnerImage];
        [self._runnerFrames addObject:frameTexture];
    }
    
    [self setupHomeScreen];
}

#pragma mark - Home Screen

- (void)setupHomeScreen {
    
    [self initializeField];
    
    SKTexture *playButtonTexture = [SKTexture textureWithImageNamed:@"play"];
    self.playButton = [[SKSpriteNode alloc] initWithTexture:playButtonTexture color:[SKColor clearColor] size:CGSizeMake(80., 80.)];
    [self addChild:self.playButton];
    [self.menuNodeArray addObject:self.playButton];
    
    SKTexture *leaderboardButtonTexture = [SKTexture textureWithImageNamed:@"leaderboard"];
    self.leaderboardButton = [[SKSpriteNode alloc] initWithTexture:leaderboardButtonTexture color:[SKColor clearColor]
                                                              size:CGSizeMake(JYButtonSize, JYButtonSize)];
    self.leaderboardButton.position = CGPointMake(-self.view.frame.size.width/3, -60);
    [self addChild:self.leaderboardButton];
    [self.menuNodeArray addObject:self.leaderboardButton];

    SKTexture *settingsButtonTexture = [SKTexture textureWithImageNamed:@"settings"];
    self.settingsButton = [[SKSpriteNode alloc] initWithTexture:settingsButtonTexture color:[SKColor clearColor]
                                                           size:CGSizeMake(JYButtonSize, JYButtonSize)];
    self.settingsButton.position = CGPointMake(0, -100);
    [self addChild:self.settingsButton];
    
    SKTexture *rateButtonTexture = [SKTexture textureWithImageNamed:@"rate"];
    self.rateButton = [[SKSpriteNode alloc] initWithTexture:rateButtonTexture color:[SKColor clearColor]
                                                       size:CGSizeMake(JYButtonSize, JYButtonSize)];
    self.rateButton.position = CGPointMake(self.view.frame.size.width/3, -60);
    [self addChild:self.rateButton];
    
    self.titleLabel = [SKLabelNode labelNodeWithText:@"DYE DOWN"];
    self.titleLabel.fontColor = [SKColor colorWithWhite:0.92f alpha:1.0f];
    self.titleLabel.fontName = @"Market Deco";
    self.titleLabel.fontSize = 50.0;
    self.titleLabel.position = CGPointMake(0, self.view.frame.size.height/5);
    [self addChild:self.titleLabel];
}

#pragma mark - Resetting And Starting the Field/Field Elements

- (void)initializeField {
    
    self.intervalBetweenWaves = 1.5f;
    self.waveSpeed = 2.0f;
    
    [self setupScoreLabel];
    [self setupLanes];
    [self setupRunner];
    //    [self setupPauseButton];
    
}

- (void)initializeSwipeGestures {
    
    self.swipeLeftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeft:)];
    [self.swipeLeftGesture setDirection:UISwipeGestureRecognizerDirectionLeft];
    
    self.swipeRightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRight:)];
    [self.swipeRightGesture setDirection:UISwipeGestureRecognizerDirectionRight];
    
    [self.view addGestureRecognizer:self.swipeRightGesture];
    [self.view addGestureRecognizer:self.swipeLeftGesture];
    
}

- (void)startSpawningWaves {
    
    SKAction *wait = [SKAction waitForDuration:self.intervalBetweenWaves];
    SKAction *sequence = [SKAction sequence:@[wait, [SKAction performSelector:@selector(spawnWave) onTarget:self]]];
    SKAction *repeat = [SKAction repeatActionForever:sequence];
    [self runAction:repeat withKey:@"spawnWaves"];
}

#pragma mark - Properties

- (NSUInteger)score {
    if (!_score) {
        _score = 0;
    }
    return _score;
}

- (NSMutableArray *)waves {
    if (!_waves) {
        _waves = [[NSMutableArray alloc] init];
    }
    return _waves;
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

    CGRect rect = CGRectMake(ANCHOR_HORIZONTAL_OFFSET,
                             -ANCHOR_VERTICAL_OFFSET+50,
                             self.view.frame.size.width, 10);
    Wave *wave = [[Wave alloc] initWithRect:rect andColorArray:self.colors];
    
    wave.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:wave.path];
    wave.physicsBody.categoryBitMask = waveCategory;
    wave.physicsBody.contactTestBitMask = runnerCategory;
    wave.physicsBody.affectedByGravity = NO;
    
    SKAction *moveDown = [SKAction moveToY:-self.view.frame.size.height-100 duration:self.waveSpeed];
    SKAction *remove = [SKAction removeFromParent];
    SKAction *removeFromArray = [SKAction runBlock:^{
        [self.waves removeObject:wave];
    }];
    SKAction *sequence = [SKAction sequence:@[moveDown, remove, removeFromArray]];
    
    [self addChild:wave];
    [wave runAction:sequence];
    // Add to waves array
    [self.waves addObject:wave];
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

//#pragma mark - Create pause button
//
//- (void)setupPauseButton {
//    
//    SKTexture *pauseTexture = [SKTexture textureWithImage:[UIImage imageNamed:@"pause.png"]];
//    self.pauseButton = [SKSpriteNode spriteNodeWithTexture:pauseTexture size:CGSizeMake(30.0f, 30.0f)];
//    self.pauseButton.zPosition = 1;
//    self.pauseButton.position = CGPointMake(ANCHOR_HORIZONTAL_OFFSET + self.pauseButton.size.width / 2, -ANCHOR_VERTICAL_OFFSET - self.pauseButton.size.height / 2);
//    [self addChild:self.pauseButton];
//}

#pragma mark - Setup score label

- (void)setupScoreLabel {
    
    self.scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Market Deco"];
    self.scoreLabel.fontSize = 36.0f;
    self.scoreLabel.zPosition = 1;
    
    self.scoreLabel.position = CGPointMake(0, self.view.frame.size.height / 3);
    [self addChild:self.scoreLabel];
}

//- (SKLabelNode *)scoreLabel {
//    if (!_scoreLabel) {
//        _scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Market Deco"];
//        _scoreLabel.fontSize = 36.0f;
//        _scoreLabel.zPosition = 1;
//        _scoreLabel.text = @"0";
//        
//        _scoreLabel.position = CGPointMake(0, self.view.frame.size.height / 3);
//        [self addChild:_scoreLabel];
//    }
//    return _scoreLabel;
//}

#pragma mark - Change Colors

- (void)paletteChange {
    
    // Remove all current waves
    [self.waves makeObjectsPerformSelector:@selector(removeFromParent)];
    self.waves = nil;
    
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
        [wave flash];
    }
}

#pragma mark - Matching

- (void)match {
    
    self.score++;
    self.scoreLabel.text = [NSString stringWithFormat:@"%d", (int)self.score];
}

#pragma mark - Losing

- (void)lose {
    
    [self.waves makeObjectsPerformSelector:@selector(removeAllActions)];
    [self removeActionForKey:@"spawnWaves"];
    [self._runner removeActionForKey:@"run"];
    [self.view removeGestureRecognizer:self.swipeLeftGesture];
    [self.view removeGestureRecognizer:self.swipeRightGesture];

    //[self displayReplayOverlay];
    NSLog(@"YOU LOSE");
    [self setupHomeScreen];
}

#pragma mark - Replaying


#pragma mark - Hiding Menu Overlay

- (void)hideMenuOverlay {
    
    SKAction *bounce = [SKAction moveTo:CGPointMake(0, self.titleLabel.position.y - 5) duration:0.3f];
    SKAction *leave = [SKAction moveTo:CGPointMake(0, 3*self.view.frame.size.height/2) duration:0.5f];
    SKAction *remove = [SKAction removeFromParent];
    [self.titleLabel runAction:[SKAction sequence:@[bounce, leave, remove]]];
    
    SKAction *fade = [SKAction fadeOutWithDuration:0.4f];
}

#pragma mark - Button Touches (Home Screen / Replay)

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInNode:self];
    
    if (self.playButton) {
        if ([self.playButton isEqual:[self nodeAtPoint:touchPoint]]) {
            SKAction *resize = [SKAction resizeToWidth:95. height:95. duration:JYButtonAnimationDuration];
            [self.playButton runAction:resize];
        } else {
            SKAction *resize = [SKAction resizeToWidth:80. height:80. duration:JYButtonAnimationDuration];
            [self.playButton runAction:resize];
        }
    }
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInNode:self];
    
    if (self.playButton) {
        if ([self.playButton isEqual:[self nodeAtPoint:touchPoint]]) {
            SKAction *resize = [SKAction resizeToWidth:95. height:95. duration:JYButtonAnimationDuration];
            [self.playButton runAction:resize];
        } else {
            SKAction *resize = [SKAction resizeToWidth:80. height:80. duration:JYButtonAnimationDuration];
            [self.playButton runAction:resize];
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInNode:self];
    
    if (self.playButton && self.playButton == [self nodeAtPoint:touchPoint]) {
        //GameScene *game = [[GameScene alloc] initWithSize:self.view.frame.size];
        [self hideMenuOverlay];
        [self startSpawningWaves];
    }
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