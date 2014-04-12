//
//  OLAFrameLayout.m
//  Ola
//
//  Created by Terrence Xing on 3/26/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#import "FrameLayout.h"
#import "OLAView.h"
#import "LinearLayout.h"
#import "RelativeLayout.h"

@implementation FrameLayout
@synthesize children;
@synthesize layoutParams,margin;
@synthesize objId;

CGFloat origionX,origionY;


-(id) initWithFrame:(CGRect) frame
{
   	self=[super initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    origionX=frame.size.width;
    origionY=frame.size.height;
    if(self)
    {
        //NSLog(@"Linear Layout: X=%f,Y=%f,w=%f,h=%f",self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
        children=[[NSMutableArray alloc] init];
        //self.backgroundColor=[UIColor blueColor];
        //orientation=vertical;
        layoutParams=  malloc(sizeof(struct _LayoutParams));
    }
	return self;
}
-(void)initSize
{
    
    CGFloat w=origionX;
    CGFloat h=origionY;
    if(self.layoutParams->width>0){w=self.layoutParams->width;}
    if(self.layoutParams->height>0){h=self.layoutParams->height;}
    w=w-margin.left-margin.right;
    h=h-margin.top-margin.bottom;
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, w, h)];

}
-(void)resize
{
    CGFloat w = 0.0,h = 0.0;

    CGSize size=[self minSize];
    w=size.width;
    h=size.height;


        if(self.layoutParams->height>0)
        {
            h=self.layoutParams->height;
        }

        if(self.layoutParams->width>0){w=self.layoutParams->width;}
        
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, w, h)];

}
-(CGSize)minSize
{
    CGFloat w = 0.0,h = 0.0;
    for(OLAView * v in children)
    {
            CGFloat totalW=v.v.frame.size.width+[v.css getMargin].left+[v.css getMargin].right;
            if(totalW>w)w=totalW;

            CGFloat totalH=v.v.frame.size.height+[v.css getMargin].top+[v.css getMargin].bottom;
            if(totalH>h)h=totalH;
    }
    
    CGSize size=CGSizeMake(w, h);
    return size;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */
-(void)addSubview:(OLAView *) view
{
    [self.children addObject:view];
    [super addSubview:view.v];
    
}
/*
 request to reset positions of the subviews of the current layout
 */
-(void) requestLayout
{


        for(OLAView * v in children)
        {
            CGFloat y=self.frame.origin.y+v.css.margin.top+padding.top;
            CGFloat x=self.frame.origin.x+v.css.margin.left+padding.left;
            CGFloat w=0,h=0;
            w=self.frame.size.width-v.css.margin.left-v.css.margin.right-padding.left-padding.right;
            h=self.frame.size.height-v.css.margin.top-v.css.margin.bottom-padding.top-padding.bottom;
            
            if([v.v isKindOfClass:[Layout class]])
            {
                Layout *childLayout=(Layout *)v.v;

                [v.v setFrame:CGRectMake(x, y, w, h)];
                
                [childLayout repaint];
            }
            else
            {
                if(v.v.frame.size.width<w)w=v.v.frame.size.width;
                if(v.v.frame.size.height<h)h=v.v.frame.size.height;
                [v.v setFrame:CGRectMake(x, y, w, h)];
            }

                //[v.v setFrame:CGRectMake(x, y, v.v.frame.size.width, v.v.frame.size.height)];


            
        }
        

    
}
-(void)repaint
{
    [self initSize];
    [self requestLayout];
    //[self resize];
    //[self reSetChildrenFrame];
    [self resize];
}
-(void)setFrameMinSize
{
    for(OLAView * v in children)
    {
        if([v.v isKindOfClass:[Layout class]])
        {
            Layout *childLayout=(Layout *)v.v;
            [childLayout setFrameMinSize];
        }
    }
}
@end
