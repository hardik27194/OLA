package com.lohool.ola.wedgit;

import android.annotation.SuppressLint;

import org.w3c.dom.*;

import android.content.Context;
import android.view.Gravity;
import android.widget.LinearLayout;


//Layout
@SuppressLint("NewApi")
public class ILinearLayout extends Layout
{

	int[] bounds;

	String layout="LinearLayout";

	public ILinearLayout(Context context) {
		super(context);
		parseAlignment();
	}
	
	public ILinearLayout(IView parent,Context context,Node root) {
		super(parent, context,  root);
		LinearLayout t=new LinearLayout(context);
		
		v=t;
		super.initiate();
		//System.out.println("LinearLayout layout created");
		t.setGravity(css.getGravity());
		//System.out.println("LinearLayout setGravity created");
		parseAlignment();
		//System.out.println("LinearLayout parseAlignment created");
		parseChildren(this,root);
		//System.out.println("LinearLayout parseChildren created");
		
	}
	private void parseAlignment()
	{
			LinearLayout l=(LinearLayout)v;
			if(css.orientation!=null && css.orientation.equals("vertical"))
				l.setOrientation(LinearLayout.VERTICAL);
			else
				l.setOrientation(LinearLayout.HORIZONTAL);
	}




}
