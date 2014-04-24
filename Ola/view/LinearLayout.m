//
//  OLALinearLayout.m
//  Ola
//
//  Created by Terrence Xing on 3/19/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#import "LinearLayout.h"
#import "UILabelEx.h"
#import "OLALabel.h"
#import "OLAScrollView.h"

@implementation LinearLayout

@synthesize children;
@synthesize orientation;
@synthesize layoutParams;
@synthesize objId;
@synthesize margin,padding;

CGFloat origionX,origionY;

-(id) initWithFrame:(CGRect) frame
{
   	self=[super initWithFrame:CGRectMake(0, 0, 0, 0)];
    
    origionX=frame.size.width;
    origionY=frame.size.height;
    if(self)
    {
    NSLog(@"create Linear Layout,id=%@; X=%f,Y=%f,w=%f,h=%f",objId,self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    children=[[NSMutableArray alloc] init];
    //self.backgroundColor=[UIColor blueColor];
    //orientation=vertical;
        layoutParams=  malloc(sizeof(struct _LayoutParams));
        //padding = malloc(sizeof(struct _Padding));
        
    }
    self.orientation=vertical;
    
	return self;
}

-(void)initSize
{
    NSLog(@"init linear layout init 1: X=%f,Y=%f,w=%f,h=%f",self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);

    //CGFloat w=origionX;
    //CGFloat h=origionY;
    CGFloat w=self.frame.size.width;
    CGFloat h=self.frame.size.height;
    if(self.layoutParams->width>0){w=self.layoutParams->width;}
    if(self.layoutParams->height>0){h=self.layoutParams->height;}
    NSLog(@"layoutParams: w=%d,h=%d,margin:l=%f,r=%f",layoutParams->width,layoutParams->height,margin.left,margin.right);
    w=w-margin.left-margin.right;
    h=h-margin.top-margin.bottom;
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, w, h)];
     NSLog(@"init linear layout init 2: X=%f,Y=%f,w=%f,h=%f",self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}
