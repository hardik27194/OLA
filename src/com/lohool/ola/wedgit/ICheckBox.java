package com.lohool.ola.wedgit;

import org.w3c.dom.Node;

import android.content.Context;
import android.widget.CheckBox;;

public class ICheckBox extends IWedgit
{

	public ICheckBox(IView parent, Context context, Node root)
	{
		super(parent, context, root);
		CheckBox t=new CheckBox(context);
		
		v=t;
		super.initiate();
		t.setGravity(css.getGravity());
	}
	public  boolean isChecked()
	{
		CheckBox t=(CheckBox) v;
		return t.isChecked();
	}
	
	public void setChecked(boolean bool)
	{
		CheckBox t=(CheckBox) v;
		t.setChecked(bool);
	}
}
