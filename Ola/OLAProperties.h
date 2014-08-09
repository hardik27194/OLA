//
//  OLAProperties.h
//  Ola
//
//  Created by Terrence Xing on 3/20/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OLAAbstractProperties.h"
@interface OLAProperties : OLAAbstractProperties
- (void) reset;
- (void) startApp:(NSString *)appName;
@end
