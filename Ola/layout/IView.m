//
//  IView.m
//  Ola
//
//  Created by Terrence Xing on 4/2/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#import "IView.h"
#import "Button.h"
#import "UILabelEx.h"

@implementation IView

@synthesize delegate;


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    BOOL isChildrenTouched=NO;
    for(UIView * v in [self subviews])
    {
        if([v isKindOfClass:[Button class] ])
        {
            Button * btn=(Button *)v;
            if(btn.isResponsedTouchEvent)isChildrenTouched=YES;
        }
        else if([v isKindOfClass:[UILabelEx class] ])
        {
            UILabelEx * btn=(UILabelEx *)v;
            if(btn.isResponsedTouchEvent)isChildrenTouched=YES;
        }
    }
    if(isChildrenTouched==NO)
    {
    [delegate touchesBegan:touches withEvent:event];
    NSLog(@"view was began");
    }
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [delegate touchesEnded:touches withEvent:event];
    NSLog(@"view  was ended");
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [delegate touchesCancelled:touches withEvent:event];
    
    NSLog(@"view  was cancelled");
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"button move");
    [delegate touchesMoved:touches withEvent:event];
    //[[self nextResponder] touchesMoved:touches withEvent:event];
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
