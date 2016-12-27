//
//  OLAFrameLayout.m
//  Ola
//
//  Created by Terrence Xing on 3/26/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#import "OLAFrameLayout.h"
#import "FrameLayout.h"

@implementation OLAFrameLayout
@synthesize layout;
- (id) initWithParent:(OLAView *)parentView andUIRoot:(XMLElement *) rootElement  andUIFactory:(OLAUIFactory *)uiFactory
{
    self = [super initWithParent:parentView withXMLElement:rootElement andUIFactory:uiFactory];
    if (self) {
        // Initialization code
    }
    
    
    if(parentView!=nil)
    {
        layout =[[FrameLayout alloc] initWithFrame:parentView.v.frame];
    }
    else
    {
        layout =[[FrameLayout alloc] initWithFrame:CGRectMake(0,0, 0, 0)];
    }
    
    self.v=layout;
    self.parent=parentView;
    self.root=rootElement;
    [super initiate];
    layout.objId=self.objId;
    [self parseAllignment:layout];
    [super parseChildren:self withXMLElement:rootElement];
    //[layout repaint];
    return self;
    
}
-(void) parseAllignment:(FrameLayout *) myLayout
{

    LayoutParams params=myLayout.layoutParams;
    
    //if(css.width>0)
    params->width=css.width;
    //if(css.height>0)
    params->height=css.height;
    
    myLayout.backgroundImageUrl=css.backgroundImageURL;
    myLayout.alpha=css.alpha;
    
}
- (void) addSubview:(OLAView *) child
{
    [layout addSubview:child];
}
-(void) repaint
{
    [layout repaint];
}
- (void) setFrameMinSize
{
    [layout setFrameMinSize];
}
@end
