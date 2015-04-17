//
//  SKAction+SKActionAdditions.m
//  Dye Down
//
//  Created by Justin Yu on 4/11/15.
//  Copyright (c) 2015 Justin Yu. All rights reserved.
//

#import "SKAction+SKActionAdditions.h"

@implementation SKAction (SKActionAdditions)

+ (SKAction *)colorFadeFrom:(SKColor *)color1 toColor:(SKColor *)color2 withDuration:(CFTimeInterval)duration {

    // get the Color components of col1 and col2
    CGFloat r1 = 0.0, g1 = 0.0, b1 = 0.0, a1 =0.0;
    CGFloat r2 = 0.0, g2 = 0.0, b2 = 0.0, a2 =0.0;
    [color1 getRed:&r1 green:&g1 blue:&b1 alpha:&a1];
    [color2 getRed:&r2 green:&g2 blue:&b2 alpha:&a2];
    
    // return a color fading on the fill color
    CGFloat timeToRun = duration;
    
    return [SKAction customActionWithDuration:timeToRun actionBlock:^(SKNode *node, CGFloat elapsedTime) {
        
        CGFloat fraction = elapsedTime / timeToRun;
        
        SKColor *col3 = [SKColor colorWithRed:lerp(r1,r2,fraction)
                                        green:lerp(g1,g2,fraction)
                                         blue:lerp(b1,b2,fraction)
                                        alpha:lerp(a1,a2,fraction)];
        
        [(SKShapeNode*)node setFillColor:col3];
        [(SKShapeNode*)node setStrokeColor:col3];
    }];
}

double lerp(double a, double b, double fraction) {
    return (b-a)*fraction + a;
}

@end
