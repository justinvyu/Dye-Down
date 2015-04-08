//
//  Wave.m
//  Dye Down
//
//  Created by Justin Yu on 4/5/15.
//  Copyright (c) 2015 Justin Yu. All rights reserved.
//

#import "Wave.h"

#import "SKColor+ColorAdditions.h"
#import "NSArray+ArrayAdditions.h"

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
        self.strokeColor = self.fillColor;
        self.lineWidth = 2.0f;
        self.zPosition = 0;
    }
    
    return self;
}

@end