-(void)resizeToFitMaxChild
{
    CGFloat w = self.frame.size.width,h = self.frame.size.height;

    CGSize size=[self minSize];
    CGFloat w1,h1;
    w1=size.width+padding.left+padding.right;
    h1=size.height+padding.top+padding.bottom;
    if(w1>w)w=w1;
    if(h1>h)h=h1;
    /*
    NSLog(@"linear layout resize,min size= : w=%f,h=%f",w,h);
    NSLog(@"linear layout resize,layoutParams size= : w=%d,h=%d",self.layoutParams->width,self.layoutParams->height);
    if(orientation==vertical)
    {
        if(self.layoutParams->height>0)
        {
            h=self.layoutParams->height;
        }
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, h)];
    }
    else{
        if(self.layoutParams->width>0){w=self.layoutParams->width;}

        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, w, self.frame.size.height)];

    }
     
     */
    if(self.layoutParams->height>0)
    {
        h=self.layoutParams->height;
    }
    if(self.layoutParams->width>0){w=self.layoutParams->width;}
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, w, h)];
    
    NSLog(@"linear layout resize : X=%f,Y=%f,w=%f,h=%f",self.frame.origin.x, self.frame.origin.y, self.frame.size.width,self.frame.size.height);
}
/*
-(void)addSubView:(UIView *) view
{
    CGFloat X=0;
    CGFloat Y=0;
    CGFloat w=0;
    CGFloat h=0;

    
    //init the frame of the subview
    if( children.count<=0)
    {
        if(orientation == vertical)
        {
            Y=0;
            //w=self.frame.size.width;
            if(view.frame.size.width<=self.frame.size.width)w=self.frame.size.width;
            else w=view.frame.size.width;
            h=view.frame.size.height;
        }
        else
        {
            X=0;
            w=view.frame.size.width;
            //h=self.frame.size.height;
            if(view.frame.size.height<=self.frame.size.height)h=self.frame.size.height;else h=view.frame.size.height;
        }
        if(view.frame.size.width>0) w=view.frame.size.width;
        if(view.frame.size.height>0) h=view.frame.size.height;

    }
    else{
        UIView* v= (UIView*) [children lastObject];
    if(orientation == vertical)
    {
        Y=v.frame.origin.y+v.frame.size.height;
        if(view.frame.size.width<=self.frame.size.width)w=self.frame.size.width;
        else w=view.frame.size.width;
        h=view.frame.size.height;
    }
    else
    {
        X=v.frame.origin.x+v.frame.size.width;
        w=view.frame.size.width;
        NSLog(@"view.frame.size.height=%f,self.frame.size.height=%f",view.frame.size.height,self.frame.size.height);
        if(view.frame.size.height<=self.frame.size.height)h=self.frame.size.height;
        else h=view.frame.size.height;
    }
        //if the size was defined munally, used the defined size
        if([view isKindOfClass:[LinearLayout class]])
        {
            LinearLayout * l=(LinearLayout *)view;
            if(l.layoutParams->width>0)w=l.layoutParams->width;
            if(l.layoutParams->height)h=l.layoutParams->height;
        }
        else
        {
        if(view.frame.size.width>0) w=view.frame.size.width;
        if(view.frame.size.height>0) h=view.frame.size.height;
        }
    }
    NSLog(@"1-----------");
    NSLog(@"X=%f,Y=%f,w=%f,h=%f",X, Y, w, h);
    //set auto match the parent layout
    if(view.frame.size.width==0)w=self.frame.size.width;
    if(view.frame.size.height==0)h=self.frame.size.height;
  
    NSLog(@"view.frame:X=%f,Y=%f,w=%f,h=%f",view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
   

    
    
    [self.children addObject:view];
    
    [super addSubview:view];
    [self resize];
    NSLog(@"X=%f,Y=%f,w=%f,h=%f",X, Y, w, h);
    CGRect frame=CGRectMake(X, Y, w, h);
    NSLog(@"X=%f,Y=%f,w=%f,h=%f",frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
    frame=[self reFrame:frame];
    
    [view setFrame:frame];
    NSLog(@"2-----------");
    
}
*/

/**
 reset position of of the children views
 */

- (void) relocateChildren
{
    for(UIView * v in children)
    {
        [v setFrame:[self reFrame:v.frame]];
    }
}
- (CGRect) reFrame:(CGRect)frame //relativeLastObjectFrame:(CGRect) lastFrame //withAlign:(char *) align andValign:(char *)valign
{
    const char * align ="center";
    const char * valign ="middle";
    
    //if(layoutParams!=nil)
    {
        if(layoutParams->align!=nil)align=layoutParams->align;
        if(layoutParams->valign!=nil)valign=layoutParams->valign;
    }
    
    int pw=self.frame.size.width;
    int ph=self.frame.size.height;
    int x=frame.origin.x;
    int y=frame.origin.y;
    int w=frame.size.width;
    int h=frame.size.height;
    
    if(orientation==vertical)
    {
        NSLog(@"align=%s",align);
    if(strncmp(align, "center",6)==0)
    {
        x=(pw-w)/2;
    }
    else if(strncmp(align, "left",4)==0)
    {
        x=0;
    }
    else if(strncmp(align, "right",5)==0)
    {
        x=(pw-w);
    }
    
    if(frame.size.height>0)h=frame.size.height;
    }
    else
    {
        if(strncmp(valign, "middle",6)==0 || strncmp(valign, "center",6)==0)
        {
            y=(ph-h)/2;
        }
        else if(strncmp(valign, "top",3)==0)
        {
            y=0;
        }
        else if(strncmp(valign, "bottom",6)==0)
        {
            y=ph-h;
        }
        //if the frame was set by manual, use the rigional value
        if(frame.size.width>0)w=frame.size.width;
    }
    
    if(x<0)x=0;
    if(y<0)y=0;
    frame.origin.x=x;
    frame.origin.y=y;
    return CGRectMake(x, y, w, h);
}

