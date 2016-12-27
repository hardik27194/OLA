//
//  OLAScrollView.m
//  Ola
//
//  Created by Terrence Xing on 3/29/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#import "OLAScrollView.h"
#import "OLALayout.h"
#import "Layout.h"

@implementation OLAScrollView

@synthesize layout,children;
- (id) initWithParent:(OLAView *)parentView withXMLElement:(XMLElement *) rootElement andUIFactory:(OLAUIFactory *)uiFactory
{
    self = [super initWithParent:parentView withXMLElement:rootElement andUIFactory:uiFactory];
    if (self) {
        // Initialization code
    }
    
    children=[[NSMutableArray alloc] init];

    if(parentView!=nil)
    {
         layout = [[ScrollerView alloc] initWithFrame:CGRectMake(0,0, 0, 0)];
    }
    else
    {
        layout = [[ScrollerView alloc] initWithFrame:CGRectMake(0,0, 0, 0)];
    }
    layout.wrapper=self;
    
    layout.directionalLockEnabled = YES; //只能一个方向滑动
    layout.pagingEnabled = NO; //是否翻页
    //layout.backgroundColor = [UIColor blackColor];
    layout.showsVerticalScrollIndicator =YES; //垂直方向的滚动指示
    layout.indicatorStyle = UIScrollViewIndicatorStyleWhite;//滚动指示的风格
    layout.showsHorizontalScrollIndicator = NO;//水平方向的滚动指示
    layout.alwaysBounceHorizontal=NO;
    
    layout.delegate = self;
    //[layout setBackgroundColor:[UIColor yellowColor]];
    
    //CGSize newSize = CGSizeMake(100, 135);
    [layout setContentSize:parentView.v.frame.size];
    
    self.v=layout;
    self.parent=parentView;
    self.root=rootElement;
    [super initiate];
    //[self parseAllignment:layout];
    [super parseChildren:self withXMLElement:rootElement];
    
    NSLog(@"init  scroll resize : X=%f,Y=%f,w=%f,h=%f",v.frame.origin.x, v.frame.origin.y, v.frame.size.width,v.frame.size.height);
    return self;
    
}
- (void) addSubview:(OLAView *) child
{
    [layout addSubview:child.v];
    [layout setContentSize:child.v.frame.size];
    [children addObject:child];
    
    //auto set frame size to min size of the subviews
    CGSize subSize=[self minSize];
    CGFloat w =self.v.frame.size.width;
    CGFloat h = self.v.frame.size.height;
    if(css.width<=0)
    {
        w=subSize.width;
    }
    else
    {
        w=css.width;
    }
    if(css.height<=0)
    {
        h=subSize.height;
    }
    else
    {
        h=css.height;
    }
    NSLog(@"scroll view min frame, w=%f,h=%f",w,h);
    [self.v setFrame:CGRectMake(self.v.frame.origin.x, self.v.frame.origin.y, w, h)];
     NSLog(@"addsubview scroll resize : X=%f,Y=%f,w=%f,h=%f",v.frame.origin.x, v.frame.origin.y, v.frame.size.width,v.frame.size.height);
}

-(CGSize)minSize
{
    CGFloat w = 0.0,h = 0.0;
    for(OLAView * view in children)
    {
            if(view.v.frame.size.width>w)w=view.v.frame.size.width;
            if(view.v.frame.size.height>h)h=view.v.frame.size.height;
    }
    
    CGSize size=CGSizeMake(w, h);
    return size;
}
-(void)setFrameMinSize
{
    for(OLAView * view in children)
    {
        if([view isKindOfClass:[OLALayout class]])
        {
            OLALayout *layout=(OLALayout *)view;
            [layout setFrameMinSize];
        }
    }
}
/*
 reset the scroll size to the frame size of its first subview.
 generall, the scroller view should only have one child 
 */
-(void) resetContentSizeToFitChildren
{
    OLAView * v=(OLAView *)[children firstObject];
    if( [v isKindOfClass:[OLALayout class]])
    {
        Layout * layout1= (Layout *) v.v;
        CGSize size=[layout1 minSize];
        [v.v setFrame:CGRectMake(v.v.frame.origin.x, v.v.frame.origin.y, v.v.frame.size.width, size.height)];
    }
    [layout setContentSize:CGSizeMake(0, v.v.frame.size.height)];
}
- (void) repaint
{
    
    NSLog(@"repaint scroll resize : X=%f,Y=%f,w=%f,h=%f",v.frame.origin.x, v.frame.origin.y, v.frame.size.width,v.frame.size.height);

    for(OLAView * view in children)
    {
        [view.v setFrame:CGRectMake(0, 0, self.v.frame.size.width, MAXFLOAT)];
    }
     
    NSLog(@"repaint OLAScrollView frame");
    for(OLAView * view in children)
    {
        if( [view isKindOfClass:[OLALayout class]])
        {
        OLALayout * layout= (OLALayout *) view;
        
        [layout repaint];
        }
    }
    [self resetContentSizeToFitChildren];
}
@end
