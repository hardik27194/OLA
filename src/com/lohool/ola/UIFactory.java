package com.lohool.ola;

import java.io.ByteArrayOutputStream;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;
import java.util.concurrent.ExecutionException;

import org.apache.http.util.EncodingUtils;
import org.keplerproject.luajava.LuaObject;
import org.keplerproject.luajava.LuaState;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;









import com.lohool.ola.util.StackX;
import com.lohool.ola.util.XMLProperties;
import com.lohool.ola.wedgit.BaiDuMap;
import com.lohool.ola.wedgit.CssClass;
import com.lohool.ola.wedgit.IButton;
import com.lohool.ola.wedgit.ICheckBox;
import com.lohool.ola.wedgit.IContainer;
import com.lohool.ola.wedgit.IFrameLayout;
import com.lohool.ola.wedgit.IGifView;
import com.lohool.ola.wedgit.ILabel;
import com.lohool.ola.wedgit.ILineChart;
import com.lohool.ola.wedgit.ILinearLayout;
import com.lohool.ola.wedgit.IProgressBar;
import com.lohool.ola.wedgit.IRelativeLayout;
import com.lohool.ola.wedgit.IRoundImage;
import com.lohool.ola.wedgit.IScrollView;
import com.lohool.ola.wedgit.ITable;
import com.lohool.ola.wedgit.ITableRow;
import com.lohool.ola.wedgit.ITextField;
import com.lohool.ola.wedgit.IView;
import com.lohool.ola.wedgit.IWebView;
import com.lohool.ola.wedgit.Layout;

import android.content.Context;
import android.os.AsyncTask;



public class UIFactory {
	Context ctx;
	BodyView bodyView;
	static HashMap<String, BodyView> viewCache= new HashMap();
	static StackX<String> viewStack=new StackX();
	public CssClass cssClass=new CssClass();

	
	public UIFactory(BodyView bodyView,Context ctx )
	{
		this.bodyView=bodyView;
		this.ctx=ctx;
	}
	
	public void switchView(String name)
	{
		switchView(name,null,null,false,null);
	}
	
	public void switchView(String name,String callback)
	{
		switchView(name,null,null,false,null);
	}
	public void switchView(String name,String callback,String params)
	{
		switchView(name,callback,params,false,null);
	}
	
	public void switchView(String name,String callback,String params,String loadingXml)
	{
		switchView(name,callback,params,false,loadingXml);
	}
	
	public void switchView(String pageName,String callback,String params,boolean needReload,String loadingXml)
    {
//		String name=AppProperties.getInstance().getAppBase()+pageName;
		//show loading screen
		Layout oldLayout=bodyView.layout;
		
		//try to add a "Loading..." view, but it needs to add function "loadingViewXmlStr()" to the global settings of the app
	
		LuaState lua=LuaContext.getInstance().getLuaState();
		
		/*
		lua.getField(LuaState.LUA_GLOBALSINDEX, "loadingViewXml");		 
		lua.call(0,1);
        lua.setField(LuaState.LUA_GLOBALSINDEX, "loadingViewXmlStr");   
        LuaObject lobj =lua.getLuaObject("loadingViewXmlStr");   
        String loadingXml=lobj.getString();
        */
		IView loadingView=null;
       System.out.println("loading view xml:"+loadingXml);
       if(loadingXml!=null && !loadingXml.trim().equals(""))
       {
    	   loadingView=this.createViewByXml(loadingXml);
    	   oldLayout.addOlaView(loadingView);
       }
      
        
		String name=OLA.appBase+pageName;
		
		
			
			
		
		BodyView v;
		Object obj=viewCache.get(name);
		if(obj!=null && !needReload)
		{			
			v=(BodyView)obj;
		}
		else
		{
			 v=new BodyView(ctx,name);
			if(!needReload) viewCache.put(name, v);
		
		}
		viewLoadTask task = new viewLoadTask();
		task.execute(oldLayout,loadingView,v,params,callback);
		//task.execute(oldLayout,null,v,params,callback);
		
		UIFactory.viewStack.push(name);
		
		UIFactory.viewStack.displayStack();
		
		/*
		LuaContext.getInstance().doString("exit()");
		v.setParameters(params);
		v.setCallBack(callback);
  	 	v.show();
  	 	*/
		
  	 	
  	 	//oldLayout.removeView(loadingView);

    }
	
	


