//
//  Utils.m
//  Justin Yu
//
//  Created by Justin Yu on 4/24/15.
//  Copyright (c) 2015 Justin Yu. All rights reserved.
//

#import "Utils.h"
#import "SKColor+ColorAdditions.h"
#import "JYConstants.h"

@implementation Utils

#pragma mark - CGFloat

+ (CGFloat)heightForLabelWithText:(NSString *)text constraintSize:(CGSize)constraint font:(UIFont *)font
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[UIFont fontWithName:font.fontName size:font.pointSize] forKey:NSFontAttributeName];
    CGRect labelHeight = [text boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    
    return labelHeight.size.height;
}

+ (CGFloat)widthForLabelWithText:(NSString *)text constraintSize:(CGSize)constraint font:(UIFont *)font
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[UIFont fontWithName:font.fontName size:font.pointSize] forKey:NSFontAttributeName];
    CGRect labelHeight = [text boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    
    return labelHeight.size.width;
}

#pragma mark - Animation

+ (void)fadeInView:(UIView *)view withDuration:(NSTimeInterval)duration withDelay:(NSTimeInterval)delay {
    
    view.alpha = 0;
    [UIView animateWithDuration:duration delay:delay
                        options:UIViewAnimationOptionTransitionCrossDissolve
                     animations:^{
                         view.alpha = 1;
                     }
                     completion:nil];
}

+ (void)fadeOutView:(UIView *)view withDuration:(NSTimeInterval)duration withDelay:(NSTimeInterval)delay {
    
    [UIView animateWithDuration:duration delay:delay
                        options:UIViewAnimationOptionTransitionCrossDissolve
                     animations:^{
                         view.alpha = 0.0;
                     }
                     completion:nil];
}

#pragma mark - Color

+ (NSArray *)generateColorArrayAgainstCurrent:(NSArray *)currentColors {
    
    // Random Color from UIColor Category
    SKColor *middleColor = [SKColor randomColor];
    
    CGFloat hue, saturation, brightness, alpha;
    
    // Retrieve hue, saturation, brightness alpha
    [middleColor getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    
    if (currentColors) {
        CGFloat pHue, pSaturation, pBrightness, pAlpha;
        
        [(SKColor *)currentColors[1] getHue:&pHue saturation:&pSaturation brightness:&pBrightness alpha:&pAlpha];
        
        if ((hue * 256) + 80 > (pHue * 256) && (hue * 256) - 80 < (pHue * 256)) {
            [Utils generateColorArrayAgainstCurrent:currentColors];
        }
    }
    
    CGFloat leftHue = (hue * 256 - HUE_INTERVAL);
    if (leftHue < 0) {
        leftHue = (256 + leftHue)/256;
    } else {
        leftHue /= 256;
    }
    SKColor *leftColor = [SKColor colorWithHue:leftHue saturation:saturation brightness:brightness alpha:alpha];
    
    CGFloat rightHue = (hue * 256 + HUE_INTERVAL);
    if (rightHue > 256) {
        rightHue = (rightHue - 256) / 256;
    } else {
        rightHue /= 256;
    }
    NSLog(@"righthue: %f", rightHue);
    SKColor *rightColor = [SKColor colorWithHue:rightHue saturation:saturation brightness:brightness alpha:alpha];
    
    return @[leftColor, middleColor, rightColor];
}

@end
