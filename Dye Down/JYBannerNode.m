//
//  JYBannerNode.m
//  Dye Down
//
//  Created by Justin Yu on 5/7/15.
//  Copyright (c) 2015 Justin Yu. All rights reserved.
//

#import "JYBannerNode.h"
#import "JYConstants.h"

@interface JYBannerNode ()

@property (nonatomic, strong) SKLabelNode *titleNode;

@end

@implementation JYBannerNode

- (instancetype)initWithTitle:(NSString *)title size:(CGSize)size {
    
    self = [super initWithTexture:[SKTexture textureWithImageNamed:@"banner.png"]];
    
    if (self) {
        
        _title = title;
        _titleNode = [[SKLabelNode alloc] initWithFontNamed:@"Market Deco"];
        _titleNode.fontSize = JYTitleFontSize;
        _titleNode.fontColor = [SKColor whiteColor];
        _titleNode.text = title;
        [self addChild:_titleNode];
        
        _titleNode.position = CGPointMake(self.position.x, self.position.y - 10)  ;
        
        self.zPosition = 0;
        self.size = size;
    }
    
    return self;
}

@end