-(CGSize)minSize
{
    CGFloat w = 0.0,h = 0.0;
    for(OLAView * v in children)
    {
        if(orientation==vertical)
        {
            h+=v.v.frame.size.height+ [v.css getMargin].top+[v.css getMargin].bottom;
            CGFloat totalW=v.v.frame.size.width+[v.css getMargin].left+[v.css getMargin].right;
            if(totalW>w)w=totalW;
        }
        else{
            w+=v.v.frame.size.width+[v.css getMargin].left+[v.css getMargin].right;
            CGFloat totalH=v.v.frame.size.height+[v.css getMargin].top+[v.css getMargin].bottom;
            if(totalH>h)h=totalH;
        }
    }
    
    CGSize size=CGSizeMake(w, h);
    return size;
}

-(void)setFrameMinSize
{
    CGFloat w = 0.0,h = 0.0;
    for(OLAView * v in children)
    {
        if([v.v isKindOfClass:[Layout class]])
        {
            Layout *childLayout=(Layout *)v.v;
            [childLayout setFrameMinSize];
        }
    }
    
    CGSize size=[self minSize];
    w=size.width+padding.left+padding.right;
    h=size.height+padding.top+padding.bottom;
    if(orientation==horizontal)
    {
        
    }
    else
    {
        
    }
    if(self.layoutParams->width>0){w=self.layoutParams->width;}
    if(self.layoutParams->height>0){h=self.layoutParams->height;}
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, w, h)];
}

-(CGFloat)sumWeight
{
    CGFloat weight = 0.0;
    for(OLAView * v in children)
    {
        weight+=v.css.weight;
    }
    NSLog(@"linear weight=%f",weight);
    return weight;
}

-(CGSize)sumMargin
{
    CGFloat w = 0.0,h = 0.0;
    for(OLAView * v in children)
    {
        if(orientation==vertical)
        {
            h+=[v.css getMargin].top+[v.css getMargin].bottom;
            CGFloat totalW=[v.css getMargin].top+[v.css getMargin].bottom;
            if(totalW>w)w=totalW;
        }
        else{
            w+=[v.css getMargin].left+[v.css getMargin].left;
            CGFloat totalH=[v.css getMargin].top+[v.css getMargin].bottom;
            if(totalH>h)h=totalH;
        }
    }
    
    CGSize size=CGSizeMake(w, h);
    return size;
}
-(void)addSubview:(OLAView *) view
{
    [self.children addObject:view];
    [super addSubview:view.v];
    [self setFrameMinSize];
    /*
    [self initSize];
    [self requestLayout];
    [self resize];
    [self reSetChildrenFrame];
     */
}

-(void)repaint
{
    [self initSize];
    //[self resize];
    [self requestLayout];
    //[self resize];
    [self reSetChildrenFrame];
    
    [super repaint];
}
/*
 request to reset frame size of the subviews of the current layout without Margins
 */
