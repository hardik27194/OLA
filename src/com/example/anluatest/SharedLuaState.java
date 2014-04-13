package com.example.anluatest;

import java.util.HashMap;

import org.keplerproject.luajava.LuaState;
import org.keplerproject.luajava.LuaStateFactory;

public class SharedLuaState {
//	private LuaState lua;
	
	HashMap sharedData=new HashMap();
	public SharedLuaState()
	{
//		lua = LuaStateFactory.newLuaState();
//		lua.openLibs();
	}
	public void addLuaScript(String url)
	{
//		String scode=UIFactory.loadAssetsString(url);
//		lua.LdoString(scode);
	}
	public void execute(String luaCode)
	{
		
	}
	public void add(String name,String value)
	{
		sharedData.put(name, value);
	}
	public void add(String name,Object value)
	{
		sharedData.put(name, value);
	}
	public void addTable(String name)
	{
		sharedData.put(name, new HashMap());
	}
	public void addByteArray(String name)
	{
		sharedData.put(name, new byte[0]);
	}
}
