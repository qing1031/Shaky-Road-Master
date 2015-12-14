//
//  Shark.m
//  Sharky Road
//
//  Created by Superstar on 10/3/15.
//  Copyright 2015 Xinranmsn Labs. All rights reserved.
//

#import "Shark.h"

#import "Define.h"
#import "GameOver.h"

@implementation Shark

-(id) init
{
    if (self = [super init]) {

        // Get the window size.
        CGSize size = [CCDirector sharedDirector].winSize;

        // create and initialize the multi shark sprite.
        _sharks = [[NSMutableArray alloc] init];
        _movingSharks = [[NSMutableArray alloc] init];
        _wave = [[NSMutableArray alloc] init];
        _destruction = [[NSMutableArray alloc] init];
        
        self.mainScene = [MainScene node];
        playerSpr = [self.mainScene getPlayerScene];
        
        for (i = 0; i < 4; i++) {
            for (int m = 0; m < 2; m++) {
                [self setOriginalSharks];
            }
        }
        
        sharkline_flag = 0;
        horizontal_flag = +1;
        self.waveJumpFlag = 0;
        NSLog(@"surferselected : %d", self.surferSelected);
        
        // CREATE and initialize the water gun state.
        [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"0"] forKey:@"watergun"];

        // Create the frame for animation.
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"objects_anim.plist"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"destruction_anim.plist"];
        
        deathBoatSpr = [CCSprite spriteWithSpriteFrameName:@"death_boatboy_0.png"];
        deathBoatSpr.position = ccp(0, 0);
        [self addChild:deathBoatSpr];
        
        // set the game schedule.
        [self schedule:@selector(moveShark) interval:0.05f];
        [self schedule:@selector(createNewSharks) interval:1.5f];
    }
    
    return self;
}

-(void) createNewSharks
{
    CGSize size = [CCDirector sharedDirector].winSize;
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"objects_anim.plist"];

    sharkline_flag++;
    
    self.mainScene = [MainScene node];
    playerSpr = [self.mainScene getPlayerScene];
    
    int minX = PLAYER_WIDTH_STEP/2 * (arc4random()%2);

    int shark_num;
    
    if (sharkline_flag == 3) {
        
        sharkline_flag = 0;
        shark_num = 12;
        
        // create and initialize the wave sprite.
        rampSpr = [CCSprite spriteWithSpriteFrameName:@"ramp_1.png"];
        rampSpr.position = ccp(minX + arc4random_uniform(10000) % (int)(size.width/5*4 / PLAYER_WIDTH_STEP) * PLAYER_WIDTH_STEP + PLAYER_WIDTH_STEP,
                               size.height - [rampSpr boundingBox].size.height);
        rampSpr.scale = 1.2f;
        
        NSMutableArray *rampFrames = [NSMutableArray array];
        [rampFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"ramp_1.png"]];
        [rampFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"ramp_2.png"]];
        
        CCAnimation *rampAnim = [CCAnimation animationWithFrames:rampFrames delay:0.2f];
        CCAnimate *rampAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:rampAnim]];
        
        [rampSpr runAction:rampAction];
        
        [self addChild:rampSpr];
        
        [_wave addObject:rampSpr];
        
    } else {

        int rand_num = arc4random() % 3;
        if (arc4random() % 3 == 0) {
            for (int k = 0; k <= rand_num; k++) {
                [self createFisherMen];
            }
        } else if (arc4random() % 3 == 1) {
            for (int k = 0; k <= rand_num; k++) {
                [self createRock:0];
            }
        } else if (arc4random() % 3 == 2) {
            for (int k = 0; k <= rand_num; k++) {
                [self createRock:1];
            }
        }
        
        shark_num = 5;
    }

    for (j = 0; j < shark_num; j++) {

        CCSprite *sharkSpr = [CCSprite spriteWithSpriteFrameName:@"static_shark_1.png"];
        
//        sharkSpr.scaleX = playerSpr.scaleX;
//        sharkSpr.scaleY = playerSpr.scaleY * 0.8f;
        
//        minX += [sharkSpr boundingBox].size.width;
        NSLog(@"sharLine_flag = %d", sharkline_flag/3 + 1);
        int actualX;
        if (shark_num == 5) {
            actualX = minX + arc4random_uniform(10000) % (int)(size.width / PLAYER_WIDTH_STEP) * PLAYER_WIDTH_STEP;
        } else if (shark_num == 12) {
            actualX = minX + j * PLAYER_WIDTH_STEP/2;
        }
        

        int actualY = size.height;
        
        sharkSpr.position = ccp(actualX, actualY);
        
        sharkSpr.tag = STATIC_SHARK_OBSTACLE;
        [self addChild:sharkSpr];
        
        if (j == 0) sharkSpr.tag = 101;
        
        // create and initialize the shark animation.
        NSMutableArray *staticSharkFrames = [NSMutableArray array];
        NSMutableArray *movingsharkFrames = [NSMutableArray array];
        for (int k = 0; k < 4; k++) {
            [staticSharkFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache]
                                   spriteFrameByName:[NSString stringWithFormat:@"static_shark_%d.png", k+1]]];
            [movingsharkFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache]
                                          spriteFrameByName:[NSString stringWithFormat:@"moving_shark_%d.png", k+1]]];
        }
        
        CCAnimation *sharkAnim = [CCAnimation animationWithFrames:staticSharkFrames delay:0.1f];
        
        if (shark_num == 5 && sharkline_flag == 1) {        // Horizontal moving shark.
            sharkAnim = [CCAnimation animationWithFrames:movingsharkFrames delay:0.1f];
            sharkSpr.tag = MOVING_SHARK_OBSTACLE;
            [_movingSharks addObject:sharkSpr];
        }
        
        CCAnimate *sharkAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:sharkAnim]];
        [sharkSpr runAction:sharkAction];

        [_sharks addObject:sharkSpr];

    }
}

