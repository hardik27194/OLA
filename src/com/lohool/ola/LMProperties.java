package com.lohool.ola;

import java.io.IOException;
import java.util.ArrayList;









import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import com.lohool.ola.util.DES3Encrypt;
import com.lohool.ola.util.StringUtil;
import com.lohool.ola.util.XMLProperties;
import com.lohool.ola.wedgit.IAlert;
import com.lohool.ola.wedgit.SoundPlayer;

import android.os.Environment;
import android.util.Log;

/**
 * the main lua mobile properties
 * @author xingbao-
 *
 */
public class LMProperties {
	
	String appBase="app/";
	String fileBase="";
	//String appUrl="test/";
	String appName;
	String appPackage="";
	String sandboxRoot=".";
	
	long installedTime;
	long lastUsedTime;
	
	/**
	 * the application's status
	 * 0, not installed; 1--new installed, first time executed; 2--exectued
	 */
	int state=1;
	
	private LuaContext lua;
	
	ArrayList<String> globalScripts=new ArrayList<String>();
	ArrayList<String> initScripts=new ArrayList<String>();
	ArrayList<String> views=new ArrayList<String>();
	
	private static LMProperties instance;
	
	private LMProperties()
	{

		lua=LuaContext.getInstance();
		String initLuaCode=UIFactory.loadAssert("OLA.lua");
		lua.doString(initLuaCode);
		appBase=lua.getGlobalString("OLA.base");
		fileBase=lua.getGlobalString("OLA.storage");

		String sdcardRoot=Environment.getExternalStorageDirectory().getAbsolutePath() ;
		System.out.println("sdcardRoot="+sdcardRoot);
		System.out.println("getExternalStoragePublicDirectory="+Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES).getAbsolutePath());;
		System.out.println("getExternalStoragePublicDirectory="+Environment.getDataDirectory().getAbsolutePath());;
		fileBase=sdcardRoot+"/"+fileBase;
		
		lua.doString("OLA.storage='"+fileBase+"'");
		
		sandboxRoot="/data/data/"+this.appPackage+"/files/";
		lua.doString("OLA.app_path='"+sandboxRoot+"'");
		
		lua.regist(this, "LMProperties");
		lua.regist(Log.class, "Log");
		lua.regist(FileConnector.class, "FileConnector");
		lua.regist(IFileInputStream.class, "fis");
		lua.regist(IFileOutputStream.class, "fos");
		lua.regist(DES3Encrypt.class, "des3");
		lua.regist(StringUtil.class, "str");
		
		lua.regist(SoundPlayer.class, "MediaPlayer");
		
		lua.regist(IAlert.class, "Alert");
		
		
		loadXML();
	}
	public String getAppBase()
	{
		return  appBase;
	}
	public String getRootPath()
	{
		return  sandboxRoot;
	}
	public static LMProperties getInstance()
	{
		if(instance==null)instance=new LMProperties();

		return instance;
	}
	public static LMProperties create()
	{
		instance=new LMProperties();
		return instance;
	}

	public  void loadXML() {
		System.out.print("load xml");
			try {
				XMLProperties xmlRoot = new XMLProperties(UIFactory.loadResourceTextDirectly(appBase+"Main.xml"));
				System.out.print(UIFactory.loadResourceTextDirectly(appBase+"Main.xml"));
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
					if (n.getNodeName().equalsIgnoreCase("app-name")) 
					{
						appName= n.getTextContent();
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
		if(views.size()>0)name=this.getAppBase() + views.get(0).toString();
		return name;
	}
	void execInitScripts()
	{
		for(String src:initScripts)
		{
			
			lua.doString(UIFactory.loadResourceTextDirectly(this.getAppBase() + src));
		}
	}
	void execGlobalScripts()
	{
		for(String src:globalScripts)
		{
			System.out.println("global lua file="+src);
			lua.doString(UIFactory.loadResourceTextDirectly(this.getAppBase() + src));
		}
	}
	
	
}
