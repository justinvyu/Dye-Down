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

#define ANCHOR_HORIZONTAL_OFFSET(view) -view.frame.size.width/2
#define ANCHOR_VERTICAL_OFFSET(view) -view.frame.size.height/2

#define LANE_WIDTH WIDTH(self.view)/3

#define TIME 4.0f
#define HUE_INTERVAL 60

#define TITLE_FONT [UIFont fontWithName:JYRegularFont size:JYTitleFontSize]

extern uint32_t const runnerCategory;
extern uint32_t const waveCategory;
extern uint32_t const powerupCategory;

extern CGFloat const JYButtonSize;
extern float const JYButtonAnimationDuration;
extern float const JYFadeAnimationDuration;

extern int const JYBaseWaveAnimationDuration;
extern int const JYBaseWaveSpawnWaitDuration;
extern int const JYTitleFontSize;
extern NSString * const JYRegularFont;

@end
