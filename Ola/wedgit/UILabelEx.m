//
//  UILabelEx.m
//  Ola
//
//  Created by Terrence Xing on 3/29/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#import "UILabelEx.h"
#import "OLAProperties.h"
#import "OLAWedgit.h"
#import "OLA.h"

@implementation UILabelEx


@synthesize verticalAlignment = verticalAlignment_;
@synthesize delegate,isResponsedTouchEvent,backgroundImageUrl,backgroundColorString,backgroundAlpha;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.verticalAlignment = VerticalAlignmentMiddle;
    }
    return self;
}

- (void)setVerticalAlignment:(VerticalAlignment)verticalAlignment {
    verticalAlignment_ = verticalAlignment;
    [self setNeedsDisplay];
}

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    CGRect textRect = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    switch (self.verticalAlignment) {
        case VerticalAlignmentTop:
        textRect.origin.y = bounds.origin.y;
        break;
        case VerticalAlignmentBottom:
        textRect.origin.y = bounds.origin.y + bounds.size.height - textRect.size.height;
        break;
        case VerticalAlignmentMiddle:
        // Fall through.
        default:
        textRect.origin.y = bounds.origin.y + (bounds.size.height - textRect.size.height) / 2.0;
    }
    return textRect;
}

-(void)drawTextInRect:(CGRect)requestedRect {
    CGRect actualRect = [self textRectForBounds:requestedRect limitedToNumberOfLines:self.numberOfLines];
    [super drawTextInRect:actualRect];
}


-(BOOL) responsedTouchEvent
{
    return isResponsedTouchEvent;
}

-(void)setFrame:(CGRect) frame
{
    [super setFrame:frame];
    if(self.backgroundImageUrl!=nil)[self resetBackgroundImageUrl:self.backgroundImageUrl];
}

-(void) resetBackgroundImageUrl:(NSString *) imageUrl
{
    //OLAProperties * param=[OLAProperties getInstance];
    NSString *base=[OLA getAppBase];
    
    NSString * img =[base stringByAppendingString:imageUrl];
    UIImage * bg=[UIImage imageNamed:img];
    bg=[OLAWedgit imageScale:bg toSize:self.frame.size];
    UIColor *bgColor = [UIColor  colorWithPatternImage: bg];
    bgColor=[bgColor colorWithAlphaComponent:backgroundAlpha];
    [super setBackgroundColor:bgColor];
}

/*
 - (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
 {
 CGMutablePathRef path = CGPathCreateMutable();
 CGPathMoveToPoint(path,NULL,0,0);
 CGRect rect = CGRectMake(0, 100, 320, 40);
 CGPathAddRect(path, NULL, rect);
 
 if(CGPathContainsPoint(path, NULL, point, NO))
 {
 // [self.superview touchesBegan:nil withEvent:nil];
 return nil;
 }
 CGPathRelease(path);
 return self;
 }
 */

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //[super touchesBegan:touches withEvent:event];
    self.alpha=0.6;
    //self.opaque=true;
    isResponsedTouchEvent=true;
    [delegate touchesBegan:touches withEvent:event];
    NSLog(@"label begin");
    
    [[self nextResponder]touchesBegan:touches withEvent:event];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    //[super touchesEnded:touches withEvent:event];
    NSLog(@"label end");
    self.alpha=1;
    isResponsedTouchEvent=NO;
    [delegate touchesEnded:touches withEvent:event];
    //[[self nextResponder]touchesEnded:touches withEvent:event];
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    //[super touchesCancelled:touches withEvent:event];
    NSLog(@"label cacel");
    self.alpha=1;
    isResponsedTouchEvent=NO;
    //self.opaque=false;
    [delegate touchesCancelled:touches withEvent:event];
    //[[self nextResponder] touchesCancelled:touches withEvent:event];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"label move");
    [delegate touchesMoved:touches withEvent:event];
    //[[self nextResponder] touchesMoved:touches withEvent:event];
}

@end
