//
//  Define.h
//  Sharky Road
//
//  Created by Superstar on 10/2/15.
//  Copyright (c) 2015 Xinranmsn Labs. All rights reserved.
//

#ifndef Sharky_Road_Define_h
#define Sharky_Road_Define_h

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

#define PLAYER_WIDTH_STEP (SCREEN_WIDTH / 6)
#define PLAYER_HEIGHT_STEP (SCREEN_HEIGHT / 10)
#define SHARK_HEIGHT_STEP (SCREEN_HEIGHT / 100)
#define SHARK_WIDTH_STEP (SCREEN_WIDTH / 50)

#define STATIC_SHARK_OBSTACLE   1
#define MOVING_SHARK_OBSTACLE   2
#define BIG_ROCK_OBSTACLE       3
#define SMALL_ROCK_OBSTACLE     4
#define FISHING_BOAT_OBSTACLE   5

typedef struct _PlayerSaveDate{
    float surferPosX;
    float surferPosY;
    NSInteger flyType;
    NSInteger life;
    NSInteger point;
    NSInteger enemyDamaged;
    NSInteger nukeCount;
    NSInteger addweaponLevel;
    NSInteger weaponType;
    NSInteger weaponLevel;
}PlayerSaveDate;

#endif
