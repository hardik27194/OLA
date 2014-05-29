package com.lohool.ola;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;

import org.apache.http.util.EncodingUtils;
import org.json.JSONArray;
import org.json.JSONObject;


import android.os.AsyncTask;
import android.os.Bundle;
import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.ActivityManager;
import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.res.Resources;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.GestureDetector;
import android.view.KeyEvent;
import android.view.Menu;
import android.view.MotionEvent;
import android.view.Window;
import android.view.WindowManager;
import android.widget.FrameLayout;



@SuppressLint("NewApi")
public class Main extends Activity {

	private FrameLayout mLayout;
//	private LuaState lua;
	public static Context ctx;
	public static Main activity;
	public static final int baseDpi=160;
	public int dpi=160;
	public static float scale=1;

	
	long installedTime;
	long lastUsedTime;
	int state;
//	UIFactory ui= new UIFactory(ctx,lua);
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
       
        
        Log.v("MainActivity", "onCreate...");
        // hide titlebar of application  

        // must be before setting the layout  
        requestWindowFeature(Window.FEATURE_NO_TITLE);  
        // hide statusbar of Android   could also be done later  
       // getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,   WindowManager.LayoutParams.FLAG_FULLSCREEN);  

        setContentView(R.layout.activity_main);
        
        System.out.println("getExternalFilesDir="+this.getExternalFilesDir(null));
        ctx=this.getApplicationContext();
        ctx.setTheme(R.style.AppTheme);
        activity=this;
        
        
        DisplayMetrics dm=this.getApplicationContext().getResources().getDisplayMetrics(); 
        this.dpi=dm.densityDpi;
        this.scale=1.0f*dpi/baseDpi;
        Log.d("dpi", "dpi="+dpi);
        Log.d("dpi", "scale="+scale);
        
//        printScreenInfo();
  
	        
        DisplayLoadingTask task= new DisplayLoadingTask();
        task.execute("");
	 
    }
	private class DisplayLoadingTask extends AsyncTask<String, Integer, String> {
		BodyView v=null;
		String appServer;
		String appBase;
		@Override
		protected String doInBackground(String... params) {
			System.out.println("InitPortalViewTask.doInBackground");
			OLAProperties app= new OLAProperties();
			app.appName="olaos/";
			String packageName=Main.class.getPackage().getName();
			app.appPackage=packageName;
			loadDefaultProperties();
			appServer=app.appServer;
			appBase=app.appBase;
			System.out.println("Main.state="+state);
	  	 	if(state==0 || app.mode.equalsIgnoreCase("development")) 	
	  	 	{
	  	 		try
				{
//					copyAssetsApps(app.appServer,app.appBase);
					copyAssetDir("olaos", appBase);
					copyAssetDir("olaportal", appBase);
					copyAssetFile("apps.json",appBase);
					copyAssetFile("OLA.lua",appBase);

				} catch (IOException e)
				{
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
	  	 	}
	  	 
			app.loadAppsInfo();
			app.reset();
			
			return app.getFirstViewName();
		}
		@Override
		protected void onPostExecute(String viewName) {
			BodyView v=null;
			v=new BodyView(ctx,viewName);				
			setContentView(v.bodyView.getView());
			
			ExecuteOsLusTask osTask= new ExecuteOsLusTask(appServer,appBase);
	        osTask.execute(v);	
		}
    }
	private class ExecuteOsLusTask extends AsyncTask<BodyView, Integer, String> {
		BodyView v=null;
		String appServer;
		String appBase;
		public ExecuteOsLusTask(String appServer,String appBase)
		{
			this.appServer=appServer;
			this.appBase=appBase;
		}
		@Override
		protected String doInBackground(BodyView... params) {

			v=params[0];
			if(state==0) 	
	  	 	{
					copyAssetsApps(appServer,appBase);
	  	 	}
			v.executeLua();
			return null;
		}
		@Override
		protected void onPostExecute(String app) {
			
			state++;
	  	 	//update the properties
	  	 	writeProperties();	
	
//			InitPropertiesTask task= new InitPropertiesTask();
//	        task.execute("");	
		}
    }
	


    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
//        getMenuInflater().inflate(R.menu.main, menu);
        return true;
    }


	public void copyAssetsApps(String appServer,String appBase)
	{
		try
		{
			Log.d("Files:", "start..........................");
			//String appss=UIFactory.loadAssert("OLA.lua");
			//System.out.println("ola.apps="+appss);
//			LuaContext lua =LuaContext.createInstance();
//			String olaLua=loadAsset("OLA.lua");
//			lua.doString(olaLua);
//			//here is only for online test 
//			String appServer=lua.getGlobalString("OLA.app_server");
//			String appBase=lua.getGlobalString("OLA.base");
//			String sandboxRoot="/data/data/"+Main.class.getPackage().getName()+"/";
//			appBase=sandboxRoot+appBase;
			System.out.println("appServer="+appServer);

			if(appServer!=null && appServer!="" && appServer.startsWith("http://") )
			{
				
			}
			else
			{
				String appstr=loadAsset("apps.json");
				JSONObject appObj = new JSONObject(appstr);
				JSONArray apps=appObj.getJSONArray("user_apps");
				for(int i=0;i<apps.length();i++)
				{
					String app=apps.getJSONObject(i).getString("app");
					copyAssetDir(app,appBase);
				}
				apps=appObj.getJSONArray("sys");
				for(int i=0;i<apps.length();i++)
				{
					String app=apps.getJSONObject(i).getString("app");
					if(!app.equalsIgnoreCase("olaos"))copyAssetDir(app,appBase);
				}
				//File file=new File("/data/data/"+Main.class.getPackage().getName()+"/"+appBase+"/lua");
				//if(!file.exists())file.mkdirs();
				//copyAssetDir("lua",appBase);
//				copyAssetFile("apps.json",appBase);
//				copyAssetFile("update.lua",appBase);
			}
			
//			lua.close();
		} catch (Exception e)
		{
			e.printStackTrace();
		}
		
	}
	
	public  void copyAssetDir(String fileName,String appBase) throws IOException {
		File file=new File(appBase+"/"+fileName);
		Log.d("coping dir:", appBase+"/"+fileName);
		if(!file.exists())file.mkdirs();
		String names[]=getAssets().list(fileName);
		
		for(String name:names)
		{
			if(isDirectory(name))
			{
				copyAssetDir(fileName+"/"+name,appBase);
			}
			else
			{
				copyAssetFile(fileName+"/"+name,appBase);
			}
		}

	}
	public  void copyAssetFile(String fileName,String appBase) throws IOException {
		InputStream is = getAssets().open(fileName);
//		Log.d("Files: coping...", appBase+fileName);

		FileOutputStream fos = new FileOutputStream(appBase+fileName);
		byte[] buffer = new byte[1024];
		int count = 0; // 开始复制db文件
		int process = 0;
		while (-1 != (count = is.read(buffer))) 
		//while ((count = is.read(buffer)) > 0) 
		{
			fos.write(buffer, 0, count);
			process += count;
		}
		fos.close();
		is.close();
	}
	private boolean isDirectory(String filename) {  
	
		return !(filename.startsWith(".") || (filename.lastIndexOf(".") != -1));  
		
	}
	public static String loadAsset(String resPath) {
		StringBuffer buf = new StringBuffer();
			// 获得InputStream对象
//			InputStream is = getResources().getAssets().open("IELTSCore3000.db");
			
		InputStream isread = null;
			
			byte[] luaByte = new byte[0];
			try {
				 isread =Main.ctx. getAssets().open(resPath);
				int len = 0;
				while ((len = isread.available()) > 0) {
					luaByte = new byte[len];
					isread.read(luaByte);
					buf.append(EncodingUtils.getString(luaByte, "UTF-8"));
				}
			} catch (Exception e1) {
				e1.printStackTrace();
			} finally {
				if (isread != null) {
					try {
						isread.close();
					} catch (IOException e) {
					}
				}
			}
			return buf.toString();
	}
	private void loadDefaultProperties() {
		try{
		String packageName=this.getClass().getPackage().getName();
		File file=new File("/data/data/"+packageName+"/files/.properties");
		if(file.exists())
		{
			System.out.println(".properties file is existed");
			loadProperties();
		}
//		else
//		{
//			System.out.println(".properties file is not existed");
//			writeProperties();
//		}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	private void loadProperties()
	{
		String packageName=this.getClass().getPackage().getName();
		File file=new File("/data/data/"+packageName+"/files/.properties");
		try{
		FileInputStream fis = new FileInputStream(file);
		DataInputStream in=new DataInputStream(fis);
		byte[] luaByte = new byte[1];
		try {
			state=in.readInt();
			installedTime=in.readLong();
			lastUsedTime=in.readLong();
		} catch (Exception e1) {
			e1.printStackTrace();
		} finally {
		}
		fis.close();
		in.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	private void writeProperties()
	{
		String packageName=this.getClass().getPackage().getName();
		File file=new File("/data/data/"+packageName+"/files/.properties");
		if(!file.exists())file.getParentFile().mkdirs();
	
		try{
		FileOutputStream fos = new FileOutputStream(file);
		DataOutputStream out=new DataOutputStream(fos);
		byte[] luaByte = new byte[1];
		try {
			out.writeInt(state);	//new installed
			out.writeLong(installedTime);	//安装时间
			out.writeLong(System.currentTimeMillis());	//最后访问时间
		} catch (Exception e1) {
			e1.printStackTrace();
		} finally {
		}
		fos.close();
		out.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	

    
/*
    public void test(View v) { 
    	System.out.println("test() is executed");

        L.LdoString(temp);

        L.getGlobal("text");
         text = L.toString(-1);

        // L.close();

        System.out.println("Lua String:"+text);
        
        
        //����lua�еĺ���
        L.getField(LuaState.LUA_GLOBALSINDEX, "cutStr");
        L.pushString("in the pad!");   //�������
        L.call(1,1);                    //���ú���ָ������ͷ���ֵ����
        
        L.setField(LuaState.LUA_GLOBALSINDEX, "a"); //������ֵ���浽����a��
        LuaObject obj = L.getLuaObject("a");        //��ȡ����a
        System.out.println("Lua String:"+obj.toString());

        
        
    }
    public void acceptLuaFun()
    {
    	lua.LdoString("print ('From Lua function...')");
    }



         public void addButton(View v)
         {
        	 ImageButton ib=new ImageButton(this);
        	 Layout d=new Layout(this,lua);
        	 d.setHeight(200);
        	 d.setWidth(200);
        	 d.setBackgroundColor(-65535);
        	 //d.setBackgroundImageURL("http://10.0.2.2:8080/CRM/themes/default/images/header_bg.png");
        	 
        	 
//        	 IButton btn2= new IButton(this,lua);
//        	 btn2.setText("Buttontest");
//        	 System.out.println("red="+Color.rgb(0xFF, 0x00, 0x00));
//        	
//        	 this.mLayout.addView(btn2);
        	 
        	 
 			//lua.LdoString("btn2={}");
        	 
        	 //String temp = loadAssetsString("http://16.187.151.18:8080/CRM/testLua.lua");
        	 String temp = UIFactory.loadAssetsString("http://10.0.2.2:8080/test/testLua.lua");


             lua.LdoString(temp);

             //create a class from Lua using java interface
//             try {
//            	 lua.LdoString("return logic");
//            	 LuaObject logic = lua.getLuaObject("logic");   
//            	 System.out.println("logic="+logic);
//            	 IWedgit btn2 = (IWedgit) (logic.createProxy("com.example.anluatest.IWedgit"));
//            	 btn2.onClick();
//            	 lua.pop(1);
//            	 //this.mLayout.addView(btn2.getInstance(this, lua));
//            	 
//    				lua.pushObjectValue(btn2);
//    				lua.setGlobal("btn2");
//    			} catch (Exception e) {
//    				// TODO Auto-generated catch block
//    				e.printStackTrace();
//    			}
             
        	 lua.getField(LuaState.LUA_GLOBALSINDEX, "addButton");  
        	 lua.pushJavaObject(getApplicationContext());// ��һ������ context   
        	 lua.pushJavaObject(mLayout);//�ڶ������� Layout   
        	 lua.call(2, 0);// 2������0������ֵ   
        	 

        	 
        	 
//        	 lua.getGlobal("btn1.onclick");//����䲻��ִ��
//        	 String text = lua.toString(-1);
//        	 System.out.println(text);
        	 
//        	 LuaState lua1 = LuaStateFactory.newLuaState(); 
//
//             lua1.openLibs(); 
        	 //lua.LdoString("btn1=class{}");
//        	 lua.getField(LuaState.LUA_GLOBALSINDEX, "btn2.Buttontest");//����䲻��ִ��
//        	 lua.call(0,0);
        	 

         }
         */

	public void printScreenInfo()
	{
        String str = ""; 
        DisplayMetrics dm = new DisplayMetrics(); 
        getWindowManager().getDefaultDisplay().getMetrics(dm); 
        dm = this.getApplicationContext().getResources().getDisplayMetrics(); 
        int screenWidth = dm.widthPixels; 
        int screenHeight = dm.heightPixels; 
        float density = dm.density; 
        float xdpi = dm.xdpi; 
        float ydpi = dm.ydpi; 
        str += "屏幕分辨率为:" + dm.widthPixels + " * " + dm.heightPixels + "\n"; 
        str += "绝对宽度:" + String.valueOf(screenWidth) + "pixels\n"; 
        str += "绝对高度:" + String.valueOf(screenHeight) 
                + "pixels\n"; 
        str += "逻辑密度:" + String.valueOf(density) 
                + "\n"; 
        str += "X 维 :" + String.valueOf(xdpi) + "像素每英尺\n"; 
        str += "Y 维 :" + String.valueOf(ydpi) + "像素每英尺\n"; 
        str += "densityDpi:" + String.valueOf(dm.densityDpi) ; 
        Log.i("screen info", str); 
	}
    protected void dialog() {   
        AlertDialog.Builder builder = new AlertDialog.Builder(this);   
        builder.setMessage("确定要退出吗?");   
        builder.setTitle("提示");   
        builder.setPositiveButton("确认",   
                new android.content.DialogInterface.OnClickListener() {   
                    @Override  
                    public void onClick(DialogInterface dialog, int which) {   
                        dialog.dismiss();   
                        Main.this.finish();  
                        ActivityManager manager = (ActivityManager) getSystemService(ACTIVITY_SERVICE); 
                        manager.killBackgroundProcesses(getPackageName());
                        System.exit(1);
                    }
  
                });   
        builder.setNegativeButton("取消",   
                new android.content.DialogInterface.OnClickListener() {   
                    @Override  
                    public void onClick(DialogInterface dialog, int which) {   
                        dialog.dismiss();   
                    }   
                });   
        builder.create().show();   
    }   
    @Override  
    public boolean onKeyDown(int keyCode, KeyEvent event) {   
        if (keyCode == KeyEvent.KEYCODE_BACK && event.getRepeatCount() == 0) {   
            dialog();   
            return false;   
        }   
        return false;   
    } 

}
