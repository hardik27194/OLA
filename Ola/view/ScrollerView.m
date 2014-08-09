//
//  ScrollerView.m
//  Ola
//
//  Created by Terrence Xing on 4/11/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#import "ScrollerView.h"

@implementation ScrollerView

@synthesize wrapper;



-(void)setFrameMinSize
{
    [wrapper setFrameMinSize];
}
- (void) repaint
{
    [wrapper repaint];
}
@end
