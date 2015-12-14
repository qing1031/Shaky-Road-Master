//
//  MainScene.m
//  XLDashedLine
//
//  Created by Richard Wei on 11-12-20.
//  Copyright Xinranmsn Labs 2011年. All rights reserved.
//


// Import the interfaces
#import "MainScene.h"
#import "XLDashedLine.h"

#import "PlayerMoveComponent.h"
#import "ScoreManage.h"
#import "Shark.h"

//#import "GADBannerView.h"
//#import "GADRequest.h"


static ccColor4F ccc4F(float _r, float _g, float _b, float _a) {
    ccColor4F retColor = {_r, _g, _b, _a};
    return retColor;
}

// MainScene implementation
@implementation MainScene

static id _sharedPlayingScene = nil;

+(id)SharedPlayingScene{
    if (!_sharedPlayingScene) {
        _sharedPlayingScene = [[self alloc] getPlayerScene];
        return _sharedPlayingScene;
    }
    return _sharedPlayingScene;
}

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MainScene *layer = [MainScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (void)onEnterTransitionDidFinish {	
    // new task
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:-1 swallowsTouches:YES];
    [super onEnterTransitionDidFinish];
}

- (void)onExit {
    [[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
    [super onExit];
}

// on "init" you need to initialize your instance
- (id)init {
	if ((self = [super init])) {

        // ask director for the window size.
        size = [CCDirector sharedDirector].winSize;

        self.isTouchEnabled = YES;
        gamestart_flag = 0;
        counter = 4;
        player_direct = 0;
        touched = TRUE;
        
        _backgroundAry = [[NSMutableArray alloc] init];
        _backgroundbaseAry = [[NSMutableArray alloc] init];
        _cloud = [[NSMutableArray alloc] init];

        for (int j = 0; j < 3; j++) {
            CCSprite *ocean_base = [CCSprite spriteWithFile:@"ocean_base_bottom.png"];
            ocean_base.scaleX = size.width / [ocean_base boundingBox].size.width;
            ocean_base.scaleY = size.height / [ocean_base boundingBox].size.height;
            ocean_base.position = ccp(size.width / 2, size.height /2 + size.height*j);
            
            [self addChild:ocean_base];
            
            [_backgroundbaseAry addObject:ocean_base];
        }
        
        // create and initialize a gameplay backgrounds.
        for (int i = 0; i < 3; i++) {
            CCSprite *ocean_top = [CCSprite spriteWithFile:@"ocean_texture_top.png"];
            ocean_top.scale = size.width / [ocean_top boundingBox].size.width;
            ocean_top.position = ccp(size.width / 2, size.height/2 + ([ocean_top boundingBox].size.height-1)*i);
        
            [self addChild:ocean_top];
            
            [_backgroundAry addObject:ocean_top];
            
        }
        
        gameScaleX = size.width/640;
        gameScaleY = size.height/1136;

        // create and initialize a boat and surfer sprite.
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"objects_anim.plist"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"character_anim.plist"];
        
//        boatSpr = [CCSprite spriteWithSpriteFrameName:@"speedboat_1.png"];
//        boatSpr.position = ccp((size.width/PLAYER_WIDTH_STEP/2) * PLAYER_WIDTH_STEP, size.height / 5*4);
//        [self addChild:boatSpr z:6];
        

        surferSelected = arc4random()%2;
        shark.surferSelected = surferSelected;

        surferSpr = [CCSprite spriteWithSpriteFrameName:@"surf_boy_1.png"];
        surferSpr.position = ccp(PLAYER_WIDTH_STEP * 1.5, size.height / 4);
        first_surferPosX = surferSpr.position.x;        // save the x position in the game beginning.
        
		label = [CCLabelTTF labelWithString:@"Tabs the screen" fontName:@"HelveticaNeue-Bold" fontSize:32];
		label.position =  ccp( size.width /2 , size.height/2 );
        label.color = ccWHITE;
		[self addChild: label z:10];
        
        // Create the game state.
        [[NSUserDefaults standardUserDefaults] setValue:@"GameStart" forKey:@"GameState"];
        
        // create and initialize the admob.
        [self createAdmobAds];
    }
    
	return self;
}

-(void) createAdmobAds
{
//    mBannerType = BANNER_TYPE;
    
//    if (mBannerType <= kBanner_Portrait_Bottom) {
//        mBannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
//    } else {
//        mBannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerLandscape];
//    }
    
    // Specity the ad's "unit identifier."
//    mBannerView.adUnitID = @"ca-app-pub-3940256099942544/2934735716";
    
    
    // let the runtime know which UIViewVController to restore after talking
    // the user wherever the ad goes and ada it to the view hierachy.\
    
//    mBannerView.rootViewController = self;
    
}

-(PlayerSaveDate) getCurrentPlayerDetail
{
    PlayerSaveDate data;
    data.surferPosX = surferSpr.position.x;
    data.surferPosY = surferSpr.position.y;
    
    NSLog(@"getCurrentPlayerDetail = %f", surferSpr.position.x);
    
    return data;
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    
    CGPoint current_pos = [[CCDirector sharedDirector] convertToGL:[touch locationInView:touch.view]];
    first_pos = [self convertToNodeSpace:current_pos];
    
    if (gamestart_flag == 0) {
        [self removeChild:label cleanup:YES];
        [self removeChild:shadowSpr cleanup:YES];

        // Create the game player.
        boatSpr = [CCSprite spriteWithSpriteFrameName:@"speedboat_1.png"];
        boatSpr.position = ccp((size.width/PLAYER_WIDTH_STEP/2) * PLAYER_WIDTH_STEP, size.height / 5*4);
        [self addChild:boatSpr z:6];
        
        surferSpr = [CCSprite spriteWithSpriteFrameName:@"surf_boy_1.png"];
        surferSpr.position = ccp(PLAYER_WIDTH_STEP * 1.5, size.height / 4);
        first_surferPosX = surferSpr.position.x;        // save the x position in the game beginning.
        
        [self addChild:surferSpr z:6];
        
        shark.playerPos = surferSpr.position;
        
        PlayerSaveDate data;
        data.surferPosX = surferSpr.position.x;
        data.surferPosY = surferSpr.position.y;
        
        line = [XLDashedLine lineWithStartPoint:surferSpr.position endPoint:surferSpr.position width:1.0 color:ccc4F(1.5, 1.5, 0.5, 1.0) dashLength:1.0];
        //        line.visible = NO;
        line.startPoint = boatSpr.position;
        line.endPoint = surferSpr.position;
        [self addChild:line z:5];
        
        [self schedule:@selector(setCountDown) interval:0.1f];
        gamestart_flag = 1;
    }
    
    if (gamestart_flag != 0 && touched == TRUE) {
        [self playerDirect:first_pos];
        first_surferPosX = surferSpr.position.x;
    }
    
    return YES;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    
    CGPoint touch_pos = [self convertToNodeSpace:[[CCDirector sharedDirector] convertToGL:[touch locationInView:touch.view]]];
    
//    if (player_direct == 0) {
//        [self playerDirect:touch_pos];
//        first_surferPosX = surferSpr.position.x;
//    }
    
//    line.startPoint = boatSpr.position;
//    line.endPoint = location;
//    line.visible = YES;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
//    line.visible = NO;
//    player_direct = 0;
}

-(void) playerDirect:(CGPoint) current_pos
{
    size = [CCDirector sharedDirector].winSize;
    
    if ((surferSpr.position.x < 10) || (surferSpr.position.x > size.width - 10)) {      // surfer move widge.
//        player_direct = 0;
    }
    
    // slide
/*    if ((current_pos.x > surferSpr.position.x) && (surferSpr.position.x < size.width / 5*4)) {           // move to right.
        if (player_direct == -1) {
            player_direct = 0;
        } else if (player_direct == 0) {
            player_direct = 1;
        }
    } else if ((current_pos.x < surferSpr.position.x) && (surferSpr.position.x > [surferSpr boundingBox].size.width/2)) {    // move to left.
        if (player_direct == 1) {
            player_direct = 0;
        } else if (player_direct == 0) {
            player_direct = -1;
        }
    } else {
        player_direct = 0;
    }*/
    
    // swipe
    if (current_pos.x >= size.width/2) {           // move to right.
        if (player_direct == -1) {
//            player_direct = 0;
        } else if (player_direct == 0) {
            player_direct = 1;
        }
        
     } else if (current_pos.x < size.width/2) {    // move to left.
         if (player_direct == 1) {
//             player_direct = 0;
         } else if (player_direct == 0) {
             player_direct = -1;
        }

     } else {
         player_direct = 0;
     }
}

-(void) setCountDown
{
    counter--;
    if (counterLabel != nil) {
        [self removeChild:counterLabel cleanup:YES];
    }

    size = [CCDirector sharedDirector].winSize;
    
    NSString *lbStr = [NSString stringWithFormat:@"%d", counter];
    if (counter == 0) lbStr = @"GO";
    counterLabel = [CCLabelTTF labelWithString:lbStr fontName:@"HelveticaNeue-Bold" fontSize:78.0f];
    counterLabel.position = ccp(size.width / 2, size.height / 2);
    counterLabel.color = ccRED;
    
    [self addChild:counterLabel];

    // Boat Animation.
    NSMutableArray *boatFrames = [NSMutableArray array];
    for (int i = 0; i < 4; i++) {
        [boatFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache]
                               spriteFrameByName:[NSString stringWithFormat:@"speedboat_%d.png", i+1]]];
    }
    
    CCAnimation *boatAnim = [CCAnimation animationWithFrames:boatFrames delay:0.1f];
    boatAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:boatAnim]];

    [boatSpr runAction:boatAction];
    
    id labelEffect = [CCScaleTo actionWithDuration:1.0f scale:0.5f];
    [counterLabel runAction:labelEffect];
    
    if (counter == -1) {
        [self removeChild:counterLabel cleanup:YES];
        [self unschedule:@selector(setCountDown)];
        
        // Create and Initialize the start game.
        [self gameStart];
        gamestart_flag = 1;
    }
}

