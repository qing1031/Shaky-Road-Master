//
//  MainScene.h
//  XLDashedLine
//
//  Created by Richard Wei on 11-12-20.
//  Copyright Xinranmsn Labs 2011年. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

#import "AppDelegate.h"
#import "Define.h"

//#import "GADBannerView.h"

@class XLDashedLine;
@class PlayerMoveComponent;
@class ScoreManage;
@class Shark;

typedef enum _bannerType
{
    kBanner_Portrait_Top,
    kBanner_Portrait_Bottom,
    kBanner_Landscape_Top,
    kBanner_Landscape_Bottom,
}CocosBannerType;

#define BANNER_TYPE kBanner_Portrait_Bottom

// MainScene
@interface MainScene : CCLayer <CCTargetedTouchDelegate>
{
    PlayerSaveDate playerDetail;
    
    AppDelegate *delegate;
    CGSize size;
    int gamestart_flag, player_direct, counter, cloud_index;
    float first_surferPosX;
    BOOL touched;
    CCLabelTTF *counterLabel;
    CCLabelTTF *label;
    CCSprite *shadowSpr;
    CCSprite *boatSpr;
    CCSprite *surferSpr;
    CCSprite *surferWaveSpr;
    CCSprite *beamSpr;
    CCMenuItemImage *gunBtn;
    XLDashedLine *line;
    PlayerMoveComponent * moveComponent;
    ScoreManage *scoreManage;
    Shark *shark;
    
    CCAction *boatAction;
    NSMutableArray *_backgroundAry;
    NSMutableArray *_backgroundbaseAry;
    NSMutableArray *_cloud;
    CGPoint first_pos;
    float gameScaleX;
    float gameScaleY;
    int surferSelected;
//    CocosBannerType mBannerType;
//    GADBannerView *mBannerView;
}

// returns a CCScene that contains the MainScene as the only child
+(CCScene *) scene;

+(id) SharedPlayingScene;
-(id) getPlayerScene;
-(void) gameOver;
-(PlayerSaveDate) getCurrentPlayerDetail;

@end
