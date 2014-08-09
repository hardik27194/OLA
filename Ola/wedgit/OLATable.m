//
//  OLATable.m
//  Ola
//
//  Created by Terrence Xing on 3/29/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#import "OLATable.h"
#import "OLATableRow.h"
#import "XMLElement.h"
#import "OLAScrollView.h"
@implementation OLATable

@synthesize layout;
- (id) initWithParent:(OLAView *)parentView andUIRoot:(XMLElement *) rootElement
{
    self = [super init];
    if (self) {
        // Initialization code
    }
    
    
    if(parentView!=nil)
    {
        NSLog(@"create Table 1,id=%@, tagName=%@",[self.css getStyleValue:@"id"],root.tagName);
        NSLog(@"create Table Layout 1: X=%f,Y=%f,w=%f,h=%f",parentView.v.frame.origin.x, parentView.v.frame.origin.y, parentView.v.frame.size.width, parentView.v.frame.size.height);
        layout =[[LinearLayout alloc] initWithFrame:parentView.v.frame];
        
        NSLog(@"create Table Layout 1: X=%f,Y=%f,w=%f,h=%f",layout.frame.origin.x, layout.frame.origin.y, layout.frame.size.width, layout.frame.size.height);
         
    }
    else
    {
        layout =[[LinearLayout alloc] initWithFrame:CGRectMake(0,0, 0, 0)];
        NSLog(@"create Table2,id=%@",objId);
    }
    layout.orientation=vertical;
    self.v=layout;
    self.parent=parentView;
    self.root=rootElement;
    NSLog(@"create TableRow Layout -0: X=%f,Y=%f,w=%f,h=%f",self.v.frame.origin.x, self.v.frame.origin.y, self.v.frame.size.width, self.v.frame.size.height);
    [super initiate];
    NSLog(@"create Table 1,id=%@",self.objId);
    layout.objId=self.objId;
     NSLog(@"create TableRow Layout -0: X=%f,Y=%f,w=%f,h=%f",self.v.frame.origin.x, self.v.frame.origin.y, self.v.frame.size.width, self.v.frame.size.height);
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

        [layout setOrientation:vertical];

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
   for(XMLElement * n in root.children)
   {
       NSLog(@"parse Table, tagType=%@, tagname=%@",[n class],n.tagName);
            NSString * name=n.tagName;
            if([name caseInsensitiveCompare:@"THEAD"]==NSOrderedSame || [name caseInsensitiveCompare:@"TBODY"]==NSOrderedSame)
            {
                XMLElement * row=(XMLElement *)[n.children firstObject];
                [self parseRow:row];
            }
            else if([name caseInsensitiveCompare:@"TR"]==NSOrderedSame)
            {
                [self parseRow:n];
            }
    }
    [self repaint];
     NSLog(@"create Table Layout: X=%f,Y=%f,w=%f,h=%f",self.v.frame.origin.x, self.v.frame.origin.y, self.v.frame.size.width, self.v.frame.size.height);
}

- (void) parseRow:(XMLElement *) node
{
     NSLog(@"create TableRow Layout 0: X=%f,Y=%f,w=%f,h=%f",self.v.frame.origin.x, self.v.frame.origin.y, self.v.frame.size.width, self.v.frame.size.height);
    OLATableRow * row = [[OLATableRow alloc] initWithParent:self andUIRoot:node];
    
    [self addSubview:row];
}

- (void) repaint
{
    if([parent isKindOfClass:[OLAScrollView class]])
    {
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
