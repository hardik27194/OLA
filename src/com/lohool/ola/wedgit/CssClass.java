package com.lohool.ola.wedgit;

import java.util.HashMap;
import java.util.Map;

public class CssClass
{
	Map classMap=new HashMap();
	Map tagMap=new HashMap();
	String styles=null;
	
	public CssClass(String styles)
	{
		this.styles=styles;
		parseStyles();
	}
	
	void parseStyles()
	{
		String[] classArray=styles.split("}");
		for(String s:classArray)
		{
			parseClassStyles(s);
		}
	}
	void parseClassStyles(String styles)
	{
		String s=styles.trim();
		char dot=s.charAt(0);
		//s=s.substring(1,s.length()-1);
		//StringBuffer name=new StriingBuffer();
		String name=null;
		int preBracketPos=0;
		int postBracketPos=s.length();
		for(int i=1;i<s.length()-1;i++)
		{
			char c=s.charAt(i);
			if(c=='{')preBracketPos=i;
			else if(c=='}')postBracketPos=i;
		}
		name=s.substring(1,preBracketPos);
		s=s.substring(preBracketPos+1,postBracketPos);
		System.out.println(name+":\n"+s);
		classMap.put(name, s);
	}
	public static void  main(String[] arg)
	{
		CssClass cc=new CssClass(".test{width:auto;indeterminate:false;indeterminateOnly:false;value:0;} .test1{height:15px;margin:1px;style:horizontal;}");

	}
}
