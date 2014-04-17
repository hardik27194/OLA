package com.lohool.ola.wedgit;

import org.w3c.dom.Node;

import android.view.View;

public interface IView {
	public View getView();
	
	public CSS getCss();
	public Node getRoot();
	public IView getParent();
	public void setParent(IView view);

}
