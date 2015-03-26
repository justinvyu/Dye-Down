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

- (instancetype)initWithRect:(CGRect)rect atHorizontalPosition:(NSUInteger)horizontalPosition {
    
    self = [super init];
    
    if (self) {
        self.path = CGPathCreateWithRect(rect, nil);
        
        self.color = [SKColor randomColor];
        self.fillColor = self.color;
    }
    
    return self;
}

@end
