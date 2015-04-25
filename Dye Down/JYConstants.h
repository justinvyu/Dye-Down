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

#define SIZE(view) view.frame.size
#define WIDTH(view) view.frame.size.width
#define HEIGHT(view) view.frame.size.height

#define ORIGINx(view) view.frame.origin.x
#define ORIGINy(view) view.frame.origin.y

#define LANE_WIDTH WIDTH(self.view)/3

#define TIME 4.0f
#define HUE_INTERVAL 60

extern uint32_t const runnerCategory;
extern uint32_t const waveCategory;
extern uint32_t const powerupCategory;

extern CGFloat const JYButtonSize;
extern float const JYButtonAnimationDuration;

extern int const JYBaseWaveAnimationDuration;
extern int const JYBaseWaveSpawnWaitDuration;

@end
