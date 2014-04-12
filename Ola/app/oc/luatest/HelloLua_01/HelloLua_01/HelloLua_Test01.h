extern "C"
{
#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"
#include "tolua++.h"
};
#include "LuaParam.h"
class CLuaFn
{
public:
	CLuaFn(void);
	~CLuaFn(void);

	void Init();				//��ʼ��Lua����ָ�����
	bool InitClass();		//��ʼ��tolua����
	void Close();			//�ر�Lua����ָ��
	
	bool LoadLuaFile(const char* pFileName);                              //����ָ����Lua�ļ�
	bool CallFileFn(const char* pFunctionName, int nParam1, int nParam2);        //ִ��ָ��Lua�ļ��еĺ���
	//�Զ�������
	bool PushLuaData(lua_State* pState, _ParamData* pParam);
	bool PopLuaData(lua_State* pState, _ParamData* pParam, int nIndex);
	bool CallFileFn(const char* pFunctionName, CParamGroup& ParamIn, CParamGroup& ParamOut);
private:
	lua_State* m_pState;   //�����Lua��State����ָ�룬�����һ��lua�ļ���Ӧһ����
};