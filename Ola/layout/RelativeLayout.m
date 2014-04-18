//
//  OLARelativeLayout.m
//  Ola
//
//  Created by Terrence Xing on 3/20/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#import "RelativeLayout.h"
#import "OLARelativeLayout.h"
#import "OLALinearLayout.h"
@implementation RelativeLayout

@synthesize children;
@synthesize layoutParams;
@synthesize objId;

-(id) initWithFrame:(CGRect) frame
{
   	self=[super initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    if(self)
    {
        
        children=[[NSMutableArray alloc] init];
        //self.backgroundColor=[UIColor blueColor];
        //orientation=vertical;
        layoutParams=  malloc(sizeof(struct _LayoutParams));
    }

	return self;
}
-(void)initSize
{
    NSLog(@"RelativeLayout layoutParams: X=%d,Y=%d",self.layoutParams->width,self.layoutParams->height);
    CGFloat w=self.frame.size.width;
    CGFloat h=self.frame.size.height;
    if(self.layoutParams->width>0){w=self.layoutParams->width;}
    if(self.layoutParams->height>0){h=self.layoutParams->height;}
    
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, w, h)];
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
    [self initSize];
    [self requestLayout];
    //[self resize];
    //[self reSetChildrenFrame];
    //[self initSize];
    
    [super repaint];

}


-(void)repaint
{
    [self initSize];
    [self requestLayout];
    //[self resize];
    //[self reSetChildrenFrame];
    [self initSize];
}



/*
 request to reset positions of the subviews of the current layout
 */
-(void) requestLayout
{

        for(OLAView * v in children)
        {
            
            if([v.v isKindOfClass:[LinearLayout class]])
            {
                LinearLayout *childLayout=(LinearLayout *)v.v;
                [childLayout repaint];
            }
            
        }

}



@end
