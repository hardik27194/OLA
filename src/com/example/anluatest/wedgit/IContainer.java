package com.example.anluatest.wedgit;


import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import com.example.anluatest.LuaContext;
import com.example.anluatest.UIFactory;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.TableRow;

public abstract class IContainer extends IWedgit{

	
	public IContainer(IView parent, Context context, Node root) {
		super(parent, context, root);
		// TODO Auto-generated constructor stub
	}
//	public void addView(View child)
//	{
//		((ViewGroup)v).addView(child);
//		//child.requestLayout();
//	}
//	void addView(IView child)
//	{
//		((ViewGroup)v).addView(child.getView());
//		//child.getView().requestLayout();
//	}
	
	 void parseChildren(IContainer rootView,Node root)
	{
		NodeList nl=root.getChildNodes();
		for (int i = 0; i < nl.getLength(); i++)
        {

            Node n = nl.item(i);
            if (n != null && n.getNodeType() == Node.ELEMENT_NODE)
            {
            	String name=n.getNodeName();
            	if(name.equalsIgnoreCase("DIV"))
            	{
            		String layoutName=((Element)n).getAttribute("layout");
            		if(layoutName.equalsIgnoreCase("FrameLayout") 
            		   || (layoutName.equalsIgnoreCase("LinearLayout")) || (layoutName.equalsIgnoreCase("RelativeLayout")))
            		{
            			Layout layout=Layout.createLayout(rootView,this.context,n);
            			rootView.addView(layout);
            		}
            	}
            	else 
            	{
            		IView view=UIFactory.createView(rootView, context,   n);
            		rootView.addView(view);
            	}
            	
                
            }
        }
	}

	public void addView(View child) {
		((ViewGroup) v).addView(child);
		child.requestLayout();
	}

	public void addView(IView child) {

		if(child.getParent()==null)
		{
			child.setParent(this);
			//rebuild the properties of the view.
			//be rebuilt by the setParent method
			//((IWedgit)child).parseCSS();
		}
		((ViewGroup) v).addView(child.getView());
		child.getView().requestLayout();
	}
	public void removeView(IView child) {
		if (child==null) return;
		((ViewGroup) v).removeView(child.getView());
		
	}
	
	/**
	 * add a child by Lua id, this method will be used by the lua script
	 * @param id
	 */
	public void addView(String id)
	{
		//lua.getGlobal(id);
		System.out.println("add view:this.id="+((Element) root).getAttribute("id")+"; child.id="+id);
			Object obj=LuaContext.getInstance().getObject(id);
			addView((IView)obj);


	}
	/**
	 * remove a child view from the current container by the child's lua id
	 * @param id
	 */
	public void removeChild(String id)
	{
			Object obj=LuaContext.getInstance().remove(id);
			removeView((IView)obj);
	}
}
