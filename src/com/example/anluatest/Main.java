package com.example.anluatest;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;


import android.os.AsyncTask;
import android.os.Bundle;
import android.annotation.SuppressLint;
import android.app.Activity;
import android.util.Log;
import android.view.GestureDetector;
import android.view.Menu;
import android.view.MotionEvent;
import android.widget.FrameLayout;



@SuppressLint("NewApi")
public class Main extends Activity {

	private FrameLayout mLayout;
//	private LuaState lua;
	public static Main ctx;
 
	LMProperties properties;
	
	 
//	UIFactory ui= new UIFactory(ctx,lua);
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
//        setContentView(R.layout.activity_main);
        Log.v("MainActivity", "onCreate...");
        
        System.out.println("getExternalFilesDir="+this.getExternalFilesDir(null));
        ctx=this;
        

        
        
//        class CustomGifView extends View {   
//        	private Movie mMovie;    
//       	 	private long mMovieStart;
//            public CustomGifView(Context context) {    
//                super(context);    
//                mMovie = Movie.decodeStream(getResources().openRawResource(    
//                        R.drawabl	e.ic_ldoading));   
//            }    
//               
//            public void onDraw(Canvas canvas) {   
//                long now = android.os.SystemClock.uptimeMillis();    
//                   
//                if (mMovieStart == 0) { // first time    
//                    mMovieStart = now;    
//                }    
//                if (mMovie != null) {    
//                       
//                    int dur = mMovie.duration();    
//                    if (dur == 0) {    
//                        dur = 1000;    
//                    }    
//                    int relTime = (int) ((now - mMovieStart) % dur);                   
//                    mMovie.setTime(relTime);    
//                    mMovie.draw(canvas, 0, 0);    
//                    invalidate();    
//                }    
//            }   
//        }   

        
        this.setContentView(R.layout.activity_main);
        
//        lua = LuaStateFactory.newLuaState();
//    	lua.openLibs();
        
