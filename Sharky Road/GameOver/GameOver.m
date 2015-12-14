//
//  GameOver.m
//  Sharky Road
//
//  Created by Superstar on 10/8/15.
//  Copyright 2015 Xinranmsn Labs. All rights reserved.
//

#import "GameOver.h"

#import "IntroLayer.h"


@implementation GameOver

+(CCScene *) scene
{
    // 'scene' is an autorelease object.
    CCScene *scene = [CCScene node];
    
    // 'layer' is an autorelease object.
    GameOver *layer = [GameOver node];
    
    // add layer as a child to scene
    [scene addChild: layer];
    
    // return the scene
    return scene;
}

-(id) init
{
    if (self = [super init]) {
        
        CGSize size = [CCDirector sharedDirector].winSize;
        
        // create the background sprite.
        CCSprite *gameover_spr = [CCSprite spriteWithFile:@"ocean_base_bottom.png"];
        gameover_spr.scaleX = size.width / [gameover_spr boundingBox].size.width;
        gameover_spr.scaleY = size.height / [gameover_spr boundingBox].size.height;
        gameover_spr.position = ccp(size.width / 2, size.height / 2);
        
        [self addChild:gameover_spr];
        
        // top background
        CCSprite *backTopSpr = [CCSprite spriteWithFile:@"ocean_texture_top.png"];
        backTopSpr.scaleX = size.width / [backTopSpr boundingBox].size.width;
        backTopSpr.scaleY = backTopSpr.scaleX;
        backTopSpr.position = ccp(size.width/2, size.height/2);
        
        [self addChild:backTopSpr];
        
        
        // create the glass board and button items.
        CCSprite *boardSpr = [CCSprite spriteWithFile:@"glass_board.png"];
        boardSpr.scale = backTopSpr.scaleX;
        boardSpr.position = ccp(size.width/2, size.height/7*4);
        
        [self addChild:boardSpr];
        
        CCMenuItemImage *yourscoreItem = [CCMenuItemImage itemFromNormalImage:@"your_score.png" selectedImage:@"your_score.png"];
        yourscoreItem.scale = 1.5f;
//        yourscoreItem.position = ccp([boardSpr boundingBox].size.width/2, [boardSpr boundingBox].size.height);
        
        CCMenuItemImage *highscoreItem = [CCMenuItemImage itemFromNormalImage:@"high_score.png" selectedImage:@"high_score.png"];
        highscoreItem.scale = 1.5f;
//        highscoreItem.position = ccp([boardSpr boundingBox].size.width/2, [boardSpr boundingBox].size.height/2);
        
        CCMenuItemImage *retryItem = [CCMenuItemImage itemFromNormalImage:@"retry.png" selectedImage:@"retry.png" target:self selector:@selector(retryGame)];
        retryItem.scale = 1.5f;
//        retryItem.position = ccp([boardSpr boundingBox].size.width/2, 10);
        
        CCMenu *menu = [CCMenu menuWithItems:yourscoreItem, highscoreItem, retryItem, nil];
        [menu alignItemsVerticallyWithPadding:[boardSpr boundingBox].size.height/3];
        menu.position = boardSpr.position;
        [self addChild:menu];
        
        // Create and initialize the score value.
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"pixelated_numbers.plist"];
        
        NSString *gameScoreStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"GameScore"];
        NSString *highScoreStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"HighScore"];
        if (highScoreStr == nil) {
            [[NSUserDefaults standardUserDefaults] setValue:gameScoreStr forKey:@"HighScore"];
        } else if (highScoreStr != nil) {
            highScore = (gameScoreStr.intValue > highScoreStr.intValue) ? gameScoreStr.intValue : highScoreStr.intValue;
            NSString *str = [NSString stringWithFormat:@"%d", highScore];
            [[NSUserDefaults standardUserDefaults] setValue:str forKey:@"HighScore"];
        }
        
        int gameScore = gameScoreStr.intValue;
        int posX, posX10, posX100;
        CCSprite *scoreNumSpr = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%d.png", gameScore%10]];
        CCSprite *scoreNumSpr10 = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%d.png", (gameScore/10)%10]];
        CCSprite *scoreNumSpr100 = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%d.png", (gameScore/100)%10]];
        CCSprite *highScoreNumSpr = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%d.png", highScore%10]];
        CCSprite *highScoreNumSpr10 = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%d.png", (highScore/10)%10]];
        CCSprite *highScoreNumSpr100 = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%d.png", (highScore/100)%10]];

        scoreNumSpr.scale = 1.5f;
        scoreNumSpr10.scale = 1.5f;
        scoreNumSpr100.scale = 1.5f;
        highScoreNumSpr.scale = 1.5f;
        highScoreNumSpr10.scale = 1.5f;
        highScoreNumSpr100.scale = 1.5f;
        
        if (gameScore < 10) {
            posX = size.width/2;
            scoreNumSpr10.visible = NO;
            scoreNumSpr100.visible = NO;
            highScoreNumSpr10.visible = NO;
            highScoreNumSpr100.visible = NO;
        }
        if (gameScore >= 10 && gameScore < 100) {
            posX = size.width/2 + [scoreNumSpr boundingBox].size.width/2;
            posX10 = size.width/2 - [scoreNumSpr boundingBox].size.width/2;
            scoreNumSpr100.visible = NO;
            highScoreNumSpr100.visible = NO;
        }
        if (gameScore > 100) {
            posX = size.width/2 + [scoreNumSpr boundingBox].size.width;
            posX10 = size.width/2;
            posX100 = size.width/2 - [scoreNumSpr boundingBox].size.width;
        }
        
        scoreNumSpr.position = ccp(posX, menu.position.y + [boardSpr boundingBox].size.height/4);
        scoreNumSpr10.position = ccp(posX10, scoreNumSpr.position.y);
        scoreNumSpr100.position = ccp(posX100, scoreNumSpr.position.y);
        highScoreNumSpr.position = ccp(posX, menu.position.y - [boardSpr boundingBox].size.height/6);
        highScoreNumSpr10.position = ccp(posX10, highScoreNumSpr.position.y);
        highScoreNumSpr100.position = ccp(posX100, highScoreNumSpr.position.y);
        
        [self addChild:scoreNumSpr];
        [self addChild:scoreNumSpr10];
        [self addChild:scoreNumSpr100];
        [self addChild:highScoreNumSpr];
        [self addChild:highScoreNumSpr10];
        [self addChild:highScoreNumSpr100];
    }
    
    return self;
}

-(void) retryGame
{
    [[CCDirector sharedDirector] replaceScene:[IntroLayer scene]];
}

@end