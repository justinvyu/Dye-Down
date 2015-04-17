//
//  SKAction+SKActionAdditions.h
//  Dye Down
//
//  Created by Justin Yu on 4/11/15.
//  Copyright (c) 2015 Justin Yu. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SKAction (SKActionAdditions)

+ (SKAction *)colorFadeFrom:(SKColor *)color1 toColor:(SKColor *)color2 withDuration:(CFTimeInterval)duration;

@end
