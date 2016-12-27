package com.lohool.ola.wedgit;


import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import com.lohool.ola.LuaContext;
import com.lohool.ola.UIFactory;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.TableRow;

public abstract class IContainer extends IWedgit{


	//public UIFactory ui;
	public IContainer(IView parent, Context context, Node root,UIFactory ui) {
		super(parent, context, root,ui);
		// TODO Auto-generated constructor stub
		//this.ui=ui;
	}

	
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
//         		if( layoutName.equalsIgnoreCase("FrameLayout") 
//         		   || layoutName.equalsIgnoreCase("LinearLayout")
//         		   || layoutName.equalsIgnoreCase("RelativeLayout")	   
//         				   )
         		{
         			Layout layout=ui.createLayout(rootView,context,n);
         			rootView.addOlaView(layout);
         		}
         	}
         	else 
         	{
         		IView view=ui.createView(rootView, context,   n);
         		rootView.addOlaView(view);
         	}

             
         }
     }
	}
	 
	public void addOlaView(IView child) {

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
	
	/**
	 * add a child by Lua id, this method will be used by the lua script
	 * @param id
	 */
	public void addView(String id)
	{
		//lua.getGlobal(id);
		//System.out.println("add view:this.id="+((Element) root).getAttribute("id")+"; child.id="+id);
		Object obj = LuaContext.getInstance().getObject(id);
		addOlaView((IView) obj);
	}
	
	public void removeOlaView(IView child) {
		if (child==null) return;
		((ViewGroup) v).removeView(child.getView());
	}
	

	/**
	 * remove a child view from the current container by the child's lua id
	 * @param id
	 */
	public void removeView(String id)
	{
			Object obj=LuaContext.getInstance().remove(id);
			removeOlaView((IView)obj);
	}
	
	public void removeAllViews() {
		((ViewGroup) v).removeAllViews();
	}

}
