package com.lohool.ola.util;

import java.util.HashMap;
import java.util.UUID;

import org.keplerproject.luajava.LuaState;

public class DataCache {

	LuaState lua;
	HashMap cache=new HashMap();
	
	DataCache instance=null;
	
	private DataCache(LuaState lua)
	{
		this.lua=lua;
	}
	public DataCache getInstance(LuaState lua)
	{
		if(instance==null)
		{
			instance= new DataCache(lua);
		}
		
		return instance;
	}
	
	public String createByteArrayCache(int length)
	{
		String id="Cache_"+UUID.randomUUID().toString();
		byte[] ba=new byte[length];
		
		return id;
	}
	
}
