//
//  OLAWebView.m
//  Ola
//
//  Created by lohool on 12/5/16.
//  Copyright (c) 2016 Terrence Xing. All rights reserved.
//

#import "OLAWebView.h"


@implementation OLAWebView
- (id) initWithParent:(OLAView *)parentView withXMLElement:(XMLElement *) root andUIFactory:(OLAUIFactory *)uiFactory;
{
    self=[super initWithParent:parentView withXMLElement:root andUIFactory:uiFactory];
    if (self) {
        // Initialization code
    }
    
    UIWebView *layout;
    
    if(parentView!=nil)
    {
        layout =[[UIWebView alloc] initWithFrame:parentView.v.frame];
        
    }
    else
    {
        layout =[[UIWebView alloc] initWithFrame:CGRectMake(0,0, 0, 0)];
    }
    
    [layout setIsAccessibilityElement:TRUE];
    layout.delegate=self;
    [layout setScalesPageToFit:TRUE];
    
    super.v=layout;
    
    [super initiate];
    //[super parseChildren:self withXMLElement:root];

    
    return self;
    
    
}
-(void)setText:(NSString*)text
{
    [self setContent:text];
}
-(void)setContent:(NSString*) content
{
    UIWebView *layout=(UIWebView *)super.v;
    [layout loadHTMLString:content baseURL:NULL];
}
@end
