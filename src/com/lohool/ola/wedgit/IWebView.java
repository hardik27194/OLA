package com.lohool.ola.wedgit;

import org.w3c.dom.Node;

import com.lohool.ola.UIFactory;

import android.annotation.SuppressLint;
import android.content.Context;
import android.webkit.WebView;

@SuppressLint("NewApi")
public class IWebView extends Layout
{
	String layout="WebView";
	public IWebView(IView parent, Context context, Node root,UIFactory ui)
	{
		super(parent, context, root,ui);
		WebView t = new WebView(context);
		t.getSettings().setSupportZoom(true);
		t.getSettings().setBuiltInZoomControls(true);
		t.getSettings().setDisplayZoomControls(false);

		v=t;
		super.initiate();
		//t..setGravity(css.getGravity());
		//parseChildren(this,root);
	}
	
	public void setText(String text)
	{
		this.setContent(text);
	}
	public void setContent(String content)
	{
		WebView t=(WebView)v;
		t.loadData(content, "text/html", "UTF-8");
	}

}
