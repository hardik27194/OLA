//
//  OLAWebView.h
//  Ola
//
//  Created by lohool on 12/5/16.
//  Copyright (c) 2016 Terrence Xing. All rights reserved.
//

#import "OLALayout.h"
//#import "UIWebViewDelegate.h"
@interface OLAWebView : OLALayout<UIWebViewDelegate>
- (id) initWithParent:(OLAView *)parentView withXMLElement:(XMLElement *) root andUIFactory:(OLAUIFactory *)uiFactory;
-(void)setContent:(NSString*) content;
@end
