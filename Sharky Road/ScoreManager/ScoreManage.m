//
//  ScoreManage.m
//  Sharky Road
//
//  Created by Superstar on 10/3/15.
//  Copyright 2015 Xinranmsn Labs. All rights reserved.
//

#import "ScoreManage.h"


@implementation ScoreManage

-(id) init
{
    if (self = [super init]) {
        
        CGSize size = [CCDirector sharedDirector].winSize;
        
        score_count = 0;

        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"pixelated_numbers.plist"];
        
        CCSpriteBatchNode *spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"pixelated_numbers.png"];
        [self addChild:spriteSheet];
        
        // create and initialize a gameplay background.
        numSpr = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%d.png", score_count]];
        numSpr.scale = 2.0f;
        numSpr.position = ccp(size.width / 2, size.height - [numSpr boundingBox].size.height);
        
        [self addChild:numSpr];
        
        numSpr10 = [CCSprite spriteWithSpriteFrameName:@"0.png"];
        numSpr10.scale = numSpr.scale;
        numSpr10.position = ccp(size.width / 2, numSpr.position.y);
        
        [self addChild:numSpr10];
        numSpr10.visible = NO;
        
        numSpr100 = [CCSprite spriteWithSpriteFrameName:@"0.png"];
        numSpr100.scale = numSpr.scale;
        numSpr100.position = ccp(size.width / 2 - [numSpr boundingBox].size.width, numSpr.position.y);
        
        [self addChild:numSpr100];
        numSpr100.visible = NO;
        
        
        [self schedule:@selector(setScore) interval:0.2f];
        
        // Create the score number.
        [[NSUserDefaults standardUserDefaults] setInteger:nil forKey:@"GameScore"];
    }
    
    return self;
}

-(void) setScore
{
    // get the window size.
    CGSize size = [CCDirector sharedDirector].winSize;
    
    score_count++;
    [[NSUserDefaults standardUserDefaults] setInteger:score_count forKey:@"GameScore"];
    
    NSString *score_str = [NSString stringWithFormat:@"%d.png", score_count % 10];
    
    if (score_count >= pow(10, 1) && score_count < pow(10, 2)) {
        numSpr10.visible = YES;
        numSpr.position = ccp(size.width / 2 + [numSpr boundingBox].size.width / 2, numSpr.position.y);
        numSpr10.position = ccp(size.width / 2 - [numSpr10 boundingBox].size.width / 2, numSpr10.position.y);
        NSString *score_str10 = [NSString stringWithFormat:@"%d.png", (score_count/10) % 100];
        [numSpr10 setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:score_str10]];
    } else if (score_count >= pow(10, 2)) {
        numSpr100.visible = YES;
        numSpr.position = ccp(size.width / 2 + [numSpr boundingBox].size.width, numSpr.position.y);
        numSpr10.position = ccp(size.width / 2, numSpr10.position.y);
        numSpr100.position = ccp(size.width / 2 - [numSpr100 boundingBox].size.width, numSpr100.position.y);

        NSString *score_str10 = [NSString stringWithFormat:@"%d.png", (score_count%100) / 10];
        [numSpr10 setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:score_str10]];
        
        NSString *score_str100 = [NSString stringWithFormat:@"%d.png", score_count/100];
        [numSpr100 setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:score_str100]];
    }

    [numSpr setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:score_str]];
    
    NSLog(@"game scored");
    
    NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"watergun"];
    
    if ([str isEqualToString:@"1"]) {
        [self schedule:@selector(setGunScore) interval:0.1f];
    }

}

-(void) setGunScore
{
    // get the window size.
    CGSize size = [CCDirector sharedDirector].winSize;
    
    score_count++;
    [[NSUserDefaults standardUserDefaults] setInteger:score_count forKey:@"GameScore"];

    NSString *score_str = [NSString stringWithFormat:@"%d.png", score_count % 10];
    	
    if (score_count >= pow(10, 1) && score_count < pow(10, 2)) {
        numSpr10.visible = YES;
        numSpr.position = ccp(size.width / 2 + [numSpr boundingBox].size.width / 2, numSpr.position.y);
        numSpr10.position = ccp(size.width / 2 - [numSpr10 boundingBox].size.width / 2, numSpr10.position.y);
        NSString *score_str10 = [NSString stringWithFormat:@"%d.png", (score_count/10) % 100];
        [numSpr10 setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:score_str10]];
    } else if (score_count >= pow(10, 2)) {
        numSpr100.visible = YES;
        numSpr.position = ccp(size.width / 2 + [numSpr boundingBox].size.width, numSpr.position.y);
        numSpr10.position = ccp(size.width / 2, numSpr10.position.y);
        numSpr100.position = ccp(size.width / 2 - [numSpr100 boundingBox].size.width, numSpr100.position.y);
        
        NSString *score_str10 = [NSString stringWithFormat:@"%d.png", (score_count%100) / 10];
        [numSpr10 setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:score_str10]];
        
        NSString *score_str100 = [NSString stringWithFormat:@"%d.png", score_count/100];
        [numSpr100 setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:score_str100]];
    }
    
    [numSpr setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:score_str]];
    
    NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"watergun"];
    if ([str isEqualToString:@"0"]) {
        [self unschedule:@selector(setGunScore)];
    }
}

@end
