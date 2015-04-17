//
//  JYConstants.h
//  Dye Down
//
//  Created by Justin Yu on 4/9/15.
//  Copyright (c) 2015 Justin Yu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JYConstants : NSObject

#define ANCHOR_HORIZONTAL_OFFSET -self.view.frame.size.width/2
#define ANCHOR_VERTICAL_OFFSET -self.view.frame.size.height/2

#define TIME 4.0f
#define HUE_INTERVAL 60

extern uint32_t const runnerCategory;
extern uint32_t const waveCategory;
extern uint32_t const powerupCategory;

extern CGFloat const JYButtonSize;
extern float const JYButtonAnimationDuration;
@end