        InitPropertiesTask task= new InitPropertiesTask();
        task.execute("");
	  	 	
	  	 	
       
//        if (android.os.Build.VERSION.SDK_INT > 9) {
//            StrictMode.ThreadPolicy policy = new StrictMode.ThreadPolicy.Builder().permitAll().build();
//            StrictMode.setThreadPolicy(policy);
//        }
	  	 	
//        DownloadFilesTask task=new DownloadFilesTask();
//        task.execute("");
        
//        AppInit ai= new AppInit();
//        Thread t=new Thread(ai);
//        t.start();
//        
//        Monitor m=new Monitor();
//        m.execute(ai);
        
//		try {
//			v = task.get();
//		} catch (InterruptedException e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		} catch (ExecutionException e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		}

        
    }

    private void initProperties()
    {
    	System.out.println("initProperties is executed");
        properties=LMProperties.getInstance();
        
        String packageName=Main.class.getPackage().getName();
		System.out.println(packageName);
		properties.appPackage=packageName;
		properties.execGlobalScripts();
			loadDefaultProperties(properties);

	  	 	properties.state++;
	  	 	if(properties.state<2) 	
	  	 	{
	  	 		initDatabase();
	  	 		properties.execInitScripts();
	  	 	}
	  	 	//update the properties
	  	 	ctx.writeProperties(properties);		
		
    }
   
    
    private class InitPropertiesTask extends AsyncTask<String, Integer, String> {

		@Override
		protected String doInBackground(String... params) {
			System.out.println("InitPropertiesTask.doInBackground");
			initProperties();
			return "";
		}
		@Override
		protected void onPostExecute(String result) {
			System.out.println("InitPropertiesTask.onPostExecute");
			startInitFirstViewTask();
					
		}
    }
    private void startInitFirstViewTask()
    {
//    	InitFirstViewTask initFirstViewTask=new InitFirstViewTask();
//    	initFirstViewTask.execute("");
    	initFirstView();
    }
    private void initFirstView()
    {
    	BodyView v=null;
    	String name=properties.getFirstViewName();
        if(name!=null)
        {
			v=new BodyView(ctx,name);				
			UIFactory.viewCache.clear();//
			UIFactory.viewCache.put(name, v);
			
//			ctx.setContentView(v.getLayout().getView());
        }
        v.show();
  	 	
    }
    private class InitFirstViewTask extends AsyncTask<String, Integer, String> {
    	BodyView v=null;
		@Override
		protected String doInBackground(String... params) {

			 
		      //load the first page
		        String name=properties.getFirstViewName();
		        if(name!=null)
		        {
					v=new BodyView(ctx,name);				
					UIFactory.viewCache.clear();//
					UIFactory.viewCache.put(name, v);
					
//					ctx.setContentView(v.getLayout().getView());
		        }
			return "";
		}
		protected void onPostExecute(String result) {

				v.show();
		}
    }
    private class Monitor extends AsyncTask<AppInit, Integer, String> {
    	AppInit t;
		@Override
		protected String doInBackground(AppInit... params) {
			 t=params[0];

			while(!t.isFinished())
			{
				try {					
					wait(1000L);
				} catch (InterruptedException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			return "";
		}
		protected void onPostExecute(BodyView result) {

					t.getBodyView().show();
		}
    }

	private class DownloadFilesTask extends AsyncTask<String, Integer, BodyView> {
		BodyView v;
		
		protected void onPreExecute()
		{
			super.onPreExecute();

			System.out.println("onPreExecute is executed");
		}
		protected BodyView doInBackground(String... urls) {
			System.out.println("doInBackground is executed");
			int count = urls.length;
//			for (int i = 0; i < count; i++) {
//
//				publishProgress(0);
//				// Escape early if cancel() is called
//				if (isCancelled())
//					break;
//			}
	        properties=LMProperties.getInstance();
	        
	        String packageName=Main.class.getPackage().getName();
			System.out.println(packageName);
			properties.appPackage=packageName;
			properties.execGlobalScripts();
			
			//load the first page
	        String name=properties.getFirstViewName();
	        if(name!=null)
	        {
				v=new BodyView(ctx,name);				
//				UIFactory.viewCache.clear();//
				UIFactory.viewCache.put(name, v);
				
//				ctx.setContentView(v.getLayout().getView());
	        }
				loadDefaultProperties(properties);
				
				
		  	 	
		  	 	
		  	 	properties.state++;
		  	 	if(properties.state<2) 	
		  	 	{
		  	 		initDatabase();
		  	 		properties.execInitScripts();
		  	 	}
		  	 	//update the properties
		  	 	ctx.writeProperties(properties);
		  	 	System.out.println("doInBackground is ended");
			return v;
		}

		protected void onPreExecute(Integer... progress) {
			System.out.println("onPreExecute is executed");
		}

		protected void onPostExecute(BodyView result) {
			System.out.println("onPostExecute is executed");
			System.out.println("onPostExecute v="+v);
			 if(v!=null)
		        {
					
					UIFactory.viewCache.clear();//
		//			UIFactory.viewCache.put(name, v);
					
					v.show();
		        }
		}

	}
	private class AppInit implements Runnable
	{
		boolean isFinished;
//		MainActivity ac;
//		public AppInit(MainActivity ac)
//		{
//			this.ac=ac;
//		}
		BodyView v;
		@Override
		public void run() {
	        properties=LMProperties.getInstance();
	        
	        String packageName=Main.class.getPackage().getName();
			System.out.println(packageName);
			properties.appPackage=packageName;
			properties.execGlobalScripts();
			
			//load the first page
	        String name=properties.getFirstViewName();
	        if(name!=null)
	        {
				v=new BodyView(ctx,name);				
//				UIFactory.viewCache.clear();//
				UIFactory.viewCache.put(name, v);
				
//				ctx.setContentView(v.getLayout().getView());
	        }
				loadDefaultProperties(properties);
		  	 	
		  	 	properties.state++;
		  	 	if(properties.state<2) 	
		  	 	{
		  	 		initDatabase();
		  	 		properties.execInitScripts();
		  	 	}
		  	 	//update the properties
		  	 	ctx.writeProperties(properties);
		  	 	
		  	 	//ac.setContentView(v.getLayout().getView());
		}
		public boolean isFinished()
		{
			return this.isFinished;
		}
		public BodyView getBodyView()
		{
			return this.v;
		}
		
	}
    
	private void showBodyView(BodyView v)
	{
		v.show();
	}
    public static Main getActivity()
    {
    	return ctx;
    }
    
//    public void switchActivity(String name,String params)
//    {
//    	/* 新建一个Intent对象 */
//        Intent intent = new Intent();
//        intent.putExtra("name","LeiPei");    
//        /* 指定intent要启动的类 */
//        intent.setClass(this, Activity02.class);
//        /* 启动一个新的Activity */
//        this.startActivity(intent);
//        /* 关闭当前的Activity */
//        this.finish();
//    }
//    
    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
//        getMenuInflater().inflate(R.menu.main, menu);
        return true;
    }

	private void initDatabase() {
//		Toast.makeText(this, "初始化...", 2000);
		// 获取数据库文件要存放的路径
		String databaseFilename = "/sdcard/test/test.db";
		File dir = new File("/sdcard/test"); // 如果目录不存在，创建这个目录
		if (!dir.exists()) {
			dir.mkdir();
		} // 数据库文件是否已存在，不存在则导入
		if (!(new File(databaseFilename)).exists()) {
			// StartFrameTask startFrameTask = new StartFrameTask();
			// startFrameTask.execute();
			copyDataBase();
		} else {
			System.out.println("数据库已经存在");
		}
	}


	public  void copyDataBase() {
		try {
			// 获得InputStream对象
//			InputStream is = getResources().getAssets().open("IELTSCore3000.db");
			InputStream is = getAssets().open("IELTSCore3000.aac");

			FileOutputStream fos = new FileOutputStream("/sdcard/test/test.db");
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
		} catch (Exception e) {
			e.printStackTrace();
		}

	}
	
	private void loadDefaultProperties(LMProperties prop) {
		try{
		String packageName=this.getClass().getPackage().getName();
		System.out.println(packageName);
		File file=new File("/data/data/"+packageName+"/files/.properties");
		if(file.exists())
		{
			System.out.println(".properties file is existed");
			loadProperties(prop);
		}
		else
		{
			System.out.println(".properties file is not existed");
			writeProperties(prop);

		}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	private void loadProperties(LMProperties prop)
	{
		String packageName=this.getClass().getPackage().getName();
		File file=new File("/data/data/"+packageName+"/files/.properties");
		try{
		FileInputStream fis = new FileInputStream(file);
		DataInputStream in=new DataInputStream(fis);
		byte[] luaByte = new byte[1];
		try {
			prop.state=in.readInt();
			prop.installedTime=in.readLong();
			prop.lastUsedTime=in.readLong();
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
	private void writeProperties(LMProperties prop)
	{
		String packageName=this.getClass().getPackage().getName();
		File file=new File("/data/data/"+packageName+"/files/.properties");
		if(!file.exists())file.getParentFile().mkdirs();
		
		try{
		FileOutputStream fos = new FileOutputStream(file);
		DataOutputStream out=new DataOutputStream(fos);
		byte[] luaByte = new byte[1];
		try {
			out.writeInt(prop.state);	//new installed
			out.writeLong(prop.installedTime);	//安装时间
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
    	System.out.println(v.getId());
//    	lua.LdoString("function testLua() print ('Lua test...') end");
//    	lua.getField(LuaState.LUA_GLOBALSINDEX, "testLua");
//    	lua.call(0, 0);
    	
    	lua.LdoString("acceptLuaFun()");
    	lua.LdoString("text = 'Hello Android, I am Lua.'");     
    	lua.getGlobal("text");
    	String text = lua.toString(-1);
    	System.out.println("Lua String:"+text);
    	
    	
    	//����lua
        
        LuaState L = lua;
//        L.openLibs();
        String temp = UIFactory.loadAssetsString("http://16.187.151.18:8080/test/testLua.lua");
        System.out.println("internet Lua String:"+temp);
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


//        	 System.out.println("internet Lua String:"+temp);
//        	 System.out.println(getApplicationContext());
//        	 System.out.println(mLayout);
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
        	 

        	 Button btn2= new Button(this);
        	 btn2.setText("Buttontest");
        	 d.addView(btn2);
        	 Button btn3= new Button(this);
        	 btn3.setText("Buttontest3");
        	 d.addView(btn3);
        	 this.mLayout.addView(d.getView());
        	 
        	 
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

}
