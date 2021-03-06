package com.lohool.ola;

import org.keplerproject.luajava.LuaException;
import org.keplerproject.luajava.LuaObject;
import org.keplerproject.luajava.LuaState;
import org.keplerproject.luajava.LuaStateFactory;



public class LuaContext {
	
	private LuaState lua;
	
	private static LuaContext instance;
	
	private LuaContext()
	{
		open();
	}
	public static LuaContext createInstance()
	{
//		if(instance==null)
//		{
//			instance = new LuaContext();
//		}
		LuaContext instance = new LuaContext();
		return instance;
	}
	public static void registInstance(LuaContext lua)
	{
			instance = lua;

	}
	public static LuaContext getInstance()
	{
		return instance;
	}
	public  void open()
	{
		lua = LuaStateFactory.newLuaState();
		lua.openLibs();
	}
	
	public  LuaState getLuaState()
	{
		return lua;
	}
	
	public  void regist(Object obj, String name)
	{
		try {
			lua.pushObjectValue(obj);
			lua.setGlobal(name);
		} catch (LuaException e) {
			e.printStackTrace();
		}
		
	}
	public Object remove(String id)
	{
		Object obj=null;
		try {
			obj=lua.getLuaObject(id).getObject();
			lua.getGlobal(id);
			lua.remove(-1);
			
		} catch (LuaException e) {
			e.printStackTrace();
		}
		return obj;
	}
	public Object getObject(String id)
	{
		Object obj = null;
		try {
			obj = getLuaObject(id).getObject();
		} catch (LuaException e) {
			e.printStackTrace();
		}
		return obj;
	}
	private LuaObject getLuaObject(String id)
	{
		LuaObject obj = null;
		obj = lua.getLuaObject(id);
		return obj;
	}
//	public Object getUserDateObject(String id) throws LuaException
//	{
//		Object obj = null;
//		lua.getGlobal(id);
//		//lua.getTable(-1);
//		obj=lua.getObjectFromUserdata(-1);
//		return obj;
//	}
	public void doString(String str)
	{
		lua.LdoString(str);
	}
	
	public void doFile(String file)
	{
		System.out.println("Lua file:"+file);
		
		lua.LdoFile(file);
	}
	
	
	public String getGlobalString(String globalName)
	{
		lua.LdoString("return "+globalName);
		String g=lua.toString(-1);
		lua.pop(-1);
		return g;
	}
	public void setGlobal(String val,String id)
	{
		lua.pushString(val);
		lua.setGlobal(id);
	}
	public void close()
	{
		if(lua!=null && !lua.isClosed())lua.close();
	}
}
