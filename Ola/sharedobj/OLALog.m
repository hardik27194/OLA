//
//  OLALog.m
//  Ola
//
//  Created by Terrence Xing on 3/20/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#import "OLALog.h"
#import "lua.h"
#import "lauxlib.h"
#import "wax_helpers.h"
@implementation OLALog


+ (void) d:(NSString *) module message:(NSString *) msg
{
    NSLog(@"%@:%@",module, msg);
}

+ (void) i:(NSString *) module message:(NSString *) msg
{
    NSLog(@"%@:%@",module, msg);
}

+ (void) f:(NSString *) module message:(NSString *) msg
{
    NSLog(@"%@:%@",module, msg);
}


@end


static void d(char * module,char * msg)
{
    NSLog(@"%s:%s",module, msg);
}

static const struct luaL_Reg functions[] = {
    {"d", d},
    {NULL, NULL}
};

int regist_Log(lua_State *L) {
    BEGIN_STACK_MODIFY(L);
    
    luaL_register(L, "Log", functions);
    
    END_STACK_MODIFY(L, 0)
    
    return 1;
}