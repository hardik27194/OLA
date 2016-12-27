//
//  OLAUIFactory.h
//  Ola
//
//  Created by Terrence Xing on 3/20/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OLABodyView.h"
@class OLAContainer;
@class OLAView;
@class OLALayout;

@interface OLAUIFactory : NSObject
{
   	OLABodyView * bodyView;
    OLAView *ctx;
    

}
@property (nonatomic)OLABodyView * bodyView;
@property (nonatomic)OLAView * ctx;

- (id) initWithContext:(OLABodyView *) olaBodyView withContext:(OLAView *) context;

-  (NSString *) loadAssert:(NSString *) resPath;
+ (NSString *) loadResourceTextDirectly:(NSString *) resPath;
- (NSString *) loadLayoutLuaCode:(NSString *) xmlUrl;
- (OLAView *) createView:(OLAContainer *) rootView withXMLElement:(XMLElement *) n;
-  (OLALayout *) createLayout:(OLAView *) parentView withXMLFile:(NSString *) url;
-  (OLALayout *) createLayout:(OLAView *)parentView  withXMLElement:(XMLElement *) root;
- (NSString *) createView:(NSString *) xml;
- (void) switchView:(NSString *) name callback:(NSString *) callback  params:(NSString  *) params;
- (NSString *) getParameters;
-(NSString*)getRootViewId;
@end
