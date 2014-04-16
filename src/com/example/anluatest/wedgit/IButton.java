package com.example.anluatest.wedgit;


import org.w3c.dom.Element;
import org.w3c.dom.Node;

import android.annotation.SuppressLint;
import android.content.Context;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.GradientDrawable;
import android.view.Gravity;
import android.widget.Button;
import android.widget.TextView;


@SuppressLint("NewApi")
public class IButton extends IWedgit{
	
	int preBgColor;
	

	public IButton(IView parent,Context context,Node root) {
		super(parent, context, root);
		Button t=new Button(context);
		v=t;
		super.initiate();
		t.setGravity(css.getGravity());

	}


	protected void clicked() {
		
		super.clicked();
	}

	@Override
	protected void pressed() {
		System.out.println("button pressed");
		//this.setBackgroundColor(preBgColor);
		Button btn=(Button)v;
		//Rect bounds=btn.getBackground().getBounds();
		Drawable drawable1=btn.getBackground();
		if(drawable1 instanceof ColorDrawable || drawable1 instanceof GradientDrawable)
		{
			preBgColor=this.getBackgroundColor();
			GradientDrawable drawable = new GradientDrawable();
		    drawable.setShape(GradientDrawable.RECTANGLE);
		    drawable.setStroke(1, Color.MAGENTA);
		    drawable.setFilterBitmap(true);
		    //drawable.setBounds(bounds.left-1, bounds.top-1, bounds.right+1, bounds.bottom+1);
		    //drawable.set
		    //drawable.setAlpha(0);
		    drawable.setColor(preBgColor);
		    drawable.setColorFilter(Color.argb(168, 255, 75, 75), android.graphics.PorterDuff.Mode.DST_OUT);
		    btn.setBackgroundDrawable(drawable);
		}
		else
		{			
			drawable1.setColorFilter(Color.argb(168, 255, 75, 75), android.graphics.PorterDuff.Mode.DST_OUT);
			btn.setBackgroundDrawable(drawable1);
		}

		super.pressed();
	}

	@Override
	protected void released() {
		System.out.println("button released"); 
		Button btn=(Button)v;	
		Drawable drawable1=btn.getBackground();
		drawable1.clearColorFilter();
		if(drawable1 instanceof ColorDrawable || drawable1 instanceof GradientDrawable)
		{
			preBgColor=this.getBackgroundColor();
			GradientDrawable drawable = new GradientDrawable();
		    drawable.setColor(preBgColor);
		    drawable1=drawable;
		    
		}
		btn.setBackgroundDrawable(drawable1);
		super.released();
	}

 

}