-(void) gameStart
{
    size = [CCDirector sharedDirector].winSize;
    
    // create and initialize the score sprite
    scoreManage = [ScoreManage node];
    [self addChild:scoreManage z:10];
    
    // create and initialize the surfer animation.
    NSMutableArray *surferBoyFrames = [NSMutableArray array];
    NSMutableArray *surferGirlFrames = [NSMutableArray array];
    for (int i = 0; i < 4; i++) {
        [surferBoyFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"surf_boy_%d.png", i+1]]];
        [surferGirlFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"surf_girl_%d.png", i+1]]];
    }
    
    id surferBoyAnim = [CCAnimation animationWithFrames:surferBoyFrames delay:0.1f];
    id surferGirlAnim = [CCAnimation animationWithFrames:surferGirlFrames delay:0.1f];
    
    CCAnimate *surferAction;
    if (surferSelected == 0) {
        surferAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:surferBoyAnim]];
    } else if (surferSelected == 1) {
        surferAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:surferGirlAnim]];
    }

    [surferSpr runAction:surferAction];
    
    // create the wave of the surfer and set the animation of the sprite.
    surferWaveSpr = [CCSprite spriteWithSpriteFrameName:@"wave_1.png"];
    surferWaveSpr.position = ccp(surferSpr.position.x, surferSpr.position.y - [surferWaveSpr boundingBox].size.height/2);
    [self addChild:surferWaveSpr];
    
    NSMutableArray *surferWaveFrames = [NSMutableArray array];
    for (int j = 0; j < 4; j++) {
        [surferWaveFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"wave_%d.png", j+1]]];
    }
    
    id surferWaveAnim = [CCAnimation animationWithFrames:surferWaveFrames delay:0.1f];
    id surferWaveAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:surferWaveAnim]];
    
    [surferWaveSpr runAction:surferWaveAction];
    
    
    // create and initialize the water gun sprite.
    gunBtn = [CCMenuItemImage itemFromNormalImage:@"gun_on.png" selectedImage:@"gun_off.png" target:self selector:@selector(shootGun)];
    gunBtn.position = ccp(size.width - [gunBtn boundingBox].size.width/3, size.height/4*3);
