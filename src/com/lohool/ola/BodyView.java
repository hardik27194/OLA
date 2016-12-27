package com.lohool.ola;

import org.keplerproject.luajava.JavaFunction;
import org.keplerproject.luajava.LuaException;
import org.keplerproject.luajava.LuaObject;
import org.keplerproject.luajava.LuaState;

import com.lohool.ola.wedgit.Layout;

import android.content.Context;
import android.os.AsyncTask;
import android.util.Log;
import android.view.View;

public class BodyView {

	Context ctx;
	Layout layout;
	UIFactory ui;
	String viewUrl;
	String parameters;

	String LuaCode;
	String callback;

	public BodyView(Context ctx, String viewUrl) {
		this.ctx = ctx;
		this.viewUrl = viewUrl;
		create();
	}
	public String getParameters() {
		return parameters;
	}

	public void setParameters(String parameters) {
		// TODO
		// resolve the params and it should be set to lua before the lua code of
		// current view is executed
		this.parameters = parameters;
	}

	public void execCallBack(String callback) {
		System.out.println("callback=" + callback);
		if (callback != null && !callback.trim().equals(""))
//			lua.LdoString(callback);
			LuaContext.getInstance().doString(callback);
	}
	public void setCallBack(String callback) {
		this.callback=callback;
	}



	private void create() {
		Log.v("MainActivity", "onCreate...");
		ui = new UIFactory(this, ctx);
		LuaContext.getInstance().regist(ui, "ui");

		loadXMLActivity();
		loadLuaCode();

	}

	public void registReloadFun() {
		LuaState lua=LuaContext.getInstance().getLuaState();
		try {
			lua.newTable();
			lua.pushValue(-1);
			lua.setGlobal("sys");
			lua.pushString("reload");
			lua.pushJavaFunction(new JavaFunction(lua) {
				@Override
				public int execute() throws LuaException {
//					bodyView.getView().setVisibility(View.GONE);
					System.gc();
					loadXMLActivity();
					loadLuaCode();
					show();
					return 0;
				}
			});
			lua.setTable(-3);
		} catch (LuaException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	String uiXML;
	void loadXMLActivity() {
		System.out.println("view xml file path="+viewUrl);
//		if(uiXML==null)uiXML=UIFactory.loadAssetsString(viewUrl);
//		bodyView=ui.createLayoutByXMLString(uiXML);
		layout = ui.createLayoutByXMLFile(viewUrl);
		
		// ctx.setContentView(bodyView.getView());
	}

	void loadLuaCode() {

//		if(this.LuaCode==null)
			this.LuaCode = ui.loadLayoutLuaCode(viewUrl);
		// ctx.setContentView(bodyView.getView());
	}



	// public Layout getLayout()
	// {
	// return this.bodyView;
	// }
	public void show() {
//		 ctx.setContentView(bodyView.getView());
		// this.executeLua();
//		Main.activity.setContentView(bodyView.getView());
		LuaExecuteTask task = new LuaExecuteTask();
		task.execute("");
	}

	private class LuaExecuteTask extends AsyncTask<String, Integer, String> {

		@Override
		protected String doInBackground(String... params) {
			executeLua();
			return "";
		}
		protected void onPostExecute(String result) {
			
//			bodyView.getView().setVisibility(View.GONE);
			System.out.println("BodyView show view:"+viewUrl);
			Main.activity.setContentView(layout.getView());
		}
	}
	/**
	 * executed by other code while the View was shown to the Activity
	 */
	public void executeLua() {
		registReloadFun();
		//System.out.println(LuaCode);
		LuaContext.getInstance().doString(LuaCode);
		/* removed
		try {

			// if database class is defined by Lua, create a database connection
			// and set it to lua global
			LuaState lua=LuaContext.getInstance().getLuaState();
			LuaObject luaObj = lua.getLuaObject("Database");
			if (luaObj != null && !luaObj.equals("nil")) {
				lua.pushObjectValue(new Database());
				lua.setGlobal("connection");
				lua.pop(1);
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		*/
//		LuaContext.getInstance().doString("coroutine.resume(coroutine.create(function()ptinf('an co','aa') end))");
//		LuaContext.getInstance().doFile("assets/test.lua");
		
		LuaContext.getInstance().doString("initiate()");
		if(this.callback!=null)this.execCallBack(this.callback);
	}
}
