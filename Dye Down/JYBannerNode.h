//
//  JYBannerNode.h
//  Dye Down
//
//  Created by Justin Yu on 5/7/15.
//  Copyright (c) 2015 Justin Yu. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface JYBannerNode : SKSpriteNode

@property (nonatomic, strong, readonly) NSString *title;

- (instancetype)initWithTitle:(NSString *)title size:(CGSize)size;

@end
