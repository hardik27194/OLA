package com.lohool.ola;


import android.os.AsyncTask;

/**
 * the main lua mobile properties
 * @author xingbao-
 *
 */

public class PortalProperties extends AbstractProperties {
	static PortalProperties instance;
     PortalProperties()
	{
    	 super();
//    	 appBase="apps/";
    	 appServer="";
//    		 platformApp="olaportal/";
    	 String fileBase="";
    	 appName="olaportal/";
    	 isPlatformApp=false;
 
    	 super.initiateLuaContext();
    	 loadAppsInfo();
    	 loadXML();
 		reset();
	}
	void reset()
	{
		this.currentApp=null;
		OLA.appBase=appBase+appName+"/";
		LuaContext.registInstance(this.getLuaContext());
	}
	public static PortalProperties getInstance()
	{
		if(instance==null)instance=new PortalProperties();
		return (PortalProperties)instance;
	}
	public static PortalProperties create()
	{
		instance=new PortalProperties();
		return (PortalProperties)instance;
	}
	public void startApp(String appName)
	{
		InitPropertiesTask task= new InitPropertiesTask();
        task.execute(appName);
	}
	private class InitPropertiesTask extends AsyncTask<String, Integer, String> {
		BodyView v=null;
		@Override
		protected String doInBackground(String... params) {
			String appName=params[0];
			System.out.println("start app:"+appName);
			AppProperties app=new AppProperties(appName);
			String packageName=Main.class.getPackage().getName();
			System.out.println(packageName);
			app.appPackage=packageName;
			currentApp=app;
			app.execGlobalScripts();
			return "";
		}
		@Override
		protected void onPostExecute(String result) {
			System.out.println("InitPropertiesTask.onPostExecute");
			String name=currentApp.getFirstViewName();
	        if(name!=null)
	        {
				v=new BodyView(Main.ctx,name);				
	        }
	        v.show();
		}
    }
}

//LuaState L=lua.getLuaState();

//final StringBuilder output = new StringBuilder();
//JavaFunction print = new JavaFunction(L) {
//	@Override
//	public int execute() throws LuaException {
//		for (int i = 2; i <= L.getTop(); i++) {
//			int type = L.type(i);
//			String stype = L.typeName(type);
//			String val = null;
//			if (stype.equals("userdata")) {
//				Object obj = L.toJavaObject(i);
//				if (obj != null)
//					val = obj.toString();
//			} else if (stype.equals("boolean")) {
//				val = L.toBoolean(i) ? "true" : "false";
//			} else {
//				val = L.toString(i);
//			}
//			if (val == null)
//				val = stype;						
//			output.append(val);
//			output.append("\t");
//		}
//		output.append("\n");					
//		return 0;
//	}
//};
//try
//{
//	print.register("print");
//} catch (LuaException e1)
//{
//	// TODO Auto-generated catch block
//	e1.printStackTrace();
//}


/*

JavaFunction assetLoader = new JavaFunction(L) {
	@Override
	public int execute() throws LuaException {
		String name = L.toString(-1);

		AssetManager am = Main.ctx.getAssets();
		try {
			//InputStream is = am.open(name + ".lua");
			File file=new File(sandboxRoot+"lua/"+name + ".lua");
			System.out.println("Load required file="+sandboxRoot+name + ".lua");
			InputStream is = new FileInputStream(file);
			byte[] bytes = readAll(is);
			L.LloadBuffer(bytes, name);
			return 1;
		} catch (Exception e) {
			ByteArrayOutputStream os = new ByteArrayOutputStream();
			e.printStackTrace(new PrintStream(os));
			L.pushString("Cannot load module "+name+":\n"+os.toString());
			return 1;
		}
	}
};

L.getGlobal("package");            // package
L.getField(-1, "loaders");         // package loaders
int nLoaders = L.objLen(-1);       // package loaders


try
{
	L.pushJavaFunction(assetLoader);
} catch (LuaException e)
{
	// TODO Auto-generated catch block
	e.printStackTrace();
}   // package loaders loader
L.rawSetI(-2, nLoaders + 1);       // package loaders
L.pop(1);                          // package
			
L.getField(-1, "path");            // package path
String customPath = sandboxRoot + "?.lua";
System.out.println("Main.ctx.getFilesDir()="+sandboxRoot);
L.pushString(";" + customPath);    // package path custom
L.concat(2);                       // package pathCustom
L.setField(-2, "path");            // package
L.pop(1);

*/