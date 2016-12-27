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
import org.keplerproject.luajava.LuaObject;
import org.keplerproject.luajava.LuaState;

import com.baidu.mapapi.SDKInitializer;
import com.lohool.ola.wedgit.UIMessage;

import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.ActivityManager;
import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.KeyEvent;
import android.view.Menu;
import android.view.Window;
import android.widget.Toast;

/**
 * 
 * @author xingbao-
 *
 */
@SuppressLint("NewApi")
public class Main extends Activity 
{
	public static Context ctx;
	public static Main activity;
	public static final int baseDpi=160;
	public int dpi=160;
	public static float scale=1;

	
	long installedTime;
	long lastUsedTime;
	int state;
	boolean isDevelopementMode=false;
	
	String subActivityCallback;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
       
        // must be before setting the layout  
        requestWindowFeature(Window.FEATURE_NO_TITLE);  
        // hide statusbar of Android   could also be done later  
       // getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,   WindowManager.LayoutParams.FLAG_FULLSCREEN);  

        SDKInitializer.initialize(getApplicationContext()); 
        
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

        
        CopyPlatformFileTask task= new CopyPlatformFileTask();
        task.execute("");
        

	 
    }

	/**
	 * initaite the app, and copy the core dirs and files to the executable folder which is defined by 
	 * "OLA.base" in OLA.lua, then load the first view of the "olaos" app
	 * @author xingbao-
	 *
	 */
	private class CopyPlatformFileTask extends AsyncTask<String, Integer, String> {
		String appServer;
		String appBase;
		@Override
		protected String doInBackground(String... params) {
			OLAProperties app= new OLAProperties();
			app.appName="olaos/";
			String packageName=Main.class.getPackage().getName();
			app.appPackage=packageName;
			loadDefaultProperties();
			appServer=app.appServer;
			appBase=app.appBase;
			// if it is the first time to run the app, or it is in Developement mode, copy the files
			System.out.println("coping assert files to:"+app.appBase);
	  	 	if(state==0 || app.mode.equalsIgnoreCase("development")) 	
	  	 	{
	  	 		isDevelopementMode=true;
	  	 		try
				{
					copyAssetDir("olaos", appBase);
					copyAssetFile("apps.json",appBase);
					copyAssetFile("OLA.lua",appBase);
					copyAssetDir("lua",appBase);
					copyAssetDir("images",appBase);
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
			setContentView(v.layout.getView());
			
			CopyAppsFilesTask osTask= new CopyAppsFilesTask(appServer,appBase);
	        osTask.execute(v);	
		}
    }
	
	
	/**
	 * copy APP directories and files to the lua running folder
	 * @author xingbao-
	 *
	 */
	private class CopyAppsFilesTask extends AsyncTask<BodyView, Integer, String> {
		BodyView v=null;
		String appServer;
		String appBase;
		public CopyAppsFilesTask(String appServer,String appBase)
		{
			this.appServer=appServer;
			this.appBase=appBase;
		}
		@Override
		protected String doInBackground(BodyView... params) {

			v=params[0];
			if(state==0 || isDevelopementMode) 	
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
			System.out.println("appServer="+appServer);

			if(appServer!=null && !appServer.endsWith("") && appServer.startsWith("http://") )
			{
			
			}
			else
			{
				String appstr=loadAssetText("apps.json");
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
					//olaos has been copied as the base platform
					if(!app.equalsIgnoreCase("olaos"))copyAssetDir(app,appBase);
				}
			}
			
//			lua.close();
		} catch (Exception e)
		{
			e.printStackTrace();
		}
		
	}
	
	/**
	 * copy dir and its sub dirs to the destination
	 * @param fileName
	 * @param appBase
	 * @throws IOException
	 */
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
	
	/**
	 * copy files to the destination
	 * @param fileName
	 * @param appBase
	 * @throws IOException
	 */
	public  void copyAssetFile(String fileName,String appBase) throws IOException {
		InputStream is = getAssets().open(fileName);
		FileOutputStream fos = new FileOutputStream(appBase+fileName);
		byte[] buffer = new byte[1024];
		int count = 0; 
		int process = 0;
		while (-1 != (count = is.read(buffer))) 
		{
			fos.write(buffer, 0, count);
			process += count;
		}
		fos.close();
		is.close();
	}
	
	/**
	 * is a dir or not. if the name start with "." or has an "." in the name, process it as a dir/
	 * Note: a formal dir should not has the dot char ".", and a file's name should has a dot
	 * @param filename
	 * @return
	 */
	private boolean isDirectory(String filename) {  
	
		return !(filename.startsWith(".") || (filename.lastIndexOf(".") != -1));  
		
	}
	
	/**
	 * read a text file from the Assert
	 * @param resPath
	 * @return
	 */
	public static String loadAssetText(String resPath) {
		StringBuffer buf = new StringBuffer();			
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
	

	/**
	 * process the sub Activites' callback function
	 */
    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data)
    {
        super.onActivityResult(requestCode, resultCode, data);
       // if(requestCode == 1000 && resultCode == 1001)
        if(resultCode >0)
        {
            String luaCallback = data.getStringExtra("luaCallback");
            System.out.println("main.luaCallback="+luaCallback);
            UIMessage msg=new UIMessage();
			LuaContext lua=LuaContext.getInstance();
    		//lua.regist(new ICalendar(selected), "calendar");
    	    msg.updateMessage(luaCallback);
    	   // lua.remove("calendar");
        }
    }

    
    
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
        str += "Resolution:" + dm.widthPixels + " * " + dm.heightPixels + "\n"; 
        str += "Absolute Width:" + String.valueOf(screenWidth) + "pixels\n"; 
        str += "Absolute Hight:" + String.valueOf(screenHeight) 
                + "pixels\n"; 
        str += "Local density:" + String.valueOf(density) 
                + "\n"; 
        str += "X axis :" + String.valueOf(xdpi) + "px/in\n"; 
        str += "Y 维 :" + String.valueOf(ydpi) + "px/in\n"; 
        str += "densityDpi:" + String.valueOf(dm.densityDpi) ; 
        Log.i("screen info", str); 
	}
	
	/*
	 * exit app dialog
	 */
    protected void dialog() {   
        AlertDialog.Builder builder = new AlertDialog.Builder(this);   
        builder.setMessage("Exit?");   
        builder.setTitle("Hint");   
        builder.setPositiveButton("OK",   
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
        builder.setNegativeButton("Cancel",   
                new android.content.DialogInterface.OnClickListener() {   
                    @Override  
                    public void onClick(DialogInterface dialog, int which) {   
                        dialog.dismiss();   
                    }   
                });   
        builder.create().show();   
    }   
    
    
    private static final int MSG_EXIT = 1;
    private static final int MSG_EXIT_WAIT = 2;
    private static final long EXIT_DELAY_TIME = 2000;
    private Handler mHandle = new Handler() {
        public void handleMessage(Message msg) {
        	int b=back();
        	if(b==0)
        	{
            switch(msg.what) {
            
                case MSG_EXIT:
                    if(mHandle.hasMessages(MSG_EXIT_WAIT)) {
                    	System.exit(1);
                    } else {    
                        Toast.makeText(Main.ctx, "Exit if press again", Toast.LENGTH_SHORT).show();
                        mHandle.sendEmptyMessageDelayed(MSG_EXIT_WAIT, EXIT_DELAY_TIME);
                    }
                    break;
                case MSG_EXIT_WAIT:
                    break;
            }
        	}
        	else
        	{
        		//back to previous view
        		//current view
        		UIFactory.viewStack.pop();
//        		String viewName=UIFactory.viewStack.peek();
//        		System.out.println("View="+viewName);
//        		BodyView view=UIFactory.viewCache.get(viewName);
//        		if(view!=null)view.show();
        	}
        }
    };

    int back()
    {
    	LuaState L=LuaContext.getInstance().getLuaState();
    	 L.getField(LuaState.LUA_GLOBALSINDEX, "back");
         //L.pushString("in the pad!");   
         L.call(0,1);                    
         
         L.setField(LuaState.LUA_GLOBALSINDEX, "backStatus");
         LuaObject obj = L.getLuaObject("backStatus");    
         int result=(int)obj.getNumber();
         System.out.println("back status:"+result);
         return result;
    }
    
    @Override  
    public boolean onKeyDown(int keyCode, KeyEvent event) {   
        if (keyCode == KeyEvent.KEYCODE_BACK && event.getRepeatCount() == 0) {   
        	 mHandle.sendEmptyMessage(MSG_EXIT);  
        	 
            return false;   
        }   
        return false;   
    } 

}
