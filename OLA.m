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
+(void)setMainView:(UIView *) view
{
    mainView=view;
}
+(UIView *)getMainView
{
    return mainView;
}
@end
