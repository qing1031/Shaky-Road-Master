//
//  PlayerMoveComponent.m
//  Sharky Road
//
//  Created by Superstar on 10/2/15.
//  Copyright 2015 Xinranmsn Labs. All rights reserved.
//

#import "PlayerMoveComponent.h"
#import "Define.h"

#import "MainScene.h"


@implementation PlayerMoveComponent

-(id) init
{
    if (self = [super init]) {
//        [self schedule:@selector(movePlayer) interval:0.1f];
        player_direct = 0;
    }
    
    return self;
}

-(void) setPlayerMove:(CGPoint) pos
{
    NSLog(@"WIDTH_STEP %f, HEIGHT STEP %f", PLAYER_WIDTH_STEP, PLAYER_HEIGHT_STEP);
    
    player = [MainScene SharedPlayingScene];
    
    if (pos.x > player.position.x) {
        player_direct = 1;
        
    } else if (pos.x < player.position.x) {
        player_direct = -1;
        
    } else {
        player_direct = 0;
    }
}

-(void) update:(ccTime) dt
{
    player = [MainScene SharedPlayingScene];
    
    [player setPosition:ccp(player.position.x + player_direct * PLAYER_WIDTH_STEP, player.position.y)];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    
    
    return YES;
}

@end
