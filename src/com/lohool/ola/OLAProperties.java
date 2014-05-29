package com.lohool.ola;




import android.os.AsyncTask;

/**
 * the main lua mobile properties
 * @author xingbao-
 *
 */
public class OLAProperties extends AbstractProperties{
	
	OLAProperties()
	{
    	 
    	 super();
//    	 appBase="apps/";
    	 appServer="";
//    		 platformApp="olaos/";
    		String fileBase="";

    	 appName="olaos/";
    	 isPlatformApp=true;
    	 
    	 super.initiateLuaContext();

 		
	}
	void reset()
	{
		this.currentApp=null;
		loadXML();
		LuaContext.registInstance(this.getLuaContext());
	}
	
//	public void loadAppInfo()
//	{
//
//		System.out.println(appBase+"/apps.json");
//		String appsJson=appBase+"/apps.json";
//		//if(appServer.startsWith("http://"))appsJson=appServer+"/apps.json";
//		String appstr=UIFactory.loadResourceTextDirectly(appsJson);
//		System.out.println(appstr);
//		try
//		{
//			JSONObject appObj = new JSONObject(appstr);
//			JSONArray apps=appObj.getJSONArray("user_apps");
//			lua.doString("require 'JSON4Lua'");
//			System.out.println("apps.json="+apps.toString());
//			lua.doString("OLA.apps=json.decode('"+apps.toString()+"')");
//		} catch (JSONException e)
//		{
//			e.printStackTrace();
//		}
//	}
//	
//	public void start()
//	{
//		BodyView v=null;
//    	String name=getFirstViewName();
//        if(name!=null)
//        {
//			v=new BodyView(Main.ctx,name);				
//        }Main.activity.setContentView(v.bodyView.getView());
//        
//		InitPropertiesTask task= new InitPropertiesTask();
//        task.execute(v);
//	}
//
//	private class InitPropertiesTask extends AsyncTask<BodyView, Integer, String> {
//		BodyView v=null;
//		@Override
//		protected String doInBackground(BodyView... params) {
//
//			v=params[0];
//	        v.executeLua();
//			return "";
//		}
//		@Override
//		protected void onPostExecute(String result) {
//
//		}
//    }
	public void startApp(String appName)
	{
		InitOLAPortalTask task= new InitOLAPortalTask();
        task.execute("");
	}
    private class InitOLAPortalTask extends AsyncTask<String, Integer, String> {
    	PortalProperties properties;
		@Override
		protected String doInBackground(String... params) {
	        properties=PortalProperties.getInstance();
	        //properties.currentApp=null;
	        properties.reset();

	        String packageName=Main.class.getPackage().getName();
			System.out.println(packageName);
			properties.appPackage=packageName;
			
			properties.execGlobalScripts();

			return "";
		}
		@Override
		protected void onPostExecute(String result) {
			System.out.println("InitPropertiesTask.onPostExecute");
			BodyView v=null;
	    	String name=properties.getFirstViewName();
	        if(name!=null)
	        {
				v=new BodyView(Main.ctx,name);				
				UIFactory.viewCache.clear();//
				UIFactory.viewCache.put(name, v);
//				ctx.setContentView(v.getLayout().getView());
	        }
	        v.show();
					
		}
    }

}
