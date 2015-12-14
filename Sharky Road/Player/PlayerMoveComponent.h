//
//  PlayerMoveComponent.h
//  Sharky Road
//
//  Created by Superstar on 10/2/15.
//  Copyright 2015 Xinranmsn Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class MainScene;

@interface PlayerMoveComponent : CCNode<CCTargetedTouchDelegate> {
    
    MainScene *playerScene;
//    int player_direct;
    NSInteger player_direct;
    CCSprite *player;
}

-(void) setPlayerMove:(CGPoint) pos;

@end
