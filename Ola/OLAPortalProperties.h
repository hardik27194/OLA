//
//  OLAPortalProperties.h
//  Ola
//
//  Created by Terrence Xing on 6/18/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#import "OLAAbstractProperties.h"

@interface OLAPortalProperties : OLAAbstractProperties
+ (OLAPortalProperties *) create;
+ (id) getInstance;
- (void) reset;
@end
