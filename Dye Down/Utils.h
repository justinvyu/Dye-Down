//
//  Utils.h
//  Justin Yu
//
//  Created by Justin Yu on 4/24/15.
//  Copyright (c) 2015 Justin Yu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

#define ORIGINx(view) view.frame.origin.x
#define ORIGINy(view) view.frame.origin.y
#define HEIGHT(view) view.frame.size.height
#define WIDTH(view) view.frame.size.width

#define BOUNDS(view) view.bounds
#define FRAME(view) view.frame

#define STATUS_BAR_HEIGHT [UIApplication sharedApplication].statusBarFrame.size.height

@interface Utils : NSObject


+ (CGFloat)heightForLabelWithText:(NSString *)text constraintSize:(CGSize)constraint font:(UIFont *)font;
+ (CGFloat)widthForLabelWithText:(NSString *)text constraintSize:(CGSize)constraint font:(UIFont *)font;

+ (void)fadeInView:(UIView *)view withDuration:(NSTimeInterval)duration withDelay:(NSTimeInterval)delay;
+ (void)fadeOutView:(UIView *)view withDuration:(NSTimeInterval)duration withDelay:(NSTimeInterval)delay;

/**
 *  Generates a color array of length 3 with random colors. Each color is unique through hue manipulation.
 *
 *  @return Array of UIColor objects with random hues
 */
/**
 *  Generates a color array of length 3 with random colors. Each color is unique through hue manipulation.
 *
 *  @param currentColors Array passed in to determine whether or not the set of colors generated is unique.
 *
 *  @return Array of UIColor objects with random hues
 */
+ (NSArray *)generateColorArrayAgainstCurrent:(NSArray *)currentColors;

@end
