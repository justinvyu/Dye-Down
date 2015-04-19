//
//  GameViewController.m
//  Dye Down
//
//  Created by Justin Yu on 3/23/15.
//  Copyright (c) 2015 Justin Yu. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"
#import "MenuScene.h"

@interface GameViewController ()

@end

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    skView.backgroundColor = [SKColor whiteColor];
    GameScene *game = [[GameScene alloc] initWithSize:[UIScreen mainScreen].bounds.size];
    [skView presentScene:game];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
