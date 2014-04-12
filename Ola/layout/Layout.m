//
//  Layout.m
//  Ola
//
//  Created by Terrence Xing on 3/26/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#import "Layout.h"

@implementation Layout

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)repaint
{
    
}
-(void)setFrameMinSize
{
    
}
-(CGSize)minSize
{
    return CGSizeMake(0, 0);
}
#pragma mark - hitTest
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    
    
    // 否则，返回默认处理
    return [super hitTest:point withEvent:event];
    
}

@end
