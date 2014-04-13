//
//  OLALayout.h
//  Ola
//
//  Created by Terrence Xing on 3/19/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OLAContainer.h"
@interface OLALayout : OLAContainer

+  (OLALayout *) createLayout:(OLAView *)parentView  withXMLElement:(XMLElement *) root;
+  (OLALayout *) createLayout:(OLAView *)parentView  withXMLText:(NSString * ) xml;
@end
