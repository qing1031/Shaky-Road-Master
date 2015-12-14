//
//  XLDashedLine.h
//  XLDashedLine
//
//  Created by Richard Wei on 11-8-31.
//  Copyright 2011 Xinranmsn Labs. All rights reserved.
//

#import "cocos2d.h"

@interface XLDashedLine : CCNode {
    CGPoint _startPoint, _endPoint, _scaledStartPoint, _scaledEndPoint;
    float _width, _scaledWidth;
    ccColor4F _color;
    float _dashLength, _scaledDashLength;
}

@property (nonatomic, assign) CGPoint startPoint, endPoint;
@property (nonatomic, assign) float width;
@property (nonatomic, assign) ccColor4F color;
@property (nonatomic, assign) float dashLength;


- (id)initWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint width:(float)width color:(ccColor4F)color dashLength:(float)dashLength;
+ (id)lineWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint width:(float)width color:(ccColor4F)color dashLength:(float)dashLength;

@end
