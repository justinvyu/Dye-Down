//
//  Runner.h
//  Dye Down
//
//  Created by Justin Yu on 4/5/15.
//  Copyright (c) 2015 Justin Yu. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Runner : SKSpriteNode

@property (nonatomic) NSUInteger horizontalPosition; // 0 = left, 1 = center, 2 = right

- (instancetype)initAtHorizontalPosition:(NSUInteger)horizontalPosition;

- (void)moveToHorizontalPosition:(NSUInteger)horizontalPosition;

@end
