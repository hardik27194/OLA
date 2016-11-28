//
//  OLA.m
//  Ola
//
//  Created by Terrence Xing on 6/16/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#import "OLA.h"

@implementation OLA
static  NSString *_appBase;
static  NSString *_base;
static  UIView *mainView;
//@synthesize appBase=_appBase;


+ (void) setAppBase:(NSString *) base
{
    _appBase=base;
}
 
+(NSString *) getAppBase
{
    return _appBase;
}
+ (void) setBase:(NSString *) base
{
    _base=base;
}

+(NSString *) getBase
{
    return _base;
}
+(void)setMainView:(UIView *) view
{
    mainView=view;
}
+(UIView *)getMainView
{
    return mainView;
}
@end
