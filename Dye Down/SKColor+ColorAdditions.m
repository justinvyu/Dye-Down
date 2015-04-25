//
//  SKColor+ColorAdditions.m
//  Dye Down
//
//  Created by Justin Yu on 3/24/15.
//  Copyright (c) 2015 Justin Yu. All rights reserved.
//

#import "SKColor+ColorAdditions.h"

@implementation SKColor (ColorAdditions)

+ (SKColor *)randomColor {
    
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = 0.8f;/*( arc4random() % 128 / 256.0 ) + 0.5*/;  //  0.5 to 1.0, away from white
    CGFloat brightness = 0.8f;// ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:0.9f];
    return color;
}

+ (SKColor *)opaqueWithColor:(SKColor *)color {
    
    CGFloat hue;
    CGFloat saturation;
    CGFloat brightness;
    CGFloat alpha;
    
    [color getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    
    SKColor *opaque = [SKColor colorWithHue:hue saturation:saturation-0.1 brightness:brightness-0.1 alpha:1.0f];
    
    return opaque;
}

@end
