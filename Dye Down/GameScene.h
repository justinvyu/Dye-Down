//
//  GameScene.h
//  Dye Down
//
//  Created by Justin Yu on 3/24/15.
//  Copyright (c) 2015 Justin Yu. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

#import "DDGameManager.h"

/**
 *  GameScene will be the class that defines the game's menu and replay system. Most of the internal mechanics will be handled in DDGameManager.
 */
@interface GameScene : SKScene <SKPhysicsContactDelegate, DDGameManagerDelegate>

@end
