package com.lohool.ola.wedgit;

import org.w3c.dom.Node;
import android.annotation.SuppressLint;
import android.content.Context;
import android.webkit.WebView;
import android.widget.EditText;

@SuppressLint("NewApi")
public class IWebView extends Layout
{
	String layout="WebView";
	public IWebView(IView parent, Context context, Node root)
	{
		super(parent, context, root);
		WebView t = new WebView(context);
		t.getSettings().setSupportZoom(true);
		t.getSettings().setBuiltInZoomControls(true);
		t.getSettings().setDisplayZoomControls(false);

		v=t;
		super.initiate();
		//t..setGravity(css.getGravity());
		parseChildren(this,root);
	}

}
