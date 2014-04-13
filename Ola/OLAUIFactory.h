//
//  OLAUIFactory.h
//  Ola
//
//  Created by Terrence Xing on 3/20/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OLALayout.h"
#import "OLABodyView.h"

@interface OLAUIFactory : NSObject
{
   	OLAView * bodyView;

}
@property (nonatomic)OLAView * bodyView;

- (id) initWithBodyView:(OLAView *) bodyViewObj;

+  (NSString *) loadAssert:(NSString *) resPath;
+ (NSString *) loadResourceTextDirectly:(NSString *) resPath;
+ (NSString *) loadLayoutLuaCode:(NSString *) xmlUrl;
+ (OLAView *) createView:(OLAContainer *) rootView withXMLElement:(XMLElement *) n;
-  (OLALayout *) createLayout:(OLAView *) parentView withXMLFile:(NSString *) url;
- (NSString *) createView:(NSString *) xml;
- (void) switchView:(NSString *) name callback:(NSString *) callback  params:(NSString  *) params;
@end
