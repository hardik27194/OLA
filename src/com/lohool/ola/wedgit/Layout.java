package com.lohool.ola.wedgit;

import org.w3c.dom.*;

import com.lohool.ola.UIFactory;

import android.annotation.SuppressLint;
import android.content.Context;


//Layout
@SuppressLint("NewApi")
public abstract class Layout extends IContainer
{
	String layout="FrameLayout";

	protected Layout(Context context) {
		super(null,context,null,null);
	}
	
	protected Layout(IView parent,Context context,Node root,UIFactory ui) {
		super(parent, context,  root,ui);
	}


}
