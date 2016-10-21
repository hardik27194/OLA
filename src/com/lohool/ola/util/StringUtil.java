package com.lohool.ola.util;

import java.util.ArrayList;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import com.lohool.ola.LuaContext;

public class StringUtil {

	public static String UTF6LE(int uc,int lc)
	{
		if(lc<0)lc=lc&0xFF;
		return  String.valueOf((char) ((uc << 8) + lc));
	}
	
	public static String toUTF6LE(String byteArray)
	{
		StringBuffer buf= new StringBuffer();
//		buf.deleteCharAt(buf.length()-1);
//		buf.deleteCharAt(0);
		String[] bs=byteArray.split(",");
		int i=0;
		for(i=0;i<bs.length;i++)
		{
			if(i>=bs.length || bs[i].equals("") || i+1>=bs.length || bs[i+1].equals(""))
			{
				i++;
			}
			else
			{
				int l=Integer.parseInt(bs[i]);
				i++;
				int h=Integer.parseInt(bs[i]);
				buf.append(UTF6LE(h,l));
			}
		}
		return buf.toString();
	}
	
	/**
	 * add a new parameter to the callback method
	 * @param callback
	 * @param param
	 * @return
	 */
	public static String addParameter(String callback, String param)
	{
		callback=callback.trim();
		String s;
		int pos=callback.lastIndexOf(")");
		if (callback.charAt(callback.length()-1)==')')
		{
			String pre=callback.substring(0,callback.length()-1).trim();
			if(pre.charAt(pre.length()-1)!='(')s=pre+","+param+")";
			else s=pre+param+")";
		}
		else s=callback;
		return s;
	}
	public static void match(String luaFieldName, String str, String reg)
	{
		Pattern pattern = Pattern.compile(reg);
        Matcher m = pattern.matcher(str);
        ArrayList<String> result=new ArrayList<String>();
        LuaContext lua=LuaContext.getInstance();
        lua.doString(luaFieldName+"={}");
        
        int pos=1;
        while(m.find()){
        	int count=m.groupCount();
        	StringBuffer r=new StringBuffer();
        	for(int i=0;i<=count;i++)
        	{
        		String v=m.group(i);
                r.append("\""+v.replaceAll("\"", "\\\\\"")+"\",");
        	}
        	r.deleteCharAt(r.length()-1);
        	
        	//System.out.println(luaFieldName+"["+(pos)+"]={"+r.toString().replaceAll("\n", "")+"}");
        	lua.doString(luaFieldName+"["+(pos)+"]={"+r.toString().replaceAll("\n", "")+"}");
        	//System.out.println(luaFieldName+"["+(pos)+"]={"+r.toString().replaceAll("\n", "")+"}");
        	pos++;
                
        }
        
//        
//        for(int i=0;i<result.size();i++)
//        {
//        	System.out.println(luaFieldName+"["+(i+1)+"]=\""+result.get(i).replaceAll("\"", "\\\\\"")+"\"");
//        	lua.doString(luaFieldName+"["+(i+1)+"]=\""+result.get(i).replaceAll("\"", "\\\\\"")+"\"");
//        	
//        }
        //lua.regist(res, luaFieldName);
	
	}
}