	private class viewLoadTask extends AsyncTask<Object, Integer, Layout> {
		Layout oldLayout;
		IView loadingView;
		@Override
		protected Layout doInBackground(Object... params) {
			System.out.println("loading view xml:start doInBackground");
			
			oldLayout=(Layout)params[0];
			loadingView=(IView)params[1];
			
			BodyView v=(BodyView)params[2];
			
			String viewParams=(String)params[3];
			String callback=(String)params[4];
			
	
			LuaContext.getInstance().doString("exit()");
			v.setParameters(viewParams);
			v.setCallBack(callback);
	  	 	//v.show();
			v.executeLua();
			System.out.println("loading view end doInBackground");
			return v.layout;
		}
		protected void onPostExecute(Layout layout) {
			
			if(loadingView!=null)oldLayout.removeOlaView(loadingView);
			Main.activity.setContentView(layout.getView());
			
		}
	}
	
	
	public void cleanViewCache()
	{
		viewStack.clear();
	}
	public String getParameters() {
		return bodyView.getParameters();
	}
	
	public String getRootViewId()
	{
		return bodyView.layout.getId();
	}
	
//	public  Layout loadXML(String url) 
//	{
//	 return loadXML(url,true);
//	}
	/**
	 * load and create an first Level Layout from an XML file
	 * @return
	 */
	public  Layout createLayoutByXMLFile(String url) {
		Layout layout = null;

			try {
				// String
				// xml=loadAssetsString("http://10.0.2.2:8080/CRM/testLua.htm");
				 System.out.println("Layout xml url="+url);
				XMLProperties xmlRoot = new XMLProperties(loadAssetsString(url));
				Element html = xmlRoot.getRootElement();
				layout=createActiveBody(html);
//				LayoutInflater flat=LayoutInflater.from(ctx);
				
			} catch (IOException e) {
				e.printStackTrace();
			} catch (Exception e) {
				e.printStackTrace();
			}
		
		
		
		return layout;
	}
	public  Layout createLayoutByXMLString(String xml) {
		Layout layout = null;

			try {
				XMLProperties xmlRoot = new XMLProperties(xml);
				Element html = xmlRoot.getRootElement();
				layout=createActiveBody(html);
//				LayoutInflater flat=LayoutInflater.from(ctx);
				
			} catch (IOException e) {
				e.printStackTrace();
			} catch (Exception e) {
				e.printStackTrace();
			}
		
		
		
		return layout;
	}
	/**
	 * create a dynamic view by Lua script, and the view is registered into Lua environment
	 * @param xml
	 * @return the view's id
	 */
	public String createView(String xml)
	{
		String id=null;
		IView v= createViewByXml(xml);
		id=v.getId();
		return id;
	}

