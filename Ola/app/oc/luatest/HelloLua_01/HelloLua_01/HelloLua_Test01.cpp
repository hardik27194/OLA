#include "HelloLua_Test01.h"
#include "TestClass.h"

static int tolua_new_CTest(lua_State* pState)
{
	CTest* pTest = new CTest();
	tolua_pushusertype(pState, pTest, "CTest");
	return 1;
}
static int tolua_delete_CTest(lua_State* pState)
{
	CTest* pTest = (CTest* )tolua_tousertype(pState, 1, 0);
	if(NULL != pTest)
	{
		delete pTest;
	}
	return 1;
}

static int tolua_SetData_CTest(lua_State* pState)
{
	CTest* pTest = (CTest* )tolua_tousertype(pState, 1, 0);
	const char* pData = tolua_tostring(pState, 2, 0);

	if(pData != NULL && pTest != NULL)
	{
		pTest->SetData(pData);
	}

	return 1;
}

static int tolua_GetData_CTest(lua_State* pState)
{
	CTest* pTest = (CTest* )tolua_tousertype(pState, 1, 0);

	if(pTest != NULL)
	{
		char* pData = pTest->GetData();
		tolua_pushstring(pState, pData);
	}

	return 1;
}
CLuaFn::CLuaFn()
{
	m_pState=NULL;
	//初始化
	Init();
}
CLuaFn::~CLuaFn()
{
	//释放
	Close();
}
void CLuaFn::Init()
{
	if(NULL == m_pState)
	{
		m_pState = lua_open();
		luaL_openlibs(m_pState);
	}
	InitClass();
}
bool CLuaFn::InitClass()
{
	if(NULL == m_pState)
	{
		printf("[CLuaFn::InitClass]m_pState is NULL./n");
		return false;
	}
	tolua_open(m_pState);
	tolua_module(m_pState, NULL, 0);
	tolua_beginmodule(m_pState, NULL);

	tolua_usertype(m_pState, "CTest");
	tolua_cclass(m_pState, "CTest", "CTest", "", tolua_delete_CTest);

	tolua_beginmodule(m_pState, "CTest");
	tolua_function(m_pState, "new", tolua_new_CTest);
	tolua_function(m_pState, "SetData", tolua_SetData_CTest);
	tolua_function(m_pState, "GetData", tolua_GetData_CTest);
	tolua_endmodule(m_pState);

	tolua_endmodule(m_pState);

	return true;
}
void CLuaFn::Close()
{
	if(NULL != m_pState)
	{
		lua_close(m_pState);
		m_pState = NULL;
	}
}
bool CLuaFn:: LoadLuaFile(const char* pFileName)
{
	int nRet = 0;
	if(NULL == m_pState)
	{
		printf("[CLuaFn:: LoadLuaFile]m_pState is NULL./n");
		return false;
	}
	nRet = luaL_dofile(m_pState, pFileName);
	if (nRet != 0)
	{
		printf("[CLuaFn:: LoadLuaFile]luaL_loadfile(%s) is file(%d)(%s)./n", pFileName, nRet, lua_tostring(m_pState, -1));
		return false;
	}
	printf("[CLuaFn:: LoadLuaFile]读取文件(%s)成功\n", pFileName);
	return true;
}
bool CLuaFn::CallFileFn(const char* pFunctionName, int nParam1, int nParam2)
{
	int nRet = 0;
	if(NULL == m_pState)
	{
		printf("[CLuaFn::CallFileFn]m_pState is NULL./n");
		return false;
	}
	lua_getglobal(m_pState, pFunctionName);

	lua_pushnumber(m_pState, nParam1);
	lua_pushnumber(m_pState, nParam2);
	printf("压入参数完成，下面我们查看一下栈的情况：\n");
	int nIn = lua_gettop(m_pState);
	//int iValue;
	//谨记 Lua的栈是从1开始的
	for (int i=1;i<=nIn;++i)
	{
		//iValue=lua_tonumber(m_pState, i);
		//luaNumber使用的Double 所以不能直接用%d表示 
		printf("N.%d(绝对坐标)元素:%d.\n",i,(int)lua_tonumber(m_pState, i));
	}
	nRet = lua_pcall(m_pState, 2, 1, 0 );
	if (nRet != 0)
	{
		printf("\n调用Lua脚本成功\n");
		printf("[CLuaFn::CallFileFn]call function(%s) error(%d).\n", pFunctionName, nRet);
		return false;
	}
/*
	if (lua_isnumber(m_pState, -1) == 1)
	{
		int nSum = lua_tonumber(m_pState, -1);
		printf("\n[CLuaFn::CallFileFn]Sum = %d. \n", nSum);
	}*/

	printf("\n调用完成，返回结果如下：\n");
	nIn = lua_gettop(m_pState);
	for (int i=1;i<=nIn;++i)
	{
		printf("N.%d(绝对坐标)元素:%d.\n",i,(int)lua_tonumber(m_pState, i));
	}
	//lua_settop(m_pState,-2);
	//自动完成清栈
	lua_settop(m_pState,-(++nIn));
	return true;
}
bool CLuaFn::PushLuaData(lua_State* pState, _ParamData* pParam)
{
	if(pParam == NULL)
	{
		return false;
	}
	if(pParam->CompareType("string"))
	{
		lua_pushstring(m_pState, (char* )pParam->GetParam());
		return true;
	}

	if(pParam->CompareType("int"))
	{
		int* nData = (int* )pParam->GetParam();
		lua_pushnumber(m_pState, *nData);
		return true;
	}
	else
	{
		void* pVoid = pParam->GetParam();
		tolua_pushusertype(m_pState, pVoid, pParam->GetType());
		return true;
	}
}
bool CLuaFn:: PopLuaData(lua_State* pState, _ParamData* pParam, int nIndex)
{
	if(pParam == NULL)
	{
		return false;
	}
	if(pParam->CompareType("string"))
	{
		if (lua_isstring(m_pState, nIndex) == 1)
		{
			const char* pData = (const char*)lua_tostring(m_pState, nIndex);
			pParam->SetData((void* )pData, (int)strlen(pData));
		}
		return true;
	}

	if(pParam->CompareType("int"))
	{
		if (lua_isnumber(m_pState, nIndex) == 1)
		{
			int nData = (int)lua_tonumber(m_pState, nIndex);
			pParam->SetData(&nData, sizeof(int));
		}
		return true;
	}
	else
	{
		pParam->SetData(tolua_tousertype(m_pState, nIndex, NULL), -1);
		return true;
	}
}
bool CLuaFn::CallFileFn(const char* pFunctionName, CParamGroup& ParamIn, CParamGroup& ParamOut)
{
	int nRet = 0;
	int i    = 0;
	if(NULL == m_pState)
	{
		printf("[CLuaFn::CallFileFn]m_pState is NULL./n");
		return false;
	}
	lua_getglobal(m_pState, pFunctionName);

	//加载输入参数
	for(i = 0; i < ParamIn.GetCount(); i++)
	{
		PushLuaData(m_pState, ParamIn.GetParam(i));
	}

	nRet = lua_pcall(m_pState, ParamIn.GetCount(), ParamOut.GetCount(), 0);
	if (nRet != 0)
	{
		printf("[CLuaFn::CallFileFn]call function(%s) error(%s)./n", pFunctionName, lua_tostring(m_pState, -1));
		return false;
	}

	//获得输出参数
	int nPos = 0;
	for(i = ParamOut.GetCount()-1; i >= 0; --i)
	{
		--nPos;
		PopLuaData(m_pState, ParamOut.GetParam(i), nPos);
	}

	int nCount = lua_gettop(m_pState);
	lua_settop(m_pState, -1-ParamOut.GetCount());

	return true;
}
