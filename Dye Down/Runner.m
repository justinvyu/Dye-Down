//
//  Runner.m
//  Dye Down
//
//  Created by Justin Yu on 4/5/15.
//  Copyright (c) 2015 Justin Yu. All rights reserved.
//

#import "Runner.h"

@interface Runner ()

@property (strong, nonatomic) NSMutableArray *animationFrames;
@property (nonatomic) BOOL changing;

@property (nonatomic) float screenHeight;
@property (nonatomic) BOOL firstTime;

@end

@implementation Runner

@synthesize horizontalPosition = _horizontalPosition;

#define ANIMATION_DURATION 0.2f
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define VERTICAL_POSITION -self.screenHeight / 2 + self.size.height

- (instancetype)initAtHorizontalPosition:(NSUInteger)horizontalPosition {
    
    self = [super init];
    
    if (self) {
        self.changing = YES;
        self.horizontalPosition = 3; // workaround
        //self.changing = YES;
        self.animationFrames = [[NSMutableArray alloc] init];
        int numberOfFrames = 25;
        for (int i = 1; i <= numberOfFrames; i++) {
            NSString *fileString = [NSString stringWithFormat:@"guy_%d.png", i];
            UIImage *runnerImage = [UIImage imageNamed:fileString];
            SKTexture *frameTexture = [SKTexture textureWithImage:runnerImage];
            [self.animationFrames addObject:frameTexture];
        }
        self.screenHeight = [UIScreen mainScreen].bounds.size.height;
        self.texture = self.animationFrames[0];
        self.size = CGSizeMake(120., 120.); // Change relative to device
        self.position = CGPointMake(0, VERTICAL_POSITION-20); // offset 20 to account for SK bug
        
        SKAction *runningAnimation = [SKAction animateWithTextures:self.animationFrames timePerFrame:0.03f resize:YES restore:NO];
        SKAction *repeat = [SKAction repeatActionForever:runningAnimation];
        
        [self runAction:repeat withKey:@"running"];

    }
    
    return self;
}

- (NSUInteger)horizontalPosition {
    
    if (_horizontalPosition == 3) {
        _horizontalPosition = 1;
    }
    return _horizontalPosition;
}

- (void)setHorizontalPosition:(NSUInteger)horizontalPosition {
    
    if (self.changing) {
        _horizontalPosition = horizontalPosition;
        SKAction *start = [SKAction runBlock:^{
            self.changing = NO;
        }];
        SKAction *end = [SKAction runBlock:^{
            self.changing = YES;
        }];
        switch (horizontalPosition) {
            {case 0:
                NSLog(@"");
                SKAction *moveRunner = [SKAction moveTo:CGPointMake(-SCREEN_WIDTH/3, VERTICAL_POSITION) duration:ANIMATION_DURATION];
                SKAction *sequence = [SKAction sequence:@[start, moveRunner, end]];
                [self runAction:sequence];
                break;
            }
            {case 1:
                NSLog(@"");
                SKAction *moveRunner = [SKAction moveTo:CGPointMake(0, VERTICAL_POSITION) duration:ANIMATION_DURATION];
                //self.position = CGPointMake(0, VERTICAL_POSITION);
                SKAction *sequence = [SKAction sequence:@[start, moveRunner, end]];
                [self runAction:sequence];
                break;
            }
            {case 2:
                NSLog(@"");
                SKAction *moveRunner = [SKAction moveTo:CGPointMake(SCREEN_WIDTH/3, VERTICAL_POSITION) duration:ANIMATION_DURATION];
                SKAction *sequence = [SKAction sequence:@[start, moveRunner, end]];
                [self runAction:sequence];
                break;
            }
        }
    }
    
}

@end
