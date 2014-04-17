package com.lohool.ola.wedgit;

import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import android.content.Context;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.TableLayout;
import android.widget.TableRow;

public class ITable extends IContainer{

	public ITable(IView parent, Context context,  Node root) {
		super(parent, context,  root);
		v = new TableLayout(context);
		super.initiate();
		parseChildren();
	}
	
	
	void parseChildren()
	{
		NodeList nl=root.getChildNodes();
		for (int i = 0; i < nl.getLength(); i++)
        {

            Node n = nl.item(i);
            if (n != null && n.getNodeType() == Node.ELEMENT_NODE)
            {
            	String name=n.getNodeName();
            	System.out.println("Tag name="+name);
            	if(name.equalsIgnoreCase("THEAD") || name.equalsIgnoreCase("TBODY"))
            	{
            		Node row=n.getFirstChild();
            		parseRow(row);
            	}
            	else
            	{
            		parseRow(n);
            	}
            }
        }
	}
	
	void parseRow(Node node)
	{
		ITableRow row = new ITableRow(this, context, node);
		
		this.addView(row);
	}

}
