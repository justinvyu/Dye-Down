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

@end

@implementation Runner

#define ANIMATION_DURATION 0.2f

- (instancetype)initAtHorizontalPosition:(NSUInteger)horizontalPosition {
    self = [super init];
    
    if (self) {
        self.changing = YES;

        self.horizontalPosition = horizontalPosition;
        
        self.animationFrames = [[NSMutableArray alloc] init];
        
        int numberOfFrames = 25;
        for (int i = 1; i <= numberOfFrames; i++) {
            NSString *fileString = [NSString stringWithFormat:@"guy_%d.png", i];
            UIImage *runnerImage = [UIImage imageNamed:fileString];
            SKTexture *frameTexture = [SKTexture textureWithImage:runnerImage];
            [self.animationFrames addObject:frameTexture];
        }
        
        self.texture = self.animationFrames[0];
        self.size = CGSizeMake(120., 120.);
        self.position = CGPointMake(0, 0);
        
        SKAction *runningAnimation = [SKAction animateWithTextures:self.animationFrames timePerFrame:0.03f resize:YES restore:NO];
        SKAction *repeat = [SKAction repeatActionForever:runningAnimation];
        
        [self runAction:repeat withKey:@"running"];
    }
    
    return self;
}

- (void)setHorizontalPosition:(NSUInteger)horizontalPosition {
    if (self.changing) {
        _horizontalPosition = horizontalPosition;

        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        
        SKAction *start = [SKAction runBlock:^{
            self.changing = NO;
        }];
        SKAction *end = [SKAction runBlock:^{
            self.changing = YES;
        }];
        switch (horizontalPosition) {
            {case 0:
                NSLog(@"");
                SKAction *moveRunner = [SKAction moveTo:CGPointMake(-screenWidth/3, 0) duration:ANIMATION_DURATION];
                SKAction *sequence = [SKAction sequence:@[start, moveRunner, end]];
                [self runAction:sequence];
                break;
            }
            {case 1:
                NSLog(@"");
                SKAction *moveRunner = [SKAction moveTo:CGPointMake(0, 0) duration:ANIMATION_DURATION];
                SKAction *sequence = [SKAction sequence:@[start, moveRunner, end]];
                [self runAction:sequence];
                break;
            }
            {case 2:
                NSLog(@"");
                SKAction *moveRunner = [SKAction moveTo:CGPointMake(screenWidth/3, 0) duration:ANIMATION_DURATION];
                SKAction *sequence = [SKAction sequence:@[start, moveRunner, end]];
                [self runAction:sequence];
                break;
            }
        }
    }
    
}

@end
