package com.lohool.ola;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.keplerproject.luajava.JavaFunction;
import org.keplerproject.luajava.LuaException;
import org.keplerproject.luajava.LuaState;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import android.os.AsyncTask;
import android.os.Environment;
import android.util.Log;

import com.lohool.ola.util.DES3Encrypt;
import com.lohool.ola.util.StringUtil;
import com.lohool.ola.util.XMLProperties;
import com.lohool.ola.util.ZipUtil;
import com.lohool.ola.wedgit.UIMessage;

public abstract class AbstractProperties
{
	
	String appBase="apps/";
	String appServer="";
	String mode="developement";
//	String platformApp="olaportal/";
	public static String fileBase="";
	//String appUrl="test/";
	String appName;
	String appTitle;
	String appPackage="";
	String sandboxRoot=".";
	
	long installedTime;
	long lastUsedTime;
	
	String os="Android";
	double version=1.0;
	
	boolean isPlatformApp=false;
	/**
	 * the application's status
	 * 0, not installed; 1--new installed, first time executed; 2--exectued
	 */
	int state=1;
	
	protected LuaContext lua;
	
	public AppProperties currentApp;
	
	ArrayList<String> globalScripts=new ArrayList<String>();
	ArrayList<String> initScripts=new ArrayList<String>();
	ArrayList<String> views=new ArrayList<String>();
	ArrayList<String> apps=new ArrayList<String>();
	
	
	
	protected AbstractProperties()
	{
		
	}
	
