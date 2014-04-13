package com.example.anluatest;


import org.keplerproject.luajava.JavaFunction;
import org.keplerproject.luajava.LuaException;
import org.keplerproject.luajava.LuaObject;
import org.keplerproject.luajava.LuaState;

import com.example.anluatest.wedgit.Layout;

import android.os.AsyncTask;
import android.util.Log;

public class BodyView {

	Main ctx;
	Layout bodyView;
	UIFactory ui;
	String viewUrl;
	String parameters;

	String LuaCode;

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
		if (callback != null && callback.trim().equals(""))
//			lua.LdoString(callback);
			LuaContext.getInstance().doString(callback);
	}

	public BodyView(Main ctx,  String viewUrl) {
		this.ctx = ctx;
		this.viewUrl = viewUrl;
		create();

	}

	private void create() {

		Log.v("MainActivity", "onCreate...");

		ui = new UIFactory(this, ctx);
		LuaContext.getInstance().regist(ui, "ui");

		loadXMLActivity();
		loadLuaCode();

	}

	public void registReloadFun() {
		Layout layout = null;
		LuaState lua=LuaContext.getInstance().getLuaState();
		try {
			lua.newTable();
			lua.pushValue(-1);
			lua.setGlobal("sys");
			lua.pushString("reload");
			lua.pushJavaFunction(new JavaFunction(lua) {
				@Override
				public int execute() throws LuaException {
					loadXMLActivity();
					loadLuaCode();
					// ctx.setContentView(bodyView.getView());
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

	void loadXMLActivity() {
		System.out.println("view xml file path="+viewUrl);
		bodyView = ui.createLayoutByXMLFile(viewUrl);
		// ctx.setContentView(bodyView.getView());
	}

	void loadLuaCode() {

		this.LuaCode = ui.loadLayoutLuaCode(viewUrl);
		// ctx.setContentView(bodyView.getView());
	}

	/**
	 * executed by other code while the View was shown to the Activity
	 */
	public void executeLua() {
		registReloadFun();
		// System.out.println("lua file="+temp);
		LuaContext.getInstance().doString(LuaCode);
		// System.out.println(lua.getLuaObject("btn1"));
		// lua.LdoString("Log:d('test btn','btn2')");
		// lua.LdoString("btn3=btn1:getText()");
		// lua.LdoString("Log:d('test btn','btn2 0')");
		// lua.LdoString("Log:d('test btn','btn2='..Log)");
		// lua.LdoString("Log:d('test btn','btn2='..btn3)");
		// lua.LdoString("btn1:setBackgroundColor(-65535)");
		//
		try {

			// if database class is defined by Lua, create a database connection
			// and set it to lua global
			LuaState lua=LuaContext.getInstance().getLuaState();
			LuaObject luaObj = lua.getLuaObject("database");
			if (luaObj != null && !luaObj.equals("nil")) {
				lua.pushObjectValue(new Database(ctx));
				lua.setGlobal("connection");
				lua.pop(1);
			}

		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		LuaContext.getInstance().doString("initiate()");
	}

	// public Layout getLayout()
	// {
	// return this.bodyView;
	// }
	public void show() {
		// ctx.setContentView(bodyView.getView());
		// this.executeLua();
		LuaExecuteTask task = new LuaExecuteTask();
		task.execute("");
	}

	private class LuaExecuteTask extends AsyncTask<String, Integer, String> {
		String t;

		@Override
		protected String doInBackground(String... params) {
			t = params[0];

			executeLua();
			return "";
		}

		protected void onPostExecute(String result) {

			ctx.setContentView(bodyView.getView());
		}
	}

}
