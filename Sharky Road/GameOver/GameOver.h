//
//  GameOver.h
//  Sharky Road
//
//  Created by Superstar on 10/8/15.
//  Copyright 2015 Xinranmsn Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameOver : CCLayer {
    
    int highScore;
    
}

// returns a CCScene that contains the MainScene as the only child
+(CCScene *) scene;


@end