-(void) createFisherMen
{
    CGSize size = [CCDirector sharedDirector].winSize;
    
    CCSprite *fishingBoatSpr = [CCSprite spriteWithSpriteFrameName:@"fishing_boat_1.png"];
    fishingBoatSpr.position = ccp(arc4random() % (int)(size.width - PLAYER_WIDTH_STEP*3) + PLAYER_WIDTH_STEP, size.height - PLAYER_HEIGHT_STEP);
    
    [self addChild:fishingBoatSpr];
    
    // create the fishing boat animation.
    NSMutableArray *fishingBoatFrames = [NSMutableArray array];
    for (int m = 0; m < 4; m++) {
        [fishingBoatFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache]
                                      spriteFrameByName:[NSString stringWithFormat:@"fishing_boat_%d.png", m+1]]];
    }
    
    id fishingBoatAnim = [CCAnimation animationWithFrames:fishingBoatFrames delay:0.1f];
    id fishingBoatAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:fishingBoatAnim]];
    
    [fishingBoatSpr runAction:fishingBoatAction];
    
    fishingBoatSpr.tag = FISHING_BOAT_OBSTACLE;
    [_sharks addObject:fishingBoatSpr];
}

-(void) createRock:(int) rock_flag;
{
    CGSize size = [CCDirector sharedDirector].winSize;
    
    self.mainScene = [MainScene node];
    playerSpr = [self.mainScene getPlayerScene];
    
    CCSprite *rockSpr = [CCSprite spriteWithSpriteFrameName:@"big_rock_1.png"];
//    rockSpr.scaleX = playerSpr.scaleX;
//    rockSpr.scaleY = playerSpr.scaleY;
    rockSpr.position = ccp(arc4random() % (int)(size.width - PLAYER_WIDTH_STEP) + PLAYER_WIDTH_STEP, size.height - PLAYER_HEIGHT_STEP);

    
    [self addChild:rockSpr];
    
    NSMutableArray *bigRockFrames = [NSMutableArray array];
    NSMutableArray *smallRockFrames = [NSMutableArray array];
    
    for (int k = 0; k < 3; k++) {
        [bigRockFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache]
                                  spriteFrameByName:[NSString stringWithFormat:@"big_rock_%d.png", k+1]]];
        [smallRockFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache]
                                    spriteFrameByName:[NSString stringWithFormat:@"small_rock_%d.png", k+1]]];
    }
    
    CCAnimation *bigRockAnim = [CCAnimation animationWithFrames:bigRockFrames delay:0.1f];
    CCAnimation *smallRockAnim = [CCAnimation animationWithFrames:smallRockFrames delay:1.0f];
    
    CCAnimate *rockAction;
    if (rock_flag == 0) {
        rockSpr.tag = BIG_ROCK_OBSTACLE;
        rockAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:bigRockAnim]];
    }
    if (rock_flag == 1) {
        rockSpr.tag = SMALL_ROCK_OBSTACLE;
        rockAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:smallRockAnim]];
    }
    
    [rockSpr runAction:rockAction];
    
    [_sharks addObject:rockSpr];
}

