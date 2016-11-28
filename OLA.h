//
//  OLA.h
//  Ola
//
//  Created by Terrence Xing on 6/16/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OLA : NSObject
{
   
}
//@property (nonatomic) NSString * appBase;
+ (void) setAppBase:(NSString *) base;
+(NSString *) getAppBase;
+(NSString *) getBase;
+ (void) setBase:(NSString *) base;
+(void)setMainView:(UIView *) view;
+(UIView *)getMainView;
@end
