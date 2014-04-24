//
//  OLAUIMessage.m
//  Ola
//
//  Created by Terrence Xing on 4/25/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#import "OLAUIMessage.h"
#import "OLALuaContext.h"

@implementation OLAUIMessage


+ (id) create
{
    return [[OLAUIMessage alloc]init];
}

-(void) updateUI:(NSString *)luaCode
{
    [[OLALuaContext getInstance] doString:luaCode];
}
-(void) updateMessage:(NSString *) msg
{
    [self performSelectorOnMainThread:@selector(updateUI:)withObject:msg waitUntilDone:YES];
    
}
@end
