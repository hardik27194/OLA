//
//  OLAAppProperties.h
//  Ola
//
//  Created by Terrence Xing on 6/18/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#import "OLAAbstractProperties.h"

@interface OLAAppProperties:OLAAbstractProperties
-(id) initWithAppName:(NSString *)applicationName;
- (void) exit;
- (void) reset;
@end
