//
//  OLATableRow.m
//  Ola
//
//  Created by Terrence Xing on 3/29/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#import "OLATableRow.h"
#import "XMLElement.h"
#import "OLAScrollView.h"

@implementation OLATableRow


@synthesize layout;
- (id) initWithParent:(OLAView *)parentView andUIRoot:(XMLElement *) rootElement
{
    self = [super init];
    if (self) {
        // Initialization code
    }
    
    
    if(parentView!=nil)
    {
        NSLog(@"create TableRow 1,id=%@, tagName=%@",[self.css getStyleValue:@"id"],root.tagName);
        NSLog(@"create TableRow Layout 1: X=%f,Y=%f,w=%f,h=%f",parentView.v.frame.origin.x, parentView.v.frame.origin.y, parentView.v.frame.size.width, parentView.v.frame.size.height);
        layout =[[LinearLayout alloc] initWithFrame:parentView.v.frame];
        NSLog(@"create TableRow Layout 1: X=%f,Y=%f,w=%f,h=%f",layout.frame.origin.x, layout.frame.origin.y, layout.frame.size.width, layout.frame.size.height);
        
    }
    else
    {
        layout =[[LinearLayout alloc] initWithFrame:CGRectMake(0,0, 0, 0)];
        NSLog(@"create linear layout 2,id=%@",objId);
    }
    layout.orientation=horizontal;
    self.v=layout;
    self.parent=parentView;
    self.root=rootElement;
    [super initiate];
    NSLog(@"create linear layout 1,id=%@",self.objId);
    layout.objId=self.objId;
    [self parseAllignment:layout];
    [layout initSize];
    [self parseChildren];
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
-(void) parseAllignment:(LinearLayout *) layout
{

        [layout setOrientation:horizontal];

    LayoutParams params=layout.layoutParams;
    
    //if([css.textAlign caseInsensitiveCompare:@"center"]==NSOrderedSame)
    {
        const char * al=[css.textAlign cStringUsingEncoding:NSASCIIStringEncoding];
        //params->align=new char[strlen(al)];
        //strcpy(params->align, al);//"center";
        
        params->align=al;
        NSLog(@"align=%s",al);
    }
    //const char * vl=[css.verticalAlign cStringUsingEncoding:NSASCIIStringEncoding];
    //params->valign=char[strlen(vl)];
    params->valign=[css.verticalAlign cStringUsingEncoding:NSASCIIStringEncoding];
    
    params->weight=css.weight;
    
    
    
    //if(css.width>0)
    params->width=css.width;
    //if(css.height>0)
    params->height=css.height;
    
    layout.backgroundImageUrl=css.backgroundImageURL;
    layout.alpha=css.alpha;
    
    Padding padding;
    padding.left=css.padding.left;
    padding.right=css.padding.right;
    padding.top=css.padding.top;
    padding.bottom=css.padding.bottom;
    
    [layout setPadding:padding];
    
    NSLog(@"css.height=%d,%d",css.width,css.height);
    
}
- (void) addSubview:(OLAView *) child
{
    [layout addSubview:child];
}

- (void) parseChildren
{
    NSString  * rootname=root.tagName;

    for(XMLElement * n in root.children)
    {
        NSString *name=n.tagName;
        NSLog(@"parse table cells, tag nae=%@",n.tagName);
            if([name caseInsensitiveCompare:@"TD"]==NSOrderedSame )
            {
                //parseChildren(this,n);
                [super parseChildren:self withXMLElement:n];
            }
    }
    [self repaint];
    NSLog(@"create Table Row Layout: X=%f,Y=%f,w=%f,h=%f",self.v.frame.origin.x, self.v.frame.origin.y, self.v.frame.size.width, self.v.frame.size.height);
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
        NSLog(@"OLAScrollView frame,w=%f,h=%f",v.frame.size.width,v.frame.size.height);
        NSLog(@"OLAScrollView frame,X=%f,Y=%f",layout.frame.size.width,layout.frame.size.height);
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
