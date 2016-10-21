package com.lohool.ola;

import java.util.HashMap;

/**
 * since there are OLAOS,OLA Portal and many applications, so need to keep some data between them.
 * Session is to keep data during the OLA App running time.
 * should be basic String data in order to that Lua can use them
 * 
 * @author xingbao-
 *
 */
public class Session
{
	static HashMap<String,String> params=new HashMap();
	
	public static void put(String k, String v)
	{
		params.put(k, v);
	}
	
	public static String get(String k)
	{
		return params.get(k);
	}
	
	public static void remove(String k)
	{
		params.remove(k);
	}
	public static void clear()
	{
		params.clear();
	}
}
