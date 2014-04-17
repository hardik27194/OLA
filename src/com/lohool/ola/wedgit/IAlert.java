package com.lohool.ola.wedgit;

import com.lohool.ola.LuaContext;
import com.lohool.ola.Main;

import android.app.AlertDialog;
import android.view.Window;

public class IAlert
{
	AlertDialog dlg;
	IView contentView;
	IAlert()
	{
		dlg = new AlertDialog.Builder(Main.ctx).create();
		
		//dlg.s.setNegativeButton("取消" ,  null );
	}
	public static IAlert create()
	{
		IAlert instance = new IAlert();
		return instance;
	}

	public void setContentView(IView view)
	{
		
		Window window = dlg.getWindow();
		 window.setContentView(view.getView());
		//dlg.setView(view.getView());
		 
	}
	
	public void setContentView(String objId)
	{
		System.out.println("dialog view id="+objId);
		try{
		Object obj=LuaContext.getInstance().getObject(objId);
		setContentView((IView)obj);
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
	}
	
	public void show()
	{
		System.out.println("dialog view show...");
//		new  AlertDialog.Builder(Main.ctx)  
//		.setTitle("请输入" )   
//		//.setIcon(android.R.drawable.ic_dialog_info)   
//		.setView(new  EditText(Main.ctx))  
//		.setPositiveButton("确定" , null)   
//		.setNegativeButton("取消" ,  null )   
//		.show();
		dlg.show();
	}
	public void hide()
	{
		dlg.hide();
	}
	public void dismisse()
	{
		dlg.dismiss();
	}
	
}