//    gunBtn.scale = 0.6f;
    
    CCMenu *gunMenu = [CCMenu menuWithItems:gunBtn, nil];
    gunMenu.position = CGPointZero;
    [self addChild:gunMenu z:11];
    
    id boatMove = [CCMoveTo actionWithDuration:2.0f position:ccp(size.width / 3*2, size.height / 4*5)];
    [boatSpr runAction:boatMove];
    
    cloud_index = 0;
    
    [self schedule:@selector(gameState) interval:0.01f];
    [self schedule:@selector(moveCloud) interval:2.0f];
    
    // create and initialize the player move action.
    [[PlayerMoveComponent alloc] init];
    
    shark = [Shark node];
    shark.surferSelected = surferSelected;
    [self addChild:shark z:3];
}

-(void) shootGun
{
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"destruction_anim.plist"];
    
    // Create and initialize the beam animation.
    beamSpr = [CCSprite spriteWithSpriteFrameName:@"beam_1.png"];
    beamSpr.position = ccp(surferSpr.position.x, surferSpr.position.y + [beamSpr boundingBox].size.height/2 + [surferSpr boundingBox].size.height/3);
    [self addChild:beamSpr];
    
    NSMutableArray *beamFrames = [NSMutableArray array];
    for (int i = 0; i < 4; i++) {
        [beamFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache]
                               spriteFrameByName:[NSString stringWithFormat:@"beam_%d.png", i+1]]];
    }
    
    id beamAnim = [CCAnimation animationWithFrames:beamFrames delay:0.1f];
    id beamAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:beamAnim]];
    
    [beamSpr runAction:beamAction];
    
    id removeItem = [CCDelayTime actionWithDuration:1.0f];
    id removeAction = [CCCallFunc actionWithTarget:self selector:@selector(removeBeam)];
    
    id act = [CCSequence actions:removeItem, removeAction, nil];
    [self runAction:act];
    
    NSString *str = [NSString stringWithFormat:@"1"];
    [[NSUserDefaults standardUserDefaults] setValue:str forKey:@"watergun"];
    
    gunBtn.isEnabled = NO;
}