-(void) setOriginalSharks
{
    CCSprite *sharkSpr = [CCSprite spriteWithSpriteFrameName:@"static_shark_1.png"];

    NSMutableArray *staticSharkFrames = [NSMutableArray array];
    for (int k = 0; k < 4; k++) {
        [staticSharkFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache]
                                      spriteFrameByName:[NSString stringWithFormat:@"static_shark_%d.png", k+1]]];
    }
    
    CCAnimation *sharkAnim = [CCAnimation animationWithFrames:staticSharkFrames delay:0.1f];
    CCAnimate *sharkAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:sharkAnim]];
    [sharkSpr runAction:sharkAction];
    
    self.mainScene = [MainScene node];
    playerSpr = [self.mainScene getPlayerScene];

    int minX = PLAYER_WIDTH_STEP / 2 * (i%2);
    
    int minY = playerSpr.position.y + [sharkSpr boundingBox].size.height * 3;
    
    int actualY = PLAYER_HEIGHT_STEP*1.5*i + minY;
    int actualX = PLAYER_WIDTH_STEP * (arc4random()%6) + minX;
    sharkSpr.position = ccp(actualX, actualY);
    
    sharkSpr.tag = STATIC_SHARK_OBSTACLE;
    [self addChild:sharkSpr];
    
    [_sharks addObject:sharkSpr];
}

