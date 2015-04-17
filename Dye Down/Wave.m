//
//  Wave.m
//  Dye Down
//
//  Created by Justin Yu on 4/5/15.
//  Copyright (c) 2015 Justin Yu. All rights reserved.
//

#import "Wave.h"

#import "SKColor+ColorAdditions.h"
#import "SKAction+SKActionAdditions.h"
#import "NSArray+ArrayAdditions.h"

@interface Wave ()

@property (strong, nonatomic) SKColor *innateColor;

@end

@implementation Wave

- (SKColor *)randomColorFromArray:(NSArray *)colorArray {
    id object = [colorArray anyObject];
    if ([object isKindOfClass:[SKColor class]]) {
        self.colorPosition = [colorArray indexOfObject:object];
        return (SKColor *)object;
    }
    return nil;
}

- (instancetype)initWithRect:(CGRect)rect andColorArray:(NSArray *)colorArray {
    self = [super init];
    
    if (self) {
        // Initialization code
        self.path = CGPathCreateWithRect(rect, nil);
        
        self.fillColor = [SKColor opaqueWithColor:[self randomColorFromArray:colorArray]];
        //self.fillColor = [self randomColorFromArray:colorArray];
        self.strokeColor = self.fillColor;
        self.innateColor = self.fillColor;
        self.lineWidth = 2.0f;
        self.zPosition = 0;
    }
    
    return self;
}

- (void)flash {
    SKAction *makeWhite = [SKAction colorFadeFrom:self.innateColor toColor:[SKColor whiteColor] withDuration:0.2f];
    SKAction *revert = [SKAction colorFadeFrom:[SKColor whiteColor] toColor:self.innateColor withDuration:0.2f];
    [self runAction:[SKAction repeatAction:[SKAction sequence:@[makeWhite, revert]] count:2]];
}

@end
