//
//  XLDashedLine.m
//  XLDashedLine
//
//  Created by Richard Wei on 11-8-31.
//  Copyright 2011 Xinranmsn Labs. All rights reserved.
//

#import "XLDashedLine.h"

static ccColor4F ccc4F(float _r, float _g, float _b, float _a) {
    ccColor4F retColor = {_r, _g, _b, _a};
    return retColor;
}

#define ccp2ccpr(__point__) ccp(__point__.x * CC_CONTENT_SCALE_FACTOR(), __point__.y * CC_CONTENT_SCALE_FACTOR())
#define ccpr2ccp(__point__) ccp(__point__.x / CC_CONTENT_SCALE_FACTOR(), __point__.y / CC_CONTENT_SCALE_FACTOR())
#define ccpr(__x__, __y__) ccp(__x__ * CC_CONTENT_SCALE_FACTOR(), __y__ * CC_CONTENT_SCALE_FACTOR())
#define sclr2sclrr(__scl__) ((__scl__) * CC_CONTENT_SCALE_FACTOR())

@implementation XLDashedLine

@synthesize startPoint = _startPoint, endPoint = _endPoint, width = _width, color = _color, dashLength = _dashLength;

- (id)init {
    if ((self = [super init])) {
        self.startPoint = CGPointZero;
        self.endPoint = CGPointZero;
        self.width = .0f;
        self.color = ccc4F(.0f, .0f, .0f, .0f);
        self.dashLength = .0f;
    }
    return self;
}

- (id)initWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint width:(float)width color:(ccColor4F)color dashLength:(float)dashLength {
    if ((self = [super init])) {
        self.startPoint = startPoint;
        self.endPoint = endPoint;
        self.width = width;
        self.color = color;
        self.dashLength = dashLength;
    }
    return self;
}

+ (id)lineWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint width:(float)width color:(ccColor4F)color dashLength:(float)dashLength {
    return [[[self alloc] initWithStartPoint:startPoint endPoint:endPoint width:width color:color dashLength:dashLength] autorelease];
}

static inline void drawDashedLine(CGPoint origin, CGPoint destination, float dashLength) {
	float dx = destination.x - origin.x;
    float dy = destination.y - origin.y;
    float dist = sqrtf(dx * dx + dy * dy);
    float x = dx / dist * dashLength;
    float y = dy / dist * dashLength;
    CGPoint p2;
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	glDisableClientState(GL_COLOR_ARRAY);
    glEnable(GL_LINE_SMOOTH);
    for (float i = 0.0f; i <= dist / dashLength * .5; i++) {
        p2.x = origin.x + x;
        p2.y = origin.y + y;
        ccVertex2F vertices[2] = {origin.x, origin.y, p2.x, p2.y};
        glVertexPointer(2, GL_FLOAT, 0, vertices);
        glDrawArrays(GL_LINES, 0, 2);
        origin.x += x * 2;
        origin.y += y * 2;
    }
    glDisable(GL_LINE_SMOOTH);
    glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glEnable(GL_TEXTURE_2D);
}

- (void)draw {
    glLineWidth(_scaledWidth);
    glColor4f(_color.r, _color.g, _color.b, _color.a);
    drawDashedLine(_scaledStartPoint, _scaledEndPoint, _scaledDashLength);
    glLineWidth(1.0f);
    [super draw];
}

- (void)setStartPoint:(CGPoint)startPoint {
    _startPoint = startPoint;
    _scaledStartPoint = ccp2ccpr(startPoint);
}

- (void)setEndPoint:(CGPoint)endPoint {
    _endPoint = endPoint;
    _scaledEndPoint = ccp2ccpr(endPoint);
}

- (void)setWidth:(float)width {
    _width = width;
    _scaledWidth = sclr2sclrr(width);
}

- (void)setDashLength:(float)dashLength {
    _dashLength = dashLength;
    _scaledDashLength = sclr2sclrr(dashLength);
}

@end
