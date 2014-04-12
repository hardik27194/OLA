#import <Foundation/Foundation.h>
#import <lua.h>
#import <lualib.h>
#import <lauxlib.h>
#import "CLuaFun.h"



@implementation CLuaFun

- (CLuaFun *) Init
{  
	[super init];
        if(NULL == m_pState)  
        {  
                m_pState = luaL_newstate();//lua_open();  
                luaL_openlibs(m_pState);  
				[self pushJavaClass:m_pState];
        }  
			return self;

} 
- (void)dealloc {
	if(NULL != m_pState)  
        {  
                lua_close(m_pState);  
		[m_pState release];
        }
    [super dealloc];
}

- (void) Close  
{  
        if(NULL != m_pState)  
        {  
                lua_close(m_pState);  
                m_pState = NULL;  
        }  
}  



- (bool)  LoadLuaFile: (char *) pFileName
  
{  
  
        int nRet = 0;  
  
        if(NULL == m_pState)  
  
        {  
  
                printf("[ LoadLuaFile]m_pState is NULL./n");  
  
                return false;  
  
        }  
  
  
  
        nRet = luaL_dofile(m_pState, pFileName);  
  
        if (nRet != 0)  
  
        {  
  
                printf("[ LoadLuaFile]luaL_loadfile(%s) is file(%d)(%s)./n", pFileName, nRet, lua_tostring(m_pState, -1));  
  
                return false;  
  
        }  
  
  
  
        return true;  
  
} 

- (bool) CallFileFn: (char *) pFunctionName nParam1:(int) nParam1  nParam2:(int) nParam2
  
{  
  
        int nRet = 0;  
  
        if(NULL == m_pState)  
  
        {  
  
                printf("[CallFileFn]m_pState is NULL./n");  
  
                return false;  
  
        }  
  
  
  
        lua_getglobal(m_pState, pFunctionName);  
  
  
  
        lua_pushnumber(m_pState, nParam1);  
  
        lua_pushnumber(m_pState, nParam2);  
  
  
  
        nRet = lua_pcall(m_pState, 2, 1, 0);  
  
        if (nRet != 0)  
  
        {  
  
                printf("[CallFileFn]call function(%s) error(%d).\n", pFunctionName, nRet);  
  
                return false;  
  
        }  
  
  
  
        if (lua_isnumber(m_pState, -1) == 1)  
  
        {  
  
                int nSum = lua_tonumber(m_pState, -1);  
  
                printf("[CallFileFn]Sum = %d.\n", nSum);  
  
        }  
  
  
  
        return true;  
  
}  
+ (int) CreateCTest:(lua_State*) L
{    // 创建一个元表为CTest的Table——Lua对象  
	 CLuaFun** pData = (CLuaFun**)lua_newuserdata(L, sizeof(CLuaFun*));   
	 *pData = (CLuaFun *)[[CLuaFun alloc] init];
	luaL_getmetatable(L, "CLuaFun");  
	lua_setmetatable(L, -2);    
	return 1;
}


- (int) pushJavaClass:(lua_State *) L  
{
   // 创建一个元表为CTest的Table——Lua对象
    //CLuaFun *test=(CLuaFun *)[[CLuaFun alloc] init];
   // lua_newuserdata(L, sizeof(test));


	// CLuaFun** pData = (CLuaFun**)lua_newuserdata(L, sizeof(CLuaFun*));   
	// *pData = (CLuaFun *)[[CLuaFun alloc] init];

	NSLog(@"[CLuaFun]size = %d.\n", sizeof( CLuaFun *) ); 
     CLuaFun ** userData = ( CLuaFun ** ) lua_newuserdata( L , sizeof( CLuaFun *) );
    *userData = (CLuaFun *)[[CLuaFun alloc] init];

    luaL_getmetatable(L, "CLuaFun");
    lua_setmetatable(L, -2);


   // lua_pushcfunction(L,[ CLuaFun CreateCTest]);    // 注册用于创建类的全局函数
   // lua_setglobal(L,  "CLuaFun");
    
    luaL_newmetatable(L, "CLuaFun");           // 创建一个元表
	 luaL_dostring(L,"print (type(CLuaFun))");

    //lua_pushstring(L, "__gc");                    // 垃圾回收
    //lua_pushcfunction(L, DestoryCTest);
    //lua_settable(L, -3);                               // 公共函数调用的实现就在此啊

    lua_pushstring(L, "__index");
    lua_pushvalue(L, -2);                           // 注意这一句，其实是将__index设置成元表自己
    lua_settable(L, -3);

    lua_pop(L,1);


   return 1;
}
+(void) d:(NSString *)message
{
	NSLog(message);
}

class CTest  
{  
public:  
    //带一个参数的构造函数   
    CTest(int value):m_value(value){};  
    virtual ~CTest(){};  
  
    //进行加操作   
    int Add(int x,int y)  
    {  
        printf("%p Add:x=%d,y=%d\n",this,x,y);  
        return x + y;  
    }  
  
    //访问类成员   
    void PrintValue()  
    {  
        printf("Value = %d\n",m_value);  
    }  
private:  
    int m_value;  
  
};
int main(int argc, const char *argv[]) 
  
{  
  
        CLuaFun *LuaFn=[[CLuaFun alloc] Init];  
  
  
  
        //LuaFn.InitClass();   
  
  
  
        [LuaFn LoadLuaFile:"testLua.lua"];  
  
        [LuaFn CallFileFn:"func_Add" nParam1:11  nParam2:12];  
  
        getchar();  
  
  
  
        return 0;  
  
}  

@end