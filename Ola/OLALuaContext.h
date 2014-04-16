//
//  OLALuaContext.h
//  Ola
//
//  Created by Terrence Xing on 3/19/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "lua.h"
#import "lualib.h"
#import "lauxlib.h"

@interface OLALuaContext : NSObject
{
     lua_State * lua;
}
@property (nonatomic) lua_State * lua;
+(OLALuaContext *)getInstance;

- (lua_State *) getLuaState;
- (void) regist:(id) obj  withGlobalName:(NSString *) name;
- (void) registClass:(id) obj  withGlobalName:(NSString *) name;
- (id) getObject:(NSString *) objId;
- (void) doString: (NSString *) str;
- (void) doFile: (NSString *) fileName;
- (id) remove:(NSString *) objId;
-(NSString *) getGlobalString:(NSString *) objId;

/* OC's method */
- (void) setGlobal: (NSString *) str withId:(NSString *) objId;
@end
