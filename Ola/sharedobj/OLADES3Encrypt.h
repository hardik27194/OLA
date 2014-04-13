//
//  OLADES3Encrypt.h
//  Ola
//
//  Created by Terrence Xing on 4/1/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#import <Foundation/Foundation.h>
#define GET_ARRAY_LEN(array,len) {len = (sizeof(array) / sizeof(array[0]));}
@interface OLADES3Encrypt : NSObject
+ (Byte *) encypt:(char *)context key:(char **) password;
@end
