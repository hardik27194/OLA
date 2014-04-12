#include "HelloLua_Test01.h"
#pragma  comment(lib,"lua.lib")
#include <iostream>
//hemu 111026 take all those easy
void Test01()
{
	CLuaFn LuaFn;
	//LuaFn.InitClass();
	if(LuaFn.LoadLuaFile("../Script/Test01.lua"))
	{
		for(int i=1;i<10;++i)
		{
			printf("\n===============第%d调用Lua脚本开始==============\n",i);
			LuaFn.CallFileFn("func_Add", 11, 12);
			printf("===============第%d调用Lua脚本完成==============\n",i);
		}

	}
}
void Test02()
{
	CLuaFn LuaFn;
	LuaFn.LoadLuaFile("../Script/Test02.lua");

	CParamGroup ParamIn;
	CParamGroup ParamOut;

	char szData1[20] = {'\0'};
	sprintf(szData1, "[参数1]");
	_ParamData* pParam1 = new _ParamData(szData1, "string", (int)strlen(szData1));
	ParamIn.Push(pParam1);

	char szData2[20] = {'\0'};
	sprintf(szData2, "[参数2]");
	_ParamData* pParam2 = new _ParamData(szData2, "string", (int)strlen(szData2));
	ParamIn.Push(pParam2);

	char szData3[40] = {'\0'};
	_ParamData* pParam3 = new _ParamData(szData3, "string", 40);
	ParamOut.Push(pParam3);

	LuaFn.CallFileFn("func_Add", ParamIn, ParamOut);

	char* pData = (char* )ParamOut.GetParam(0)->GetParam();
	printf("[Main]Sum = %s.\n", pData);

	getchar();

}
int main(int argc, char * argv[])
{
	int iChoice;
PLEASECHOOSE:
	std::cout<<"请选择Lua测试实例（1~9）:"<<endl;
	std::cin>>iChoice;
	switch(iChoice)
	{
	case 1:
		Test01();
		break;
	case 2:
		Test02();
		break;
	default:
		std::cout<<"输入错误"<<endl;
		goto PLEASECHOOSE;
		break;
	}
	getchar();
	return 0;
}