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
	
	ArrayList<CssClassAttr> classesStyles=new ArrayList<CssClassAttr>();

	/**
	 * all of the  CSS styles of the whole page
	 */
	private String styles=null;
	
	
	/**
	 * a single CSS class
	 * @author Terrence
	 *
	 */
	class CssClassAttr
	{
		String className;
		/**
		 * the CSS styles defination
		 */
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
	


	
	public CssClass()
	{
		this.styles="";
	}
	public CssClass(String styles)
	{
		this.styles=styles.trim();
		if(styles!=null && !this.styles.equals(""))parseStyles(this.styles);
	}
	/**
	 * append a CSS style string to the current styles
	 * @param style
	 */
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
		// to think the char "}" is the end signal of a CSS Class phrase
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
		
		//the CSS Class's name, and remove redundant blank chars
		if(preBracketPos>0)name=s.substring(0,preBracketPos).trim().replace(" +", " ");
		s=s.substring(preBracketPos+1,postBracketPos).trim();
		
		CssClassAttr clz=new CssClassAttr(name,s);
		CssClassAttr oldClz=null;
		// does the new CSS Class exist in the current CSS Class pool
		//if exist, append the new style string to the end of it, or put the new Class into the pool
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
		//System.out.println(name+":\n"+s);
	}

	/**
	 * find a view's CSS style string from the CSS class pool
	 * @param tag	view's dom tag name in the XML file
	 * @param className	the view's class name in the XML file
	 * @param view the view
	 * @return
	 */
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
		
		//multiple class names
		String[] classes=className.split(" +");
		
		//Node n=view.getRoot();
		for(CssClassAttr clz:classesStyles)
		{
			//DIV .class1 button .btn2
			String key=clz.className;
			//key=key.replaceAll(" *", " ");
			//key=key.replaceAll(" \\\\.", "");
			
			String[] clzs=key.split(" ");
			
			//from the end to first to match the class array
			boolean isMatchTag=clzs[clzs.length-1].equalsIgnoreCase(tag);
			//matches <TAG.CLZ> or <.CLZ>
			boolean isMatchClass=false;
			for(String s:classes)
			{
				isMatchClass=(clzs[clzs.length-1].equalsIgnoreCase("."+s) || clzs[clzs.length-1].equalsIgnoreCase(tag+"."+s));
				//System.out.println("CSS match class:"+clzs[clzs.length-1]+"=="+tag+"."+s+":"+isMatchClass);
				if(isMatchClass)break;
			}
			
			if( isMatchTag || isMatchClass)
			{
				
				IView parent=view.getParent();
					//test to match previous class
					boolean isMatch=true;
					//from the parent
					int i=clzs.length-2;
					while(parent!=null && i>=0)
					{
						String previousClass=clzs[i];
						Element parentnode=(Element)parent.getRoot();
						String parentTagName=parentnode.getTagName();
						String parentClz=parentnode.getAttribute("class");
						//if previous class name matches parent's class
						//by TAG==TAG or CLASS==CLASS or TAG.CLASS=TAG.CLASS
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
						//System.out.println("CSS match:"+previousClass+"=="+parentTagName+"."+parentClz+":"+isMatch);
						//the previous class does match the parent node, then test the parent's parent
						//if match, test previous's previous with parent's parent
						if(isMatch)
						{
							i--;							
						}
						
							parent=parent.getParent();

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
