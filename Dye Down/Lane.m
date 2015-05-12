//
//  Lane.m
//  Dye Down
//
//  Created by Justin Yu on 3/24/15.
//  Copyright (c) 2015 Justin Yu. All rights reserved.
//


#import "Lane.h"
#import "SKColor+ColorAdditions.h"

@implementation Lane

- (instancetype)initWithRect:(CGRect)rect atHorizontalPosition:(NSUInteger)horizontalPosition color:(UIColor *)color {
    
    self = [super init];
    
    if (self) {
        self.path = CGPathCreateWithRect(rect, nil);
        self.zPosition = -1;
        self.lineWidth = 0.2f;
        self.strokeColor = [SKColor whiteColor];
        self.fillColor = color;
    }
    
    return self;
}

@end