-(void) requestLayout
{
    NSLog(@"start request layout");

    CGFloat sumWeight=[self sumWeight];
    //CGSize  minSize=[self minSize];
    if(orientation==horizontal)
    {
        CGFloat fixedWidth = 0.0;
        for(OLAView * v in children)
        {
            if([v isKindOfClass:[OLALabel class]])
            {
                //reset text
                CGFloat w=self.frame.size.width-padding.left-padding.right-v.css.margin.left-v.css.margin.right;
                //NSLog(@"reset  label text,w=%f,h=%f",w, minSize.height);
                OLALabel * labelView= (OLALabel *)v;
                [labelView adjustSize:w];
                //[v.v setFrame:CGRectMake(v.v.frame.origin.x, v.v.frame.origin.y, v.v.frame.size.width, v.v.frame.size.height)];
            }
            if(v.css.weight<=0)fixedWidth+=v.v.frame.size.width;
            NSLog(@"children size,w=%f,h=%f",v.v.frame.size.width,v.v.frame.size.height);
            fixedWidth+=v.css.margin.left+v.css.margin.right;
        }
        fixedWidth+=padding.left+padding.right;
        NSLog(@"padding,l=%f,r=%f",padding.left,padding.right);
        CGFloat freeWidth=self.frame.size.width-fixedWidth;
        NSLog(@"self=%f",self.frame.size.width);
        
        CGFloat offsetX=padding.left;
        for(OLAView * v in children)
        {
            CGFloat y=[v.css getMargin].top+padding.top;
            CGFloat x=offsetX+[v.css getMargin].left;
             NSLog(@"-----child----- offsetX,=%f",x);
            NSLog(@"fixedWidth,=%f,weight=%f",fixedWidth,sumWeight);
            CGFloat h=self.frame.size.height-padding.top-padding.bottom-v.css.margin.top-v.css.margin.bottom;
            if(v.css.height>0)h=v.css.height;
            if(v.css.weight>0)
            {
                CGFloat w=freeWidth *(v.css.weight/sumWeight);
                [v.v setFrame:CGRectMake(x,y, w, h )];
            }
            
            else
            {
                [v.v setFrame:CGRectMake(x, y, v.v.frame.size.width, h)];
            }

            
            /*
            if([v.v isKindOfClass:[LinearLayout class]])
            {
                LinearLayout *childLayout=(LinearLayout *)v.v;
                if(children.count>0 )
                {
                    CGSize size= [childLayout minSize];
                    [v.v setFrame:CGRectMake(x,y, size.width, size.height)];

                }
                    [childLayout repaint];
            }
             */
            /*
            if(v.css.height==0)
            {
                [v.v setFrame:CGRectMake(x, y, v.v.frame.size.width, v.v.frame.size.height)];
            }
            else
            {
                [v.v setFrame:CGRectMake(x, y, v.v.frame.size.width, v.v.frame.size.height)];
            }
             */
            
            
            if([v.v isKindOfClass:[Layout class]])
            {
                
                LinearLayout *childLayout=(LinearLayout *)v.v;
                
                [childLayout repaint];
            }
            if([v isKindOfClass:[OLAScrollView class]])
            {
                
                OLAScrollView *childLayout=(OLAScrollView *)v;
                NSLog(@"linear scroll resize : X=%f,Y=%f,w=%f,h=%f",v.v.frame.origin.x, v.v.frame.origin.y, v.v.frame.size.width,v.v.frame.size.height);
                [childLayout repaint];
            }
            
            /*
            if(v.css.weight>0)
            {
                CGFloat w=freeWidth *(v.css.weight/sumWeight);
                [v.v setFrame:CGRectMake(x,y, w, v.v.frame.size.height)];
                NSLog(@"self frame:id=%@, width=%f",objId,w);
                //[v.v setFrame:CGRectMake(x, y, v.v.frame.size.width, v.v.frame.size.height)];
            }
            
            if([v.v isKindOfClass:[Layout class]])
            {
                
                LinearLayout *childLayout=(LinearLayout *)v.v;
                
                [childLayout repaint];
            }
            */
            offsetX+=[v.css getMargin].left+[v.css getMargin].right+v.v.frame.size.width;
            NSLog(@"request child layout resize : X=%f,Y=%f,w=%f,h=%f",v.v.frame.origin.x, v.v.frame.origin.y, v.v.frame.size.width,v.v.frame.size.height);
        }
        
        
        
    }
    else
    {
        CGFloat fixedHeight = 0.0;
        CGFloat offsetX=0;
        
        for(OLAView * v in children)
        {
            
            if([v isKindOfClass:[OLALabel class]])
            {
                //reset text
                CGFloat w=self.frame.size.width-padding.left-padding.right-v.css.margin.left-v.css.margin.right;
                NSLog(@"reset  label text,w=%f,h=%f",w, self.frame.size.height);
                OLALabel * labelView= (OLALabel *)v;
                [labelView adjustSize:w];
                //[v.v setFrame:CGRectMake(v.v.frame.origin.x, v.v.frame.origin.y, v.v.frame.size.width, v.v.frame.size.height)];
            }
            if(v.css.weight<=0)fixedHeight+=v.v.frame.size.height;
            fixedHeight+=v.css.margin.top+v.css.margin.bottom;
        }
        fixedHeight+=padding.top+padding.bottom;
        NSLog(@"padding,l=%f,r=%f",padding.top,padding.bottom);
        CGFloat freeHeight=self.frame.size.height-fixedHeight;
        NSLog(@"self=%f",self.frame.size.height);
        NSLog(@"fixedWidth,=%f",fixedHeight);
        CGFloat offsetY=padding.top;
        
        //CGFloat freeHeight=self.frame.size.height-fixedHeight-sumMargin.height;
        for(OLAView * v in children)
        {
            
            CGFloat x=[v.css getMargin].left+padding.left;
            CGFloat y=offsetY+[v.css getMargin].top;
            //NSLog(@"offsetY,=%f",y);
            
            CGFloat w=self.frame.size.width-padding.left-padding.right-v.css.margin.left-v.css.margin.right;
            if(v.css.width>0)w=v.css.width;
            if(v.css.weight>0)
            {
                CGFloat h=freeHeight *(v.css.weight/sumWeight);
                NSLog(@"offsetY,h=%f,h=%f",v.v.frame.size.height,h);
                NSLog(@"margin,t=%f,b=%f",v.css.margin.top,v.css.margin.bottom);
                [v.v setFrame:CGRectMake(x,y,  w,h)];
            }
            else
            {
                [v.v setFrame:CGRectMake(x, y, w, v.v.frame.size.height)];
            }
            
            
            /* removed
             CGFloat y=offsetY+[v.css getMargin].top;
            NSLog(@"offset y=%f",offsetY);
            CGFloat x=[v.css getMargin].left;
            //origion mini size
            if(v.css.weight>0)
            {
                CGFloat h=freeHeight *(v.css.weight/sumWeight);
                NSLog(@"Free Height=%f,sum weight=%f,weight=%d",h,sumWeight,v.css.weight);
                [v.v setFrame:CGRectMake(x, y, v.v.frame.size.width, h)];
            }
            else if([v.v isKindOfClass:[Layout class]])
            {
                if(children.count>0 )
                {
                    LinearLayout *childLayout=(LinearLayout *)v.v;
                    CGSize size= [childLayout minSize];
                    [v.v setFrame:CGRectMake(x, y, v.v.frame.size.width, size.height)];
                    [childLayout repaint];
                }
            }
             */
            
            //if set to "auto", set it match to parent
            /*
            if(v.css.width==0)
            {
                [v.v setFrame:CGRectMake(x, y, self.frame.size.width-[v.css getMargin].left-[v.css getMargin].right, v.v.frame.size.height)];
            }
            else
            {
                [v.v setFrame:CGRectMake(x, y, v.v.frame.size.width, v.v.frame.size.height)];
            }
             */
             
            
            if([v.v isKindOfClass:[Layout class]])
            {
                
                LinearLayout *childLayout=(LinearLayout *)v.v;

                [childLayout repaint];
            }
            if([v isKindOfClass:[OLAScrollView class]])
            {
                
                OLAScrollView *childLayout=(OLAScrollView *)v;
                
                [childLayout repaint];
            }
            /*
            if(v.css.weight>0)
            {
                CGFloat h=freeHeight *(v.css.weight/sumWeight);

                [v.v setFrame:CGRectMake(x, y, v.v.frame.size.width, h)];
            }
            */
            offsetY+=[v.css getMargin].top+[v.css getMargin].bottom+v.v.frame.size.height;
        }
    }
}


