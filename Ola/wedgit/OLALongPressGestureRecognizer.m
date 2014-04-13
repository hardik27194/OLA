//
//  OLALongPressGestureRecognizer.m
//  Ola
//
//  Created by Terrence Xing on 3/31/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#import "OLALongPressGestureRecognizer.h"

#import <UIKit/UIGestureRecognizerSubclass.h>
#import <time.h>

NSInteger timer1;
NSInteger timer2;
@implementation OLALongPressGestureRecognizer


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"ss"];
    
    timer1 = [[dateformatter stringFromDate:nowDate] integerValue];
    NSLog(@"%d",timer1);
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"ss"];
    timer2 = [[dateformatter stringFromDate:nowDate] integerValue];
    NSLog(@"%d",timer2);
    
    if ((timer2 -timer1) >= 2)
    {
        self.state = UIGestureRecognizerStateEnded;
    }
    
}


-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return NO;
}
@end