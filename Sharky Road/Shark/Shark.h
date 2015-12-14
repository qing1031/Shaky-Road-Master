//
//  Shark.h
//  Sharky Road
//
//  Created by Superstar on 10/3/15.
//  Copyright 2015 Xinranmsn Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "MainScene.h"

#import "AppDelegate.h"

@class MainScene;
@class ScoreManage;

@interface Shark : CCNode {
    
    AppDelegate *delegate;
    
    CCSprite *playerSpr;
    CCSprite *rampSpr;
    CCSprite *deathBoatSpr;
    CCSprite *destructionSpr;
    NSMutableArray *_sharks;
    NSMutableArray *_movingSharks;
    NSMutableArray *_wave;
    NSMutableArray *_destruction;
    int i;
    int j;
    int sharkline_flag;
    int horizontal_flag;
    NSString *watergun_str;
    NSInteger watergun_flag;
}

@property (assign,nonatomic) MainScene *mainScene;
@property (nonatomic, assign) CGPoint playerPos;
@property (nonatomic, assign) NSInteger waveJumpFlag;
@property (nonatomic, assign) NSInteger surferSelected;

@end
