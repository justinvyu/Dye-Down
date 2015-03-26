//
//  Lane.h
//  Dye Down
//
//  Created by Justin Yu on 3/24/15.
//  Copyright (c) 2015 Justin Yu. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Lane : SKShapeNode

@property (strong, nonatomic) SKColor *color;
@property (nonatomic) NSUInteger horizontalPosition; // 0 = left, 1 = center, 2 = right

- (instancetype)initWithRect:(CGRect)rect atHorizontalPosition:(NSUInteger)horizontalPosition;

@end