-(void) moveShark
{
    watergun_str = [[NSUserDefaults standardUserDefaults] objectForKey:@"watergun"];
    if ([watergun_str isEqualToString:@"1"]) {
        NSLog(@"success");
        watergun_flag = 1;
    }
    
    CGSize size = [CCDirector sharedDirector].winSize;
    
    self.mainScene = [MainScene node];
    playerSpr = [self.mainScene getPlayerScene];
    
    PlayerSaveDate data;
    data = [self.mainScene getCurrentPlayerDetail];
    
    NSLog(@"surfer positio : %f %f", self.playerPos.x, data.surferPosX);
    
    for (CCSprite *movingShark in _sharks) {
        
        if ((movingShark.position.x - self.playerPos.x < [movingShark boundingBox].size.width/2)
            && (movingShark.position.x - self.playerPos.x > -1 * [movingShark boundingBox].size.width/2)
            && (movingShark.position.y - self.playerPos.y < [movingShark boundingBox].size.width/2)
            && (movingShark.position.y - self.playerPos.y > -1 * [movingShark boundingBox].size.width/2)) {

            if (self.waveJumpFlag == 0) {
                
                NSMutableArray *deathSharkBoyFrames = [NSMutableArray array];
                NSMutableArray *deathSharkGirlFrames = [NSMutableArray array];
                NSMutableArray *deathBigRockFrames = [NSMutableArray array];
                NSMutableArray *deathSmallRockFrames = [NSMutableArray array];
                NSMutableArray *deathBoatBoyFrames = [NSMutableArray array];
                NSMutableArray *deathBoatGirlFrames = [NSMutableArray array];
                

                for (int k = 0; k < 9; k++) {
                    [deathSharkBoyFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache]
                                               spriteFrameByName:[NSString stringWithFormat:@"death_sharkboy_%d.png", k+1]]];
                    [deathSharkGirlFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache]
                                                     spriteFrameByName:[NSString stringWithFormat:@"death_sharkgirl_%d.png", k+1]]];
                }
                for (int k1 = 0; k1 < 4; k1++) {
                    [deathBigRockFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache]
                                                   spriteFrameByName:[NSString stringWithFormat:@"death_bigrock_%d.png", k1+1]]];
                    [deathSmallRockFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache]
                                                     spriteFrameByName:[NSString stringWithFormat:@"death_smallrock_%d.png", k1+1]]];
                }
                for (int k2 = 0; k2 <= 6; k2++) {
                    [deathBoatBoyFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache]
                                                   spriteFrameByName:[NSString stringWithFormat:@"death_boatboy_%d.png", k2]]];
                    [deathBoatGirlFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache]
                                                    spriteFrameByName:[NSString stringWithFormat:@"death_boatgirl_%d.png", k2]]];
                }
                
                id deathSharkBoyAction = [CCAnimate actionWithAnimation:[CCAnimation animationWithFrames:deathSharkBoyFrames delay:0.15f]];
                id deathSharkGirlAction = [CCAnimate actionWithAnimation:[CCAnimation animationWithFrames:deathSharkGirlFrames delay:0.15f]];
                id deathBigRockAction = [CCAnimate actionWithAnimation:[CCAnimation animationWithFrames:deathBigRockFrames delay:0.15f]];
                id deathSmallRockAction = [CCAnimate actionWithAnimation:[CCAnimation animationWithFrames:deathSmallRockFrames delay:0.15f]];
                id deathBoatBoyAction = [CCAnimate actionWithAnimation:[CCAnimation animationWithFrames:deathBoatBoyFrames delay:0.15f]];
                id deathBoatGirlAction = [CCAnimate actionWithAnimation:[CCAnimation animationWithFrames:deathBoatGirlFrames delay:0.15f]];
                
                // Create the death animations.
                switch (movingShark.tag) {
                    case STATIC_SHARK_OBSTACLE:
                        if (self.surferSelected == 0) [movingShark runAction:deathSharkBoyAction];
                        if (self.surferSelected == 1) [movingShark runAction:deathSharkGirlAction];
                        break;
                    case MOVING_SHARK_OBSTACLE:
                        if (self.surferSelected == 0) [movingShark runAction:deathSharkBoyAction];
                        if (self.surferSelected == 1) [movingShark runAction:deathSharkGirlAction];
                        break;
                    case BIG_ROCK_OBSTACLE:
                        [movingShark runAction:deathBigRockAction];
                        break;
                    case SMALL_ROCK_OBSTACLE:
                        [movingShark runAction:deathSmallRockAction];
                        break;
                    case FISHING_BOAT_OBSTACLE:
                        deathBoatSpr.position = movingShark.position;
                        [deathBoatSpr setPosition:movingShark.position];
                        if (self.surferSelected == 0) [deathBoatSpr runAction:deathBoatBoyAction];
                        if (self.surferSelected == 1) [deathBoatSpr runAction:deathBoatGirlAction];
                        
                        break;
                        
                    default:
                        break;
                }

                [[NSUserDefaults standardUserDefaults] setValue:@"GameOver" forKey:@"GameState"];
                id delayAnim = [CCDelayTime actionWithDuration:2.0f];
                id removeSurferAnim = [CCCallFunc actionWithTarget:self selector:@selector(gameOver)];
                
                CCAction *gameOverAction = [CCSequence actions:delayAnim, removeSurferAnim, nil];
                [self runAction:gameOverAction];
            }
        }
        
        [movingShark setPosition:ccp(movingShark.position.x, movingShark.position.y - SHARK_HEIGHT_STEP)];
    }
    
    for (CCSprite *horizontalMovingShark in _movingSharks) {

        if (horizontalMovingShark.tag == 101) {
            if (horizontalMovingShark.position.x > size.width || horizontalMovingShark.position.x < -2 * [horizontalMovingShark boundingBox].size.width) {
                horizontal_flag *= -1;
            }
        }
        if (horizontal_flag > 0) horizontalMovingShark.rotation = 180.0f;
        if (horizontal_flag < 0) horizontalMovingShark.rotation = 0.0f;
        
        [horizontalMovingShark setPosition:ccp(horizontalMovingShark.position.x + SHARK_WIDTH_STEP/2*horizontal_flag, horizontalMovingShark.position.y)];
        
    }
    
    for (CCSprite *movingWave in _wave) {
        
        if (ccpDistance(self.playerPos, movingWave.position) < [playerSpr boundingBox].size.width/3*2) {
            if (self.waveJumpFlag == 0) {
                self.waveJumpFlag = 1;
            }
        }
        
        [movingWave setPosition:ccp(movingWave.position.x, movingWave.position.y - SHARK_HEIGHT_STEP)];
        
        if (movingWave.position.y < -50 || watergun_flag == 1) {
            [self removeChild:movingWave cleanup:YES];
            [_wave removeObject:movingWave];
            return;
        }
    }

    for (CCSprite *removingShark in _sharks) {
        if (removingShark.position.y < -50 || watergun_flag == 1) {
            CCAnimation *desAnim;
            CCAction *desAct;
            switch (removingShark.tag) {
                case STATIC_SHARK_OBSTACLE:
                    destructionSpr = [CCSprite spriteWithSpriteFrameName:@"idleshark_destruction_3.png"];
                    destructionSpr.position = removingShark.position;
                    [self addChild:destructionSpr];
                    
                    [_destruction addObject:destructionSpr];
                    
                    NSMutableArray *desFrames1 = [NSMutableArray array];
                    for (i = 0; i < 3; i++) {
                        [desFrames1 addObject:[[CCSpriteFrameCache sharedSpriteFrameCache]
                                              spriteFrameByName:[NSString stringWithFormat:@"idleshark_destruction_%d.png", i+1]]];
                    }
                    desAnim = [CCAnimation animationWithFrames:desFrames1 delay:0.2f];
                    desAct = [CCAnimate actionWithAnimation:desAnim];
                    [destructionSpr runAction:desAct];
                    
                    break;
                    
                case MOVING_SHARK_OBSTACLE:
                    destructionSpr = [CCSprite spriteWithSpriteFrameName:@"movingshark_destruction_3.png"];
                    destructionSpr.position = removingShark.position;
                    [self addChild:destructionSpr];
                    [_destruction addObject:destructionSpr];
                    
                    NSMutableArray *desFrames2 = [NSMutableArray array];
                    for (i = 0; i < 3; i++) {
                        [desFrames2 addObject:[[CCSpriteFrameCache sharedSpriteFrameCache]
                                              spriteFrameByName:[NSString stringWithFormat:@"movingshark_destruction_%d.png", i+1]]];
                    }
                    desAnim = [CCAnimation animationWithFrames:desFrames2 delay:0.2f];
                    desAct = [CCAnimate actionWithAnimation:desAnim];
                    [destructionSpr runAction:desAct];
                    
                    break;
                    
                case BIG_ROCK_OBSTACLE:
                    destructionSpr = [CCSprite spriteWithSpriteFrameName:@"bigrock_destruction_3.png"];
                    destructionSpr.position = removingShark.position;
                    [self addChild:destructionSpr];
                    [_destruction addObject:destructionSpr];
                    
                    NSMutableArray *desFrames3 = [NSMutableArray array];
                    for (i = 0; i < 3; i++) {
                        [desFrames3 addObject:[[CCSpriteFrameCache sharedSpriteFrameCache]
                                               spriteFrameByName:[NSString stringWithFormat:@"bigrock_destruction_%d.png", i+1]]];
                    }
                    desAnim = [CCAnimation animationWithFrames:desFrames3 delay:0.2f];
                    desAct = [CCAnimate actionWithAnimation:desAnim];
                    [destructionSpr runAction:desAct];
                    
                    break;
                    
                case SMALL_ROCK_OBSTACLE:
                    destructionSpr = [CCSprite spriteWithSpriteFrameName:@"smallrock_destruction_3.png"];
                    destructionSpr.position = removingShark.position;
                    [self addChild:destructionSpr];
                    [_destruction addObject:destructionSpr];
                    
                    NSMutableArray *desFrames4 = [NSMutableArray array];
                    for (i = 0; i < 3; i++) {
                        [desFrames4 addObject:[[CCSpriteFrameCache sharedSpriteFrameCache]
                                               spriteFrameByName:[NSString stringWithFormat:@"smallrock_destruction_%d.png", i+1]]];
                    }
                    desAnim = [CCAnimation animationWithFrames:desFrames4 delay:0.2f];
                    desAct = [CCAnimate actionWithAnimation:desAnim];
                    [destructionSpr runAction:desAct];
                    
                    break;
                    
                case FISHING_BOAT_OBSTACLE:
                    destructionSpr = [CCSprite spriteWithSpriteFrameName:@"boat_destruction_3.png"];
                    destructionSpr.position = removingShark.position;
                    [self addChild:destructionSpr];
                    [_destruction addObject:destructionSpr];
                    
                    NSMutableArray *desFrames5 = [NSMutableArray array];
                    for (i = 0; i < 3; i++) {
                        [desFrames5 addObject:[[CCSpriteFrameCache sharedSpriteFrameCache]
                                               spriteFrameByName:[NSString stringWithFormat:@"boat_destruction_%d.png", i+1]]];
                    }
                    desAnim = [CCAnimation animationWithFrames:desFrames5 delay:0.2f];
                    desAct = [CCAnimate actionWithAnimation:desAnim];
                    [destructionSpr runAction:desAct];
                    
                    break;
                    
                default:
                    break;
            }

            [removingShark removeFromParentAndCleanup:YES];
            [_sharks removeObject:removingShark];
            NSLog(@"array size : %d", _sharks.count);
            return;
        }
    }
    
    for (CCSprite *desSpr in _destruction) {
        [desSpr removeFromParentAndCleanup:YES];
        [_destruction removeObject:desSpr];
        return;
    }
    
    if (watergun_flag == 1 && _sharks.count < 3) {
        watergun_flag = 0;
        [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"0"] forKey:@"watergun"];
    }
}

-(void) deathBoatRemoving
{
    [self removeChild:deathBoatSpr cleanup:YES];
}

-(void) gameOver
{
    NSLog(@"Game OVer");
//    [self stopAllActions];
//    [self unschedule:@selector(moveShark)];
//    [self unschedule:@selector(createNewSharks)];

    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[GameOver scene]]];
}

-(void) dealloc
{
    [_sharks release];
    [_movingSharks release];
    [_wave release];
    
    [super dealloc];
}

@end
