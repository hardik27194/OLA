//
//  Button.m
//  Ola
//
//  Created by Terrence Xing on 3/31/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#import "Button.h"

@implementation Button

@synthesize isResponsedTouchEvent;
@synthesize delegate;


-(BOOL) responsedTouchEvent
{
    return isResponsedTouchEvent;
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
    NSLog(@"button begin");
    
[[self nextResponder]touchesBegan:touches withEvent:event];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    //[super touchesEnded:touches withEvent:event];
    
     NSLog(@"button end");
    self.alpha=1;
    isResponsedTouchEvent=NO;
    //if(self=event vi)
    [delegate touchesEnded:touches withEvent:event];
    //[[self nextResponder]touchesEnded:touches withEvent:event];
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {

    //if(CGRectContainsPoint(self.frame,event))
    //[super touchesCancelled:touches withEvent:event];
     NSLog(@"button cacel");
    self.alpha=1;
    isResponsedTouchEvent=NO;
    //self.opaque=false;
    [delegate touchesCancelled:touches withEvent:event];
    //[[self nextResponder] touchesCancelled:touches withEvent:event];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
     //NSLog(@"button move");
    [delegate touchesMoved:touches withEvent:event];
    //[[self nextResponder] touchesMoved:touches withEvent:event];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
