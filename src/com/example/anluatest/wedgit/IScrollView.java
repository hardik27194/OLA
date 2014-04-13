package com.example.anluatest.wedgit;

import org.keplerproject.luajava.LuaState;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import android.content.Context;
import android.widget.ScrollView;
import android.widget.TableLayout;

public class IScrollView extends IContainer{

	public IScrollView(IView parent, Context context, Node root) {
		super(parent, context, root);
		v = new ScrollView(context);
		super.initiate();
		parseChildren(this,root);
	}

	

}
