package com.lohool.ola.wedgit;


import org.w3c.dom.*;

import com.lohool.ola.UIFactory;

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
	public IFrameLayout(IView parent,Context context,Node root,UIFactory ui) {
		super(parent, context,  root,ui);
		FrameLayout t=new FrameLayout(context);
		v=t;
		super.initiate();
		//t.setGravity(css.getGravity());
		parseChildren(this,root);
		
	}

}
