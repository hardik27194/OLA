package com.lohool.ola.wedgit;


import org.w3c.dom.Node;
import android.content.Context;

import android.widget.ProgressBar;

/**
 * Usage 
 * @see UIMessage
 * @author xingbao-
 *
 */
public class IProgressBar extends IWedgit
{
	ProgressBar progressBar;
	public IProgressBar(IView parent,Context context,Node root) {
		super(parent, context, root);
		progressBar = new ProgressBar(context);
		progressBar.setMax(100);
		progressBar.setMinimumHeight(20);
		progressBar.setProgress(5);
		BeanUtils.setFieldValue(progressBar, "mOnlyIndeterminate", new Boolean(false));
		progressBar.setIndeterminate(false);
		v=progressBar;
		super.initiate();
		//progressBar.setGravity(css.getGravity());
		parseMyAttribute();
	}
	public void parseMyAttribute()
	{
		//ProgressBar progressBar=(ProgressBar)v;
//		System.out.println("indeterminate="+css.getStyleValue("indeterminate"));
//		System.out.println("indeterminateOnly="+css.getStyleValue("indeterminateOnly"));
//		System.out.println("style="+css.getStyleValue("style"));
//		System.out.println("value="+css.getStyleValue("value"));
		String attr;
		if ((attr = css.getStyleValue("indeterminate")) != null)
		{
			setIndeterminate(Boolean.parseBoolean(attr));
		}
		if ((attr = css.getStyleValue("indeterminateOnly")) != null)
		{
			setIndeterminate(Boolean.parseBoolean(attr));
		}
		if ((attr = css.getStyleValue("style")) != null)
		{
			setStyle(attr);
		}
		if ((attr = css.getStyleValue("value")) != null)
		{
			setValue(Integer.parseInt(attr));
		}
	}
	public void setIndeterminate(boolean indeterminate)
	{
		progressBar.setIndeterminate(indeterminate);
	}
	
	public void setIndeterminateOnly(boolean indeterminateOnly)
	{
		BeanUtils.setFieldValue(progressBar, "mOnlyIndeterminate", new Boolean(indeterminateOnly));
	}
	
	public void setStyle(String style)
	{
		if(style.equalsIgnoreCase("horizontal"))
		{
			 progressBar.setProgressDrawable(context.getResources().getDrawable(android.R.drawable.progress_horizontal));
		        progressBar.setIndeterminateDrawable(context.getResources().getDrawable(android.R.drawable.progress_indeterminate_horizontal));
		}
	}
	public void setValue(int value)
	{
		progressBar.setProgress(value);

	}


}
