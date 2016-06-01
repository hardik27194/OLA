//
//  OLALinearLayout.m
//  Ola
//
//  Created by Terrence Xing on 3/23/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#import "OLALinearLayout.h"
#import "LinearLayout.h"
#import "OLAScrollView.h"
@implementation OLALinearLayout

@synthesize layout;
- (id) initWithParent:(OLAView *)parentView andUIRoot:(XMLElement *) rootElement
{
    self = [super init];
    if (self) {
        // Initialization code
    }
    
    
    if(parentView!=nil)
    {
        layout =[[LinearLayout alloc] initWithFrame:parentView.v.frame];
        //NSLog(@"create linear layout 1,id=%@",[self.css getStyleValue:@"id"]);
    }
    else
    {
        layout =[[LinearLayout alloc] initWithFrame:CGRectMake(0,0, 0, 0)];
        //NSLog(@"create linear layout 2,id=%@",objId);
    }

    self.v=layout;
    self.parent=parentView;
    self.root=rootElement;
    [super initiate];
    
    layout.objId=self.objId;
    [self parseAllignment:layout];
    [layout initSize];
    [super parseChildren:self withXMLElement:rootElement];
    //[layout repaint];
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
-(void) parseAllignment:(LinearLayout *) myLayout
{
    NSLog(@"orientation=%@,is Vertical=%i",[css getStyleValue:@"orientation"],[[css getStyleValue:@"orientation"] caseInsensitiveCompare:@"vertical"]);
    NSString *orientation=[css getStyleValue:@"orientation"];
    if(orientation !=nil && [orientation caseInsensitiveCompare:@"vertical"]==NSOrderedSame)
    {
        NSLog(@"set to vertical");
        [myLayout setOrientation:vertical];
    }
    else{
         NSLog(@"set to horizontal");
        [myLayout setOrientation:horizontal];
    }
    //LayoutParams params=myLayout.layoutParams;
    
    //if([css.textAlign caseInsensitiveCompare:@"center"]==NSOrderedSame)
    {
        const char * al=[css.textAlign cStringUsingEncoding:NSASCIIStringEncoding];
        //params->align=new char[strlen(al)];
        //strcpy(params->align, al);//"center";
        
        myLayout.layoutParams->align=al;
    }
    //const char * vl=[css.verticalAlign cStringUsingEncoding:NSASCIIStringEncoding];
    //params->valign=char[strlen(vl)];
    myLayout.layoutParams->valign=[css.verticalAlign cStringUsingEncoding:NSASCIIStringEncoding];
    
    myLayout.layoutParams->weight=css.weight;
    
    myLayout.layoutParams->left=css.left;
    myLayout.layoutParams->top=css.top;
    myLayout.layoutParams->right=css.top;
    myLayout.layoutParams->bottom=css.bottom;
    
    //if(css.width>0)
    myLayout.layoutParams->width=css.width;
    //if(css.height>0)
    myLayout.layoutParams->height=css.height;
    
    myLayout.backgroundImageUrl=css.backgroundImageURL;
    //myLayout.alpha=css.alpha;
    
    NSLog(@"set padding=%f",css.padding.left);
    Padding padding;
    padding.left=css.padding.left;
    padding.right=css.padding.right;
    padding.top=css.padding.top;
    padding.bottom=css.padding.bottom;
    
    [myLayout setPadding:padding];
    

    NSLog(@"set padding=%f",myLayout.padding.left);
}
- (void) addSubview:(OLAView *) child
{
    [layout addSubview:child];
}
- (void) repaint
{
    if([parent isKindOfClass:[OLAScrollView class]])
    {
        
        
        
        //[layout requestLayout];
        //[layout resize];
        //[layout reSetChildrenFrame];
        [layout setFrameMinSize];
        if([[css getStyleValue:@"orientation"] caseInsensitiveCompare:@"vertical"]==NSOrderedSame)
        {
            [v setFrame:CGRectMake(0, 0, parent.v.frame.size.width,MAXFLOAT)];        }
        else{
            [v setFrame:CGRectMake(0, 0, MAXFLOAT, parent.v.frame.size.height)];
        }
        [layout setFrame:parent.v.frame];
        [layout repaint];
        OLAScrollView * sv=(OLAScrollView *) parent;
        //NSLog(@"OLAScrollView frame,w=%f,h=%f",v.frame.size.width,v.frame.size.height);
        //NSLog(@"OLAScrollView frame,X=%f,Y=%f",layout.frame.size.width,layout.frame.size.height);
        [sv resetContentSizeToFitChildren];
    }
    
    else if([parent isKindOfClass:[OLAContainer class]])
    {
        OLAContainer * container=(OLAContainer *)parent;
        [container repaint];
    }
     
    NSLog(@"OLALinear repaint=%f",layout.frame.size.height);
    //[layout repaint];
}
- (void) setFrameMinSize
{
    [layout setFrameMinSize];
}
@end
