//
//  OLALog.h
//  Ola
//
//  Created by Terrence Xing on 3/20/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OLALog : NSObject

//+ (void)d: (NSString *) msg;
+ (void)d:(NSString *) module message:(NSString *) msg;
static void d(char * module,char * msg);
@end

