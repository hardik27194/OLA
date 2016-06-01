//
//  OLAStringUtil.h
//  Ola
//
//  Created by Terrence Xing on 4/1/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OLAStringUtil : NSObject
+ (NSString *) toUTF6LE:(NSString *) byteArray;
+ (NSString *) addParameter:(NSString *)callback param:(NSString *)params;
@end
