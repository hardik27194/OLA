//
//  OLARelativeLayout.m
//  Ola
//
//  Created by Terrence Xing on 3/26/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#import "OLARelativeLayout.h"
#import "RelativeLayout.h"

@implementation OLARelativeLayout
@synthesize layout;
- (id) initWithParent:(OLAView *)parentView andUIRoot:(XMLElement *) rootElement
{
    self = [super init];
    if (self) {
        // Initialization code
    }
    
    
    if(parentView!=nil)
    {
        layout =[[RelativeLayout alloc] initWithFrame:parentView.v.frame];
    }
    else
    {
        layout =[[RelativeLayout alloc] initWithFrame:CGRectMake(0,0, 0, 0)];
    }
    
    self.v=layout;
    self.parent=parentView;
    self.root=rootElement;
    [super initiate];
     layout.objId=self.objId;
    //[self parseAllignment:layout];
    [super parseChildren:self withXMLElement:rootElement];
    return self;
    
}

- (void) addSubview:(OLAView *) child
{
    [layout addSubview:child];
}
@end
