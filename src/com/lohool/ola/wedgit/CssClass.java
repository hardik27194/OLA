package com.lohool.ola.wedgit;


import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import org.w3c.dom.Element;
import org.w3c.dom.Node;

import com.lohool.ola.wedgit.CssClass.CssClassAttr;

public class CssClass
{
	class CssClassAttr
	{
		String className;
		String styles;
		public CssClassAttr(String className,String styles){
			this.className=className;
			this.styles=styles;
		}
		public boolean equals(Object o)
		{
			 if(this==o) return true;  
			 if(!(o instanceof CssClassAttr)) return false;  
 
			 final CssClassAttr u=(CssClassAttr)o ;
			 if(this.className.equals(u.className)  )
			     return true;  
			  else  
			     return false; 
		}
		public int hashCode()
		{
			return className.hashCode();
		}
	}
	

	ArrayList<CssClassAttr> classesStyles=new ArrayList<CssClassAttr>();

	
	String styles=null;
	
	public CssClass()
	{
		this.styles="";
	}
	public CssClass(String styles)
	{
		this.styles=styles.trim();
		if(styles!=null && !this.styles.equals(""))parseStyles(this.styles);
	}
	
	public void addStyle(String style)
	{
		
		
		if(style!=null && !style.trim().equals("") )
		{
			String s=style.trim();
			this.styles+=s;
			parseStyles(s);
		}
	}
	
	private void parseStyles(String styles)
	{
		String[] classArray=styles.split("\\}");
		for(String s:classArray)
		{
			s=s.trim();
//			if(s.indexOf(" ")>1)parseCompisiteStyles(s);
//			else 
				parseTagStyles(s);
		}
	}

	private void parseTagStyles(String styles)
	{
		String s=styles.trim();

		String name=null;
		int preBracketPos=0;
		int postBracketPos=s.length();
		for(int i=0;i<s.length()-1;i++)
		{
			char c=s.charAt(i);
			if(c=='{')preBracketPos=i;
			else if(c=='}')postBracketPos=i;
		}
		if(preBracketPos>0)name=s.substring(0,preBracketPos).trim().replace(" +", " ");
		s=s.substring(preBracketPos+1,postBracketPos).trim();
		
		CssClassAttr clz=new CssClassAttr(name,s);
		CssClassAttr oldClz=null;
		for(CssClassAttr tmp:classesStyles)
		{
			if(tmp.equals(clz))
			{
				oldClz=tmp;
				break;
			}
		}
		
		if(oldClz!=null)
		{
			oldClz.styles+=clz.styles;
		}
		else
		{
			classesStyles.add(clz);
		}
		System.out.println(name+":\n"+s);
	}

	
	public String getStyle(String tag, String className,IView view)
	{
		String v="";
		/*
		for(CssClassAttr clz:singleClassesStyles)
		{
		v=this.singleClassesStyles.get(tag);
		if(v==null)v="";
		if(className!=null)
		{
			String v1=this.singleClassesStyles.get("."+className);
			if(v1!=null)v+=v1;
		}
		}
		*/
		//Iterator<String> keys=this.compositeClassesStyles.keySet().iterator();
		String[] classes=className.split(" +");
		
		Node n=view.getRoot();
		for(CssClassAttr clz:classesStyles)
		{
			//DIV .class1 button .btn2
			String key=clz.className;
			//key=key.replaceAll(" *", " ");
			//key=key.replaceAll(" \\\\.", "");
			
			String[] clzs=key.split(" ");
			
			//from the end to start to match the class array
			boolean isMatchTag=clzs[clzs.length-1].equalsIgnoreCase(tag);
			//matches <TAG.CLZ> or <.CLZ>
			boolean isMatchClass=false;
			for(String s:classes)
			{
				isMatchClass=(clzs[clzs.length-1].equalsIgnoreCase("."+s) || clzs[clzs.length-1].equalsIgnoreCase(tag+"."+s));
				System.out.println("CSS match class:"+clzs[clzs.length-1]+"=="+tag+"."+s+":"+isMatchClass);
				if(isMatchClass)break;
			}
			
			if( isMatchTag || isMatchClass)
			{
				
				IView cv=view.getParent();
					//test to match previous class
					boolean isMatch=true;
					//from the parent
					int i=clzs.length-2;
					while(cv!=null && i>=0)
					{
						String previousClass=clzs[i];
						Element parentNode=(Element)cv.getRoot();
						String parentTagName=parentNode.getTagName();
						String parentClz=parentNode.getAttribute("class");
						if( previousClass.equalsIgnoreCase(parentTagName)
								|| previousClass.equalsIgnoreCase("."+parentClz)
								|| previousClass.equalsIgnoreCase(parentTagName+"."+parentClz)
								)

						{
							isMatch=true;
						}
						else
						{
							isMatch=false;
						}
						System.out.println("CSS match:"+previousClass+"=="+parentTagName+"."+parentClz+":"+isMatch);
						//the previous class does match the parent node, then test the parent's parent
						//if match, test previous's previous with parent's parent
						if(isMatch)
						{
							i--;							
						}
						
							IView parent=cv.getParent();
							cv=parent;

					}
					// the whole class path was tested withe the XML node tree
					if(isMatch && i<0)
					{
						// the tag/class matches with the XML node tree
						v+=clz.styles;
					}
					else
					{
						//does not match
					}
				
			}
		}
		
		
		return v;
		
	}
	public static void  main(String[] arg)
	{
		CssClass cc=new CssClass(".test{width:auto;indeterminate:false;indeterminateOnly:false;value:0;} test1{ height:15px; margin:1px;style:horizontal; }");
		cc.addStyle(".test{width:10px;}");
	}
}
