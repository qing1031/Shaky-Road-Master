//
//  AppDelegate.h
//  XLDashedLine
//
//  Created by Richard Wei on 11-12-20.
//  Copyright Xinranmsn Labs 2011年. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
