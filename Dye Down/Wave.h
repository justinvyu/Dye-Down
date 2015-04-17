//
//  Wave.h
//  Dye Down
//
//  Created by Justin Yu on 4/5/15.
//  Copyright (c) 2015 Justin Yu. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Wave : SKShapeNode

@property (strong, nonatomic) SKColor *color;
@property (nonatomic) NSUInteger colorPosition;

- (instancetype)initWithRect:(CGRect)rect andColorArray:(NSArray *)colorArray;
- (void)flash;

@end
