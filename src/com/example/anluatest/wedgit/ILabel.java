package com.example.anluatest.wedgit;


import org.w3c.dom.Node;

import android.annotation.SuppressLint;
import android.content.Context;
import android.view.Gravity;

import android.widget.TextView;

@SuppressLint("NewApi")
public class ILabel  extends IWedgit {
	public ILabel(IView parent,Context context,Node root) {
		super(parent, context,  root);
		TextView t=new TextView(context);
		
		v=t;
		super.initiate();
		t.setGravity(css.getGravity());
	}
	


}