	public IView createViewByXml(String xml)
	{
		String id=null;
		IView v=null;
		try {
			//System.out.println("create xml view:"+xml);
			//Looper.prepare();
			XMLProperties xmlRoot = new XMLProperties(xml);
			Element root=xmlRoot.getRootElement();
			id=root.getAttribute("id");
			if(id==null || id.trim().equals(""))
			{
				id="View_ID_"+root.getNodeName()+"_"+System.currentTimeMillis()+"_"+(int)(Math.random()*1000);
				root.setAttribute("id", id);				
			}
			
			
			if(root.getNodeName().equalsIgnoreCase("DIV"))
			{
				Layout layout= createLayout(null, ctx,  root);
				v=layout;
			}
			else if(root.getNodeName().equalsIgnoreCase("TR"))
			{
				v=new ITableRow(null, ctx,  root,this);
			}
			else
			{
				
				IView view=createView(null, ctx,  root);
				v=view;
			}
			LuaContext.getInstance().regist(v, id);
			//Looper.loop();
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		
		return v;
	}
	
	private Layout createActiveBody(Element xmlRoot)
	{
		Layout layout = null;
		try {
			NodeList nl = xmlRoot.getChildNodes();
			for (int i = 0; i < nl.getLength(); i++) {

				Node n = nl.item(i);
				
				if (n != null && n.getNodeType() == Node.ELEMENT_NODE
						&& ((Element) n).getTagName().equalsIgnoreCase("head"))
				{
					parseXMLHeader(n);
				}
				else if (n != null && n.getNodeType() == Node.ELEMENT_NODE
						&& ((Element) n).getTagName().equalsIgnoreCase("style"))
				{
					System.out.println("style value="+n.getTextContent().replaceAll("\n", " "));
					cssClass.addStyle(n.getTextContent().replaceAll("\n", " "));
				}
				else if (n != null && n.getNodeType() == Node.ELEMENT_NODE
						&& ((Element) n).getTagName().equalsIgnoreCase("body")) 
				{
					layout = createLayout(null, ctx, n);
					// this.setContentView(layout.getView());
				}
				
			}
			

		} catch (Exception e) {
			e.printStackTrace();
		}
		

		return layout;
	}
	
	
	void parseXMLHeader(Node header)
	{
		
		try {
			NodeList nl = header.getChildNodes();
			for (int i = 0; i < nl.getLength(); i++) {

				Node n = nl.item(i);
				if (n != null && n.getNodeType() == Node.ELEMENT_NODE
						&& ((Element) n).getTagName().equalsIgnoreCase("style"))
				{
					cssClass.addStyle(n.getTextContent().replace("\n", " "));
				}

			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}
	
	
	public  String loadLayoutLuaCode(String xmlUrl)
	{
//		String temp = loadAssetsString("http://10.0.2.2:8080/test/lua/FileOpener.lua");
//		lua.LdoString(temp);
		System.out.println("lua file="+xmlUrl+".lua");
		
		String temp = loadAssetsString(xmlUrl+".lua");
		return temp;
	}

	//public abstract void createView();
	public  Layout createLayout(IView parent,Context context, Node root)
	{
		String name=root.getNodeName();
    	//System.out.println("Tag name="+name);
		String layoutName=((Element)root).getAttribute("layout").trim();
		System.out.println("layout name ="+layoutName);
		
		Layout v=null;
		if(layoutName==null || layoutName.equals(""))
		{
			v=new ILinearLayout(parent, context,  root,this);
		}
		else if(layoutName.equalsIgnoreCase("FrameLayout"))
		{
			v=new IFrameLayout(parent, context,root,this);
		}
		else if(layoutName.equalsIgnoreCase("LinearLayout"))
		{
			v=new ILinearLayout(parent, context,  root,this);
		}
		else if(layoutName.equalsIgnoreCase("RelativeLayout"))
		{
			v=new IRelativeLayout(parent, context,  root,this);
			
		}

		
		return v;
	}

	public  IView createView(IContainer rootView,Context context,Node n)
	{
		IView v=null;
		String name=n.getNodeName();
    	if (name.equalsIgnoreCase("BUTTON"))
    	{
    		v= new IButton(rootView,context,n,this);
    		
    	}
    	else if (name.equalsIgnoreCase("LABEL"))
    	{
    		v= new ILabel(rootView,context,n,this);
    	}
    	else if (name.equalsIgnoreCase("TEXTFIELD"))
    	{
    		v= new ITextField(rootView,context,n,this);
    	}
    	else if (name.equalsIgnoreCase("PASSWORD"))
    	{
    		ITextField t= new ITextField(rootView,context,n,this);
    		t.setInputType(ITextField.TYPE_MASK_FLAGS, ITextField.TYPE_TEXT_VARIATION_WEB_PASSWORD);
    		v=t;
    	}
    	else if (name.equalsIgnoreCase("TABLE"))
    	{
    		v= new ITable(rootView,context,n,this);
    	}
    	else if (name.equalsIgnoreCase("SCROLLVIEW"))
    	{
    		v= new IScrollView(rootView,context,n,this);
    	}
    	else if (name.equalsIgnoreCase("PROGRESSBAR"))
    	{
    		v= new IProgressBar(rootView,context,n,this);
    	}
    	else if (name.equalsIgnoreCase("CHECKBOX"))
    	{
    		v= new ICheckBox(rootView,context,n,this);
    	}
    	else if (name.equalsIgnoreCase("LINECHART"))
    	{
    		v= new ILineChart(rootView,context,n,this);
    	}
    	else if (name.equalsIgnoreCase("ROUNDIMAGE"))
    	{
    		v= new IRoundImage(rootView,context,n,this);
    	}
    	else if (name.equalsIgnoreCase("MAP"))
    	{
    		v= new BaiDuMap(rootView,context,n,this);
    	}
    	else if (name.equalsIgnoreCase("WEBVIEW"))
    	{
    		v= new IWebView(rootView,context,n,this);
    	}
    	else if (name.equalsIgnoreCase("GIFVIEW"))
    	{
    		v= new IGifView(rootView,context,n,this);
    	}
    	return v;
	}
//	static HttpURLConnection  urlConn =null;
	 private  class DownloadTask extends AsyncTask<String, Integer, String> {

		 protected String doInBackground(String... urls)
		 {
			 InputStream in=null;
			 ByteArrayOutputStream out= new ByteArrayOutputStream();
				HttpURLConnection urlConn =null;
				byte[] bs = new byte[2048];
				try
				{
					URL url = new URL(urls[0]);
					urlConn = (HttpURLConnection) url.openConnection();
					in = urlConn.getInputStream();

					int count = 0;

					while (-1 != (count = in.read(bs)))
					{
						out.write(bs, 0, count);
					}


				} catch (Exception e1)
				{
					e1.printStackTrace();
				} finally
				{
					if(urlConn!=null)
					{
						urlConn.disconnect();
					}
					if (in != null)
					{
						try
						{
							in.close();

						} catch (IOException e)
						{
						}
					}
				}
				String content="";
				try
				{
					content=out.toString("utf-8");
				} catch (UnsupportedEncodingException e1)
				{
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}
				try
				{
					out.close();
				} catch (IOException e1)
				{
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}
				return content;
		 }
		protected String doInBackground1(String... urls) {
			int count = urls.length;
			InputStream isread = null;
			HttpURLConnection urlConn =null;
			StringBuffer buf = new StringBuffer();
			byte[] luaByte = new byte[1];
			try {
				URL url = new URL(urls[0]);
				urlConn = (HttpURLConnection) url.openConnection();
				
				isread = urlConn.getInputStream();
				

				int len = 0;
				while ((len = isread.available()) > 0) 
				{
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
						isread=null;
					} catch (IOException e) {
					}
				}
				if (urlConn != null) {
						urlConn.disconnect();
				}
			}
			return buf.toString();

		}
		protected void onProgressUpdate(Integer... progress) {

		}

		protected void onPostExecute(Long result) {

		}

	}

	// ���URL�õ�������
//	private static InputStream getInputStreamFromUrl(String urlStr)
//			throws Exception {
//		URL url = new URL(urlStr);
//		HttpURLConnection urlConn = (HttpURLConnection) url.openConnection();
//		InputStream inputStream = urlConn.getInputStream();
//		return inputStream;
//	}
	
	public static String loadResourceTextDirectly(String resPath) {

		if(resPath.startsWith("http://"))return loadOnline(resPath);
		else
		return loadAssert(resPath);

	}
	public static String loadOnline(String resPath) {

			 InputStream in=null;
			 ByteArrayOutputStream out= new ByteArrayOutputStream();
				HttpURLConnection urlConn =null;
				byte[] bs = new byte[2048];
				try
				{
					URL url = new URL(resPath);
					urlConn = (HttpURLConnection) url.openConnection();
					urlConn.setConnectTimeout(5000);
					in = urlConn.getInputStream();

					int count = 0;

					while (-1 != (count = in.read(bs)))
					{
						out.write(bs, 0, count);
					}


				} catch (Exception e1)
				{
					e1.printStackTrace();
				} finally
				{
					if(urlConn!=null)
					{
						urlConn.disconnect();
					}
					if (in != null)
					{
						try
						{
							in.close();

						} catch (IOException e)
						{
						}
					}
				}
				String content="";
				try
				{
					content=out.toString("utf-8");
				} catch (UnsupportedEncodingException e1)
				{
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}
				try
				{
					out.close();
				} catch (IOException e1)
				{
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}
				return content;

	}
	
	public static String loadAssert(String resPath) {
		StringBuffer buf = new StringBuffer();
			// 获得InputStream对象
//			InputStream is = getResources().getAssets().open("IELTSCore3000.db");
			
		InputStream isread = null;
			
			byte[] luaByte = new byte[0];
			try {
				 isread =new FileInputStream(resPath);
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



	public  String loadAssetsString(String resPath) {
		String code=null;
		
		if(resPath.startsWith("http://"))
		{
		DownloadTask task=new DownloadTask();
        task.execute(resPath); 
        
		try {
			code = task.get();
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (ExecutionException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		}
		else
			code=loadAssert(resPath);

       return code;
		/*
		InputStream isread = null;
		StringBuffer buf = new StringBuffer();
		byte[] luaByte = new byte[1];
		try {
			isread = UIFactory.getInputStreamFromUrl(resPath);

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
		*/
		
	}
/*	
	private class DownloadAscill implements Runnable
	{
		boolean isFinished;
		String ac;
		public DownloadAscill(String ac)
		{
			this.ac=ac;
		}
		StringBuffer buf = new StringBuffer();
		@Override
		public void run() {
			InputStream isread = null;
			HttpURLConnection urlConn =null;
			byte[] luaByte = new byte[1];
			try {
				
				URL url = new URL(ac);
				urlConn = (HttpURLConnection) url.openConnection();
				isread = urlConn.getInputStream();

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
				if(urlConn!=null)
				{
					urlConn.disconnect();
				}
			}
			
		  	 	
		  	 	//ac.setContentView(v.getLayout().getView());
		}
		public boolean isFinished()
		{
			return this.isFinished;
		}
		public String getValue()
		{
			return buf.toString();
		}
		
	}
	
*/
}
