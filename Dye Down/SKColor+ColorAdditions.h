//
//  SKColor+ColorAdditions.h
//  Dye Down
//
//  Created by Justin Yu on 3/24/15.
//  Copyright (c) 2015 Justin Yu. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SKColor (ColorAdditions)

+ (SKColor *)randomColor;
+ (SKColor *)opaqueWithColor:(SKColor *)color;

@end