	void initiateLuaContext()
	{
		lua=LuaContext.createInstance();
		LuaContext.registInstance(lua);
		sandboxRoot="/data/data/"+Main.class.getPackage().getName()+"/";
		
		lua.regist(this, "LMProperties");
		lua.regist(Log.class, "Log");
		lua.regist(FileConnector.class, "FileConnector");
		lua.regist(IFileInputStream.class, "fis");
		lua.regist(IFileOutputStream.class, "fos");
		lua.regist(DES3Encrypt.class, "des3");
		lua.regist(StringUtil.class, "str");
		
		lua.regist(SoundPlayer.class, "MediaPlayer");
		
//		lua.regist(IAlert.class, "Alert");
		
		lua.regist(UIMessage.class, "uiMsg");
		lua.regist(MyAsyncTask.class, "AsyncTask");
		
		lua.regist(AsyncDownload.class, "AsyncDownload");
		
		lua.regist(HTTP.class, "HTTP");
		
		lua.regist(ZipUtil.class, "Zip");
		
		

		System.out.println("lua file="+sandboxRoot+appBase+"OLA.lua");
		//lua.doFile(sandboxRoot+appBase+"OLA.lua");
		String olaLua=Main.loadAsset("OLA.lua");
		lua.doString(olaLua);
		
		this.mode=lua.getGlobalString("OLA.mode");
		appBase=lua.getGlobalString("OLA.base");
		appServer=lua.getGlobalString("OLA.app_server");
		System.out.println("LMProp appServer="+appServer);
		if(appServer==null)appServer="";
		
		if(isPlatformApp || appServer==null || appServer=="" || !appServer.startsWith("http://"))	appBase=sandboxRoot+appBase;
		else appBase=appServer+"/"+appBase;
		
		OLA.appBase=appBase+appName+"/";
		
		//sdcard dir
		fileBase=lua.getGlobalString("OLA.storage");

		String sdcardRoot=Environment.getExternalStorageDirectory().getAbsolutePath() ;
//		System.out.println("sdcardRoot="+sdcardRoot);
//		System.out.println("getExternalStoragePublicDirectory="+Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES).getAbsolutePath());;
//		System.out.println("getExternalStoragePublicDirectory="+Environment.getDataDirectory().getAbsolutePath());
		fileBase=sdcardRoot+"/"+fileBase;
		
		lua.doString("OLA.storage='"+fileBase+"'");
		

		lua.doString("OLA.app_path='"+sandboxRoot+"'");

		
		LuaState L=lua.getLuaState();
		JavaFunction assetLoader = new JavaFunction(L) {
			@Override
			public int execute() throws LuaException {
				String name = L.toString(-1);
				try {
					InputStream is=null;
					if(!isPlatformApp && appServer.startsWith("http://"))
					{
						System.out.println("HTTP Require lua="+appBase+appName+"/lua/"+name + ".lua");
						URL url = new URL(appBase+appName+"/lua/"+name + ".lua");
						HttpURLConnection urlConn = (HttpURLConnection) url.openConnection();
						is = urlConn.getInputStream();
					}
					else
					{
						File file=new File(appBase+appName+"/lua/"+name + ".lua");
	//					System.out.println("Load required file="+sandboxRoot+name + ".lua");
						is = new FileInputStream(file);
					}
					byte[] bytes = readAll(is);
					L.LloadBuffer(bytes, name);
					is.close();
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
		}   
		// package loaders loader
		L.rawSetI(-2, nLoaders + 1);       // package loaders
		L.pop(1);                          // package
		
		L.getField(-1, "path");            // package path
		String customPath = sandboxRoot + "lua/?.lua";
		L.pushString(";" + customPath);    // package path custom
		L.concat(2);                       // package pathCustom
		L.setField(-2, "path");            // package
		L.pop(1);
		
	}
	void loadAppsInfo()
	{
		System.out.println(appBase+"/apps.json");
		String appsJson=appBase+"/apps.json";
		//if(appServer.startsWith("http://"))appsJson=appServer+"/apps.json";
		String appstr=UIFactory.loadResourceTextDirectly(appsJson);
//		System.out.println(appstr);
		try
		{
			JSONObject appObj = new JSONObject(appstr);
			//JSONArray apps=appObj.getJSONArray("user_apps");
			lua.doString("require 'JSON4Lua'");
//			System.out.println("apps.json="+appObj.toString());
			lua.doString("OLA.apps=json.decode('"+appObj.toString()+"')");
		} catch (JSONException e)
		{
			e.printStackTrace();
		}
	}
	abstract void reset();
	

	
	private static byte[] readAll(InputStream input) throws Exception {
		ByteArrayOutputStream output = new ByteArrayOutputStream(4096);
		byte[] buffer = new byte[4096];
		int n = 0;
		while (-1 != (n = input.read(buffer))) {
			output.write(buffer, 0, n);
		}
		return output.toByteArray();
	}

	public void sleep(int millsec)
	{
		
		try
		{
			Thread.sleep(millsec);
		} catch (InterruptedException e)
		{
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
//	public String getAppBase()
//	{
//		return  appBase+appName+"/";
//	}
	public String getRootPath()
	{
		return  sandboxRoot;
	}


	public  void loadXML() {
			try {
				XMLProperties xmlRoot = new XMLProperties(UIFactory.loadResourceTextDirectly(appBase+appName+"/Main.xml"));
				//System.out.print(UIFactory.loadResourceTextDirectly(appBase+"Main.xml"));
				Element html = xmlRoot.getRootElement();
				parse(html);
			} catch (IOException e) {
				e.printStackTrace();
			} catch (Exception e) {
				e.printStackTrace();
			}
	}
	void parse(Element root)
	{
		NodeList nl = root.getChildNodes();
		for (int i = 0; i < nl.getLength(); i++) {

			Node n = nl.item(i);
			if (n != null && n.getNodeType() == Node.ELEMENT_NODE)
			{
				//Element child=(Element) n;
				System.out.print("node name="+n.getNodeName());
					if (n.getNodeName().equalsIgnoreCase("app-title")) 
					{
						appTitle= n.getTextContent();
					}
					else if (n.getNodeName().equalsIgnoreCase("global")) 
					{
						parseScripts(n,true);
					}
					else if (n.getNodeName().equalsIgnoreCase("init")) 
					{
						parseScripts(n,false);
					}
					else if (n.getNodeName().equalsIgnoreCase("views")) 
					{
						
						parseViews(n);
					}

			}
		}
	}
	
	void parseScripts(Node root,boolean isGlobal)
	{
		NodeList nl = root.getChildNodes();
		for (int i = 0; i < nl.getLength(); i++) {

			Node n = nl.item(i);
			if (n != null && n.getNodeType() == Node.ELEMENT_NODE)
			{
				Element child=(Element) n;
					if (n.getNodeName().equalsIgnoreCase("script")) 
					{
						String src=child.getAttribute("src");
						if(isGlobal)this.globalScripts.add(src);
						else this.initScripts.add(src);
//						lua.LdoString(UIFactory.loadAssetsString(src));
					}
					
			}
		}
	}
	void parseViews(Node root)
	{
		NodeList nl = root.getChildNodes();
		for (int i = 0; i < nl.getLength(); i++) {

			Node n = nl.item(i);
			if (n != null && n.getNodeType() == Node.ELEMENT_NODE)
			{
				Element child=(Element) n;
					if (n.getNodeName().equalsIgnoreCase("view")) 
					{
						views.add(child.getAttribute("src"));
					}
			}
		}
	}
	public String getFirstViewName()
	{
		String name=null;
		if(views.size()>0)name=OLA.appBase + views.get(0).toString();
		return name;
	}
	void execInitScripts()
	{
		for(String src:initScripts)
		{
			
			lua.doString(UIFactory.loadResourceTextDirectly(OLA.appBase+ src));
		}
	}
	void execGlobalScripts()
	{
		for(String src:globalScripts)
		{
			System.out.println("global lua file="+OLA.appBase + src);
			String  code=UIFactory.loadResourceTextDirectly(OLA.appBase + src);
			System.out.println(code);
			lua.doString(code);
		}
	}
	
	
	public void printtype()
	{
		System.out.println(this.getClass());
	}

	public  LuaContext getLuaContext()
	{
		return lua;
	}
	
	public  AppProperties getAppProperties()
	{
		return this.currentApp;
	}
}
