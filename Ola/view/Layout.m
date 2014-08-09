//
//  Layout.m
//  Ola
//
//  Created by Terrence Xing on 3/26/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#import "Layout.h"
#import "OLAWedgit.h"
#import "OLAProperties.h"
#import "OLA.h"
@implementation Layout

@synthesize backgroundImageUrl;
@synthesize alpha;

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
    //after the size was changed, reset the background image with alpha
    if(self.backgroundImageUrl!=nil)
    {
        [self resetBackgroundImageUrl:self.backgroundImageUrl];
    }
}
-(void) resetBackgroundImageUrl:(NSString *) imageUrl
{
   // OLAProperties * param=[OLAProperties getInstance];
    NSString *base=[OLA getAppBase];

    NSString * img =[base stringByAppendingString:imageUrl];
    UIImage * bg=[UIImage imageNamed:img];
    bg=[OLAWedgit imageScale:bg toSize:self.frame.size];
    UIColor *bgColor = [UIColor  colorWithPatternImage: bg];
    bgColor=[bgColor colorWithAlphaComponent:alpha];
    [self setBackgroundColor:bgColor];
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
