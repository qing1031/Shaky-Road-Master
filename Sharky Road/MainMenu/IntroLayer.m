//
//  IntroLayer.m
//  Sharky Waters
//
//  Created by Superstar on 9/30/15.
//  Copyright Superstar 2015. All rights reserved.
//


// Import the interfaces
#import "IntroLayer.h"
#import "MainScene.h"


#pragma mark - IntroLayer

// MainScene implementation
@implementation IntroLayer

// Helper class method that creates a Scene with the MainScene as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	IntroLayer *layer = [IntroLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// 
-(id) init
{
	if( (self=[super init])) {

		// ask director for the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
        
        self.isTouchEnabled = YES;

		CCSprite *background;
		
		if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
			background = [CCSprite spriteWithFile:@"menu_background.png"];
		} else {
			background = [CCSprite spriteWithFile:@"menu_background.png"];
		}
        background.scaleX = size.width / [background boundingBox].size.width;
        background.scaleY = size.height / [background boundingBox].size.height;
		background.position = ccp(size.width/2, size.height/2);
        NSLog(@"scale = %f, %f", background.scaleX, background.scaleY);

		// add the label as a child to this Layer
		[self addChild: background];
        
        CCMenuItemImage *gunItem = [CCMenuItemImage itemFromNormalImage:@"gun_on.png"
                                                          selectedImage:@"gun_off.png"
                                                                 target:self selector:@selector(buyGun)];
        gunItem.position = ccp(size.width - [gunItem boundingBox].size.width, [gunItem boundingBox].size.height);
        gunItem.scaleX = background.scaleX;
        gunItem.scaleY = background.scaleY;
        
        CCMenuItemImage *buyItem = [CCMenuItemImage itemFromNormalImage:@"buy.png"
                                                          selectedImage:@"buy.png"
                                                                 target:self selector:@selector(buyGun)];
        buyItem.position = ccp(gunItem.position.x, gunItem.position.y + [gunItem boundingBox].size.height/2);
        buyItem.scaleX = background.scaleX;
        buyItem.scaleY = background.scaleY;
        
        CCMenu *menu = [CCMenu menuWithItems:gunItem, buyItem, nil];
        menu.position = CGPointZero;
        [self addChild:menu];
	}
	
	return self;
}

-(void) buyGun
{
    
}


-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

   	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:2.0f scene:[MainScene scene] ]];
    
}

@end
