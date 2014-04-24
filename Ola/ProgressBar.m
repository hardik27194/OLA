//
//  ProgressBar.m
//  Ola
//
//  Created by Terrence Xing on 4/24/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#import "ProgressBar.h"

@implementation ProgressBar

@synthesize max,progress;

@synthesize progressPercent;

- (id)init
{
	return [self initWithFrame: CGRectZero] ;
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame: frame] ;
	if (self)
	{
		self.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0];
		//borderColor = [UIColor lightGrayColor] ;
        trackColor = [UIColor grayColor];
        progressColor = [UIColor blueColor];
        max=100;
        progress=0;
	}
	return self ;
}

-(void) setProgress:(float)mProgress
{
    progress=mProgress;
    progressPercent=mProgress/max;
    if(progressPercent<0)progressPercent=0;
    if(progressPercent>1)progressPercent=1;
     NSLog(@"progress progressPercent=%f",progressPercent);
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    
	CGContextRef context = UIGraphicsGetCurrentContext() ;
    
	// save the context
	CGContextSaveGState(context) ;
    
	// allow antialiasing
	CGContextSetAllowsAntialiasing(context, TRUE) ;
    
	// we first draw the outter rounded rectangle
	rect = CGRectInset(rect, 1.0f, 1.0f) ;
	CGFloat radius = 0.5f * rect.size.height ;
    
    [trackColor setFill] ;
    
	CGContextBeginPath(context) ;
	CGContextMoveToPoint(context, CGRectGetMinX(rect), CGRectGetMidY(rect)) ;
	CGContextAddArcToPoint(context, CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetMidX(rect), CGRectGetMinY(rect), radius) ;
	CGContextAddArcToPoint(context, CGRectGetMaxX(rect), CGRectGetMinY(rect), CGRectGetMaxX(rect), CGRectGetMidY(rect), radius) ;
	CGContextAddArcToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect), CGRectGetMidX(rect), CGRectGetMaxY(rect), radius) ;
	CGContextAddArcToPoint(context, CGRectGetMinX(rect), CGRectGetMaxY(rect), CGRectGetMinX(rect), CGRectGetMidY(rect), radius) ;
	CGContextClosePath(context) ;
	CGContextFillPath(context) ;
    
    //border
    if(borderColor!=nil)
    {
        
    [borderColor setStroke] ;
	CGContextSetLineWidth(context, 2.0f) ;
    
	CGContextBeginPath(context) ;
	CGContextMoveToPoint(context, CGRectGetMinX(rect), CGRectGetMidY(rect)) ;
	CGContextAddArcToPoint(context, CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetMidX(rect), CGRectGetMinY(rect), radius) ;
	CGContextAddArcToPoint(context, CGRectGetMaxX(rect), CGRectGetMinY(rect), CGRectGetMaxX(rect), CGRectGetMidY(rect), radius) ;
	CGContextAddArcToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect), CGRectGetMidX(rect), CGRectGetMaxY(rect), radius) ;
	CGContextAddArcToPoint(context, CGRectGetMinX(rect), CGRectGetMaxY(rect), CGRectGetMinX(rect), CGRectGetMidY(rect), radius) ;
	CGContextClosePath(context) ;
	CGContextDrawPath(context, kCGPathStroke) ;
    }
    
    if(borderColor==nil)rect = CGRectInset(rect, 0.0f, 0.0f) ;
    else rect = CGRectInset(rect, 1.0f, 1.0f) ;
    // draw the inside moving filled rounded rectangle
	radius = 0.5f * rect.size.height ;
    // make sure the filled rounded rectangle is not smaller than 2 times the radius

	rect.size.width *= progressPercent ;
    float trueWidth=rect.size.width;
	if (rect.size.width < 2 * radius)
		rect.size.width = 2 * radius ;
    
	[progressColor setFill] ;
    
	CGContextBeginPath(context) ;
	CGContextMoveToPoint(context, CGRectGetMinX(rect), CGRectGetMidY(rect)) ;
	CGContextAddArcToPoint(context, CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetMidX(rect), CGRectGetMinY(rect), radius) ;
	CGContextAddArcToPoint(context, CGRectGetMaxX(rect), CGRectGetMinY(rect), CGRectGetMaxX(rect), CGRectGetMidY(rect), radius) ;
	CGContextAddArcToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect), CGRectGetMidX(rect), CGRectGetMaxY(rect), radius) ;
	CGContextAddArcToPoint(context, CGRectGetMinX(rect), CGRectGetMaxY(rect), CGRectGetMinX(rect), CGRectGetMidY(rect), radius) ;
	CGContextClosePath(context) ;
	CGContextFillPath(context) ;
    /*
    if (trueWidth < 2 * radius)
	{
        //clear the circle
        [trackColor setFill];
        
        //设置颜色
        //CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 1.0);
        //开始一个起始路径
        CGContextBeginPath(context);
        //起始点设置为(0,0):注意这是上下文对应区域中的相对坐标，
        CGContextMoveToPoint(context, trueWidth+rect.origin.x, rect.origin.y);
        //设置下一个坐标点
        CGContextAddLineToPoint(context, rect.size.width+rect.origin.x,rect.origin.y);
        //设置下一个坐标点
        CGContextAddLineToPoint(context, rect.size.width+rect.origin.x, rect.size.height+rect.origin.y);
        //设置下一个坐标点
        CGContextAddLineToPoint(context, trueWidth+rect.origin.x, rect.size.height+rect.origin.y);
        //连接上面定义的坐标点
        //CGContextStrokePath(context);
        
        CGContextClosePath(context) ;
        CGContextFillPath(context) ;
    }
     */
    
	
    
	
    
	
    
    
	// restore the context
	//CGContextRestoreGState(context) ;
}


@end