-(void) removeBeam
{
    [self removeChild:beamSpr cleanup:YES];
    gunBtn.isEnabled = YES;
    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"0"] forKey:@"watergun"];
}

-(void) moveCloud
{
   
    cloud_index++;
    if (cloud_index % 2 == 1) {
        return;
    }
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"destruction_anim.plist"];
    
    CCSprite *cloudSpr = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"cloud_%d.png", arc4random()%4+1]];
    int minX = size.width / 4;
    int maxX = size.width / 4*3;
    int actualX = arc4random() % (maxX - minX) + minX;
    cloudSpr.position = ccp(actualX, size.height / 5*6);
    cloudSpr.scale = 1.5f;
    
    [self addChild:cloudSpr z:10];
    
    [_cloud addObject:cloudSpr];
}

-(void) gameState
{
    line.startPoint = boatSpr.position;
    line.endPoint = surferSpr.position;
    line.visible = YES;
    
    // background base moving effect.
//    for (CCSprite *backbaseSpr in _backgroundbaseAry) {
//        if (backbaseSpr.position.y <= -1 * size.height/2) {
//            backbaseSpr.position = ccp(size.width/2, backbaseSpr.position.y + size.height*2);
//        }
//        
//        [backbaseSpr setPosition:ccp(backbaseSpr.position.x, backbaseSpr.position.y - SHARK_HEIGHT_STEP/3)];
//    }
    
    // background moving effect.
    for (CCSprite *backSpr in _backgroundAry) {
        if (backSpr.position.y <= -1 * [backSpr boundingBox].size.height/2) {
            backSpr.position = ccp(size.width/2, backSpr.position.y + [backSpr boundingBox].size.height*2);
        }

        [backSpr setPosition:ccp(backSpr.position.x, backSpr.position.y - SHARK_HEIGHT_STEP/2)];
    }
    
    // cloud moving effect.
    for (CCSprite *cloudSpr in _cloud) {
        if (cloudSpr.position.y < -10.0f) {
            [self removeChild:cloudSpr cleanup:YES];
        }
        
        [cloudSpr setPosition:ccp(cloudSpr.position.x, cloudSpr.position.y - SHARK_HEIGHT_STEP/4)];
    }
    
    if (shark.waveJumpFlag == 1) {
        
        shark.waveJumpFlag++;

        // create and initialize the jumping surfer.
        NSMutableArray *jumpingBoyFrames = [NSMutableArray array];
        NSMutableArray *jumpingGirlFrames = [NSMutableArray array];
        for (int i = 0; i < 9; i++) {
            [jumpingBoyFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache]
                                         spriteFrameByName:[NSString stringWithFormat:@"jumping_boy_%d.png", i+1]]];
            [jumpingGirlFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache]
                                         spriteFrameByName:[NSString stringWithFormat:@"jumping_girl_%d.png", i+1]]];
        }
        
        id jumpingBoyAnim = [CCAnimation animationWithFrames:jumpingBoyFrames delay:0.2f];
        id jumpingGirlAnim = [CCAnimation animationWithFrames:jumpingGirlFrames delay:0.2f];
        
        CCAction *jumpingSurferAction;
        if (surferSelected == 0) {
            jumpingSurferAction = [CCAnimate actionWithAnimation:jumpingBoyAnim];
        } else if (surferSelected == 1) {
            jumpingSurferAction = [CCAnimate actionWithAnimation:jumpingGirlAnim];
        }
        id jumpingStopAction = [CCCallFunc actionWithTarget:self selector:@selector(setNextStep)];
        id jumpingAction = [CCSequence actions:jumpingSurferAction, jumpingStopAction, nil];
        
        [surferSpr runAction:jumpingAction];
    }
    
    // create and initialize the surfer moving actions.
    if (surferSpr.position.x > first_surferPosX - PLAYER_WIDTH_STEP/2 && surferSpr.position.x < first_surferPosX + PLAYER_WIDTH_STEP/2) {
        [surferSpr setPosition:ccp(surferSpr.position.x + PLAYER_WIDTH_STEP/15 * player_direct, surferSpr.position.y)];
        [surferWaveSpr setPosition:ccp(surferSpr.position.x, surferWaveSpr.position.y)];
        shark.playerPos = surferSpr.position;
        
        if (player_direct != 0) {
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"character_anim.plist"];
            if (player_direct > 0) {
                switch (surferSelected) {
                    case 0:
                        [surferSpr setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"boy_right.png"]];
                        break;
                    case 1:
                        [surferSpr setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"girl_right.png"]];
                        break;
                    default:
                        break;
                }
            } else if (player_direct < 0) {
                switch (surferSelected) {
                    case 0:
                        [surferSpr setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"boy_left.png"]];
                        break;
                    case 1:
                        [surferSpr setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"girl_left.png"]];
                    default:
                        break;
                }
            }
            touched = FALSE;
        }
    } else {
        touched = TRUE;
        player_direct = 0;
    }
    
    // set the surfer move action state.
    if (surferSpr.position.x < 0) {
//        surferSpr.position = ccp([surferSpr boundingBox].size.width/2, surferSpr.position.y);
        player_direct = 1;
    }
    if (surferSpr.position.x > size.width) {
//        surferSpr.position = ccp(size.width - 15, surferSpr.position.y);
        player_direct = -1;
    }
    
    // Game Over
    NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"GameState"];
    if ([str isEqualToString:@"GameOver"]) {
        [self gameOver];
    }
    
    // Set the water gun btn property.
    NSString *gun_flag = [[NSUserDefaults standardUserDefaults] objectForKey:@"watergun"];
    if ([gun_flag isEqualToString:@"1"]) {
//        gunBtn.isEnabled = YES;
    }
}

-(void) setNextStep
{
    shark.waveJumpFlag = 0;
}

-(id) getPlayerScene
{
    return surferSpr;
}

-(void) gameOver
{
    surferSpr.visible = NO;
    surferSpr.position = ccp(size.width, size.height*1.5);
    surferWaveSpr.visible = NO;
    surferWaveSpr.position = ccp(size.width, size.height*1.5);
    line.visible = NO;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// don't forget to call "super dealloc"
	[super dealloc];
}

@end
