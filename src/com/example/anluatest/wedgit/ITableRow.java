package com.example.anluatest.wedgit;


import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import android.content.Context;
import android.view.Gravity;
import android.widget.TableRow;


public class ITableRow extends IContainer{

	public ITableRow(IView parent, Context context,  Node root) {
		super(parent, context, root);
		TableRow t = new TableRow(context);
		v=t;
		//if parseCSS() was executed, the cell will not auto be set to equal width of the row
		super.initiate();
		t.setGravity(css.getGravity());
		parseChildren();
	}

	void parseChildren()
	{
		String rootname=root.getNodeName();
    	System.out.println("Tablerow Tag name="+rootname);
		NodeList nl=root.getChildNodes();
		for (int i = 0; i < nl.getLength(); i++)
        {

            Node n = nl.item(i);
            if (n != null && n.getNodeType() == Node.ELEMENT_NODE)
            {
            	String name=n.getNodeName();
            	System.out.println("Tablerow child Tag name="+name);
            	if(name.equalsIgnoreCase("TD") )
            	{

            		parseChildren(this,n);
            	}
            }
        }
	}

}
