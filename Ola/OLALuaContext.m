//
//  OLALuaContext.m
//  Ola
//
//  Created by Terrence Xing on 3/19/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#import "OLALuaContext.h"
#import "lua.h"
#import "lualib.h"
#import "lauxlib.h"
#import "wax_instance.h"
#import "wax.h"
#import "OLAUIFactory.h"

@implementation OLALuaContext


@synthesize lua;

static OLALuaContext * instance;

+(OLALuaContext *)getInstance{
    
    @synchronized(self){  //为了确保多线程情况下，仍然确保实体的唯一性
        
        if (!instance) {
            
            [[self alloc] init]; //该方法会调用 allocWithZone
            
        }
        
    }
    
    return instance;
    
}



+(id)allocWithZone:(NSZone *)zone{
    
    @synchronized(self){
        
        if (!instance) {
            
            instance = [super allocWithZone:zone]; //确保使用同一块内存地址
            [instance open];
            return instance;
            
        }
        
    }
    
    return nil;
    
}



- (id)copyWithZone:(NSZone *)zone;{
    
    return self; //确保copy对象也是唯一
    
}

/*

-(id)retain{
    
    return self; //确保计数唯一
    
}



- (unsigned)retainCount

{
    
    return UINT_MAX;  //装逼用的，这样打印出来的计数永远为-1
    
}



- (id)autorelease

{
    
    return self;//确保计数唯一
    
} 



- (oneway void)release

{
    
    //重写计数释放方法
    
}
	*/

	-  (void) open
	{
        wax_start("luac", nil, nil, nil);
		lua =wax_currentLuaState();
	}
	
	-  (lua_State *) getLuaState
	{
		return lua;
	}
	
-  (void) regist:(id) obj  withGlobalName:(NSString *) name
	{
        wax_instance_create(lua, obj, false);
		lua_setglobal(lua, [name cStringUsingEncoding:NSASCIIStringEncoding]);
		
	}
-  (void) registClass:(id) obj  withGlobalName:(NSString *) name
{
    wax_instance_create(lua, obj, true);
    lua_setglobal(lua, [name cStringUsingEncoding:NSASCIIStringEncoding]);
    
}
- (id) remove:(NSString *) objId
	{
			//obj=lua.getLuaObject(id).getObject();
			lua_getglobal(lua,[objId cStringUsingEncoding:NSASCIIStringEncoding]);
        
        wax_instance_userdata * wax_data=(wax_instance_userdata *)lua_touserdata(lua, -1);
        
       
        lua_pop(lua, 1);
		//	lua.remove(-1);
			
		return wax_data->instance;
	}
- (id) getObject:(NSString *) objId
	{
        //obj=lua.getLuaObject(id).getObject();
        lua_getglobal(lua,[objId cStringUsingEncoding:NSASCIIStringEncoding]);
        wax_instance_userdata * wax_data=(wax_instance_userdata *)lua_touserdata(lua, -1);
        
        
        lua_pop(lua, 1);
		//	lua.remove(-1);
        
		return wax_data->instance;
	}
-(NSString *) getGlobalString:(NSString *) objId
{
    luaL_dostring(lua, [[@"return " stringByAppendingString:objId] UTF8String]);
    const char * value= lua_tostring(lua, -1);
    lua_pop(lua, -1);
    return [NSString stringWithUTF8String:value];
    
}
/*
	- LuaObject getLuaObject(NSString * id)
	{
		LuaObject obj = null;
		obj = lua.getLuaObject(id);
		return obj;
	}
 */
- (void) doString: (NSString *) str
	{
        const char * luaCode=[str cStringUsingEncoding:NSASCIIStringEncoding];
        //NSLog(@"Lua Code1=%s",luaCode);
		luaL_dostring(lua, [str cStringUsingEncoding:NSASCIIStringEncoding]);
	}
- (void) setGlobal: (NSString *) str withId:(NSString *) objId
{
    lua_pushstring(lua, [str cStringUsingEncoding:NSASCIIStringEncoding]);
    lua_setglobal(lua, [objId cStringUsingEncoding:NSASCIIStringEncoding]);
}
- (void) doFile: (NSString *) fileName
{
    NSString * luaCode=[OLAUIFactory loadResourceTextDirectly:fileName];
    luaL_dofile(lua, [fileName cStringUsingEncoding:NSASCIIStringEncoding]);
    //[self doString:luaCode];
    //luaL_dostring(lua, "print('test lua.')");
    //luaL_dostring(lua, "Log={} function Log:d(module,msg)  _Log:d_message(module,msg) end  print('Log.lua is executed')");
}


@end
