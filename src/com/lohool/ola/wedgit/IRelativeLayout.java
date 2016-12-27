package com.lohool.ola.wedgit;




import org.w3c.dom.*;

import com.lohool.ola.UIFactory;

import android.annotation.SuppressLint;
import android.content.Context;
import android.view.Gravity;
import android.widget.RelativeLayout;


//Layout
@SuppressLint("NewApi")
public class IRelativeLayout extends Layout
{

	String layout="RelativeLayout";
	

	
	
	public IRelativeLayout(Context context) {
		//super(context);
		super(null,context,null,null);
		RelativeLayout t=new RelativeLayout(context);
		v=t;
		super.initiate();
		t.setGravity(css.getGravity());
		parseChildren(this,root);
		
	}
	
	public IRelativeLayout(IView parent,Context context,Node root,UIFactory ui) {
		super(parent, context,  root,ui);
		
		RelativeLayout t=new RelativeLayout(context);
		v=t;
		
		super.initiate();
		t.setGravity(css.getGravity());
		parseChildren(this,root);
		
		
	}
	
}
