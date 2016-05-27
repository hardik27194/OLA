package com.lohool.ola.wedgit;


import org.w3c.dom.Node;

import android.annotation.SuppressLint;
import android.content.Context;
import android.graphics.Typeface;
import android.view.Gravity;
import android.widget.Button;
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
	
//	public void setText(String text)
//	{
//		TextView btn=(TextView)super.v;
//			text=text.replaceAll("\\\\n", "\n");
//			text=text.replaceAll("\\\\\n", "\\\\n");
//			btn.setText(text);
//			btn.requestLayout();
//
//	}

}