- (void) reSetChildrenFrame//relativeLastObjectFrame:(CGRect) lastFrame //withAlign:(char *) align andValign:(char *)valign
{
    NSLog(@"reSetChildrenFrame layout resize : X=%f,Y=%f,w=%f,h=%f",self.frame.origin.x, self.frame.origin.y, self.frame.size.width,self.frame.size.height);

    CGSize sumMargin=[self sumMargin];
    CGSize minSize=[self minSize];
    const char * align=layoutParams->align;
    const char * valign=layoutParams->valign;
    if(orientation==horizontal)
    {
        CGFloat sumWidth=0;
        CGFloat offsetX=0,offsetY=0;
        CGFloat x=0,y=0;
        
        CGFloat freeWidth=self.frame.size.width-minSize.width-padding.left-padding.right;

        if(strncmp(align, "center",6)==0)
        {
            x=freeWidth/2;
        }
        else if(strncmp(align, "right",5)==0)
        {
            x=freeWidth;
        }
        else  //if(strncmp(align, "left",4)==0)
        {
            x=offsetX;
        }
        //if(x<0)x=0;
        for(OLAView * v in children)
        {
            if(strncmp(valign, "middle",6)==0 || strncmp(valign, "center",6)==0)
            {
                y=(self.frame.size.height-v.v.frame.size.height)/2;
            }
            else if(strncmp(valign, "top",3)==0)
            {
                y=padding.top+v.css.margin.top;
            }
            else if(strncmp(valign, "bottom",6)==0)
            {
                y=self.frame.size.height-v.v.frame.size.height;
            }
            else //if(strncmp(valign, "middle",6)==0 || strncmp(valign, "center",6)==0)
            {
                y=(self.frame.size.height-v.v.frame.size.height)/2;
            }
            [v.v setFrame:CGRectMake(v.v.frame.origin.x+x, y+offsetY, v.v.frame.size.width, v.v.frame.size.height)];
        }
    }
    else
    {
        CGFloat sumHeight=0;
        CGFloat offsetX=0,offsetY=0;
        CGFloat x=0,y=0;
        CGFloat freeHeight=self.frame.size.height-minSize.height-padding.top-padding.bottom;
        
        if(strncmp(valign, "middle",6)==0 || strncmp(valign, "center",6)==0)
        {
            y=freeHeight/2;
        }
        
        else if(strncmp(valign, "bottom",6)==0)
        {
            y=freeHeight;
        }
        else //if(strncmp(valign, "top",3)==0)//default valignto top
        {
            y=offsetY;
        }
        
        for(OLAView * v in children)
        {
            if(strncmp(align, "middle",6)==0 || strncmp(align, "center",6)==0)
            {
                x=(self.frame.size.width-v.v.frame.size.width)/2;
            }
            
            else if(strncmp(align, "right",5)==0)
            {
                x=self.frame.size.width-v.v.frame.size.width-padding.right-v.css.margin.right;
            }
            else //if(strncmp(align, "left",4)==0)//default align to left
            {
                x=padding.left+v.css.margin.left;
            }
            //if(x<0)x=0;
            NSLog(@"child reset frame:id=%@, x=%f,y=%f,w=%f,h=%f",objId,x,y, v.v.frame.size.width, v.v.frame.size.height);
            [v.v setFrame:CGRectMake(x+offsetX, v.v.frame.origin.y+y, v.v.frame.size.width, v.v.frame.size.height)];
            
            //y+=v.v.frame.size.height;
            
        }
        
        
    }
}
/*
 
 set to parent's size
 
 for(all child)
 {
    size = child.min_size
    if(size is defined)size=defined size;
 
 }
 
 if(horiental)
 {
    height=max children height
    min_width=sum(children's width)
    if(min_width<self.width)
    {
        free_width=self.width-min_width
        weight_amount=sum(children.weight)
        for(c2 in all child)
        {
            c2.width+= free_width/weight_amount * c2.weight;
        }
    }
 }
 
 */



@end
