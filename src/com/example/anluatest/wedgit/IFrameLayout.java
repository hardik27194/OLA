package com.example.anluatest.wedgit;


import org.w3c.dom.*;

import android.annotation.SuppressLint;
import android.content.Context;
import android.view.Gravity;
import android.widget.FrameLayout;



//Layout
@SuppressLint("NewApi")
public class IFrameLayout extends Layout
{


	String layout="FrameLayout";
	

	
//	public IFrameLayout(Context context) {
//		//super(context);
//		super(null,context,null);
//		
//	}
//	
	public IFrameLayout(IView parent,Context context,Node root) {
		super(parent, context,  root);
		FrameLayout t=new FrameLayout(context);
		v=t;
		super.initiate();
		
		parseChildren(this,root);
		
	}

}
