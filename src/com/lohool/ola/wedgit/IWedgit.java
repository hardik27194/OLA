package com.lohool.ola.wedgit;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;

import org.keplerproject.luajava.LuaObject;
import org.keplerproject.luajava.LuaState;
import org.w3c.dom.Element;
import org.w3c.dom.Node;

import com.lohool.ola.BodyView;
import com.lohool.ola.OLA;
import com.lohool.ola.PortalProperties;
import com.lohool.ola.LuaContext;
import com.lohool.ola.Main;
import com.lohool.ola.UIFactory;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.res.AssetManager;
import android.graphics.Bitmap;
import android.graphics.Bitmap.Config;
import android.graphics.BitmapFactory;
import android.graphics.BitmapFactory.Options;
import android.graphics.Picture;
import android.graphics.Typeface;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.PictureDrawable;
import android.graphics.drawable.shapes.Shape;
import android.os.AsyncTask;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import android.text.Html;
import android.text.method.LinkMovementMethod;
import android.util.Log;
import android.util.TypedValue;
import android.view.GestureDetector;
import android.view.GestureDetector.SimpleOnGestureListener;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.View.OnTouchListener;
import android.view.ViewGroup.LayoutParams;
import android.view.ViewGroup.MarginLayoutParams;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TableRow;
import android.widget.TextView;

@SuppressLint("NewApi")
public abstract class IWedgit implements IView
{

	String objId;
	String onclick = null;
	String pressed = null;
	String released = null;
	private IView parent;

	String clickFun;

	View v;
	MarginLayoutParams param;
	Context context;
	Node root;
	CSS css;

	GestureDetector gesture;
	
	/**todo 45*/
	String defaultCSSStyle="";

	public IWedgit(IView parent, Context context, Node root)
	{
		this.parent = parent;
		this.context = context;
		this.root = root;

	}

	public String getObjectId()
	{
		return objId;
	}
	protected void initiate()
	{
		parseAttribute();
		parseCSS();
		addListner();
	}
	String ansyClick;
	String handlerClick;
	String threadClick;
	protected void parseAttribute()
	{
		String id = ((Element) root).getAttribute("id");
		if (id != null && !id.equals(""))
		{
			this.objId = id.trim();
			// System.out.println("Create View Item by Id="+id);
			LuaContext.getInstance().regist(this, objId);
		}
		String ansyClickStr = ((Element) root).getAttribute("ansyClick");
		if (ansyClickStr != null && !ansyClickStr.equals(""))
		{
			ansyClick=ansyClickStr;
		}
		String handlerClickStr = ((Element) root).getAttribute("handlerClick");
		if (handlerClickStr != null && !handlerClickStr.equals(""))
		{
			handlerClick=handlerClickStr;
		}
		String threadClickStr = ((Element) root).getAttribute("threadClick");
		if (threadClickStr != null && !threadClickStr.equals(""))
		{
			threadClick=threadClickStr;
		}

		String onclick = ((Element) root).getAttribute("onclick");
		if (onclick != null && !onclick.equals(""))
		{
			this.onclick = onclick.trim();
		}
		String onpress = ((Element) root).getAttribute("onpress");
		if (onpress != null && !onpress.equals(""))
		{
			this.pressed = onpress.trim();
		}
		String onrelease = ((Element) root).getAttribute("onrelease");
		if (onrelease != null && !onrelease.equals(""))
		{
			this.released = onrelease.trim();
		}
	}

	protected void parseCSS()
	{
		// set attributes
		if (css == null)
		{
			String cssString = defaultCSSStyle+((Element) root).getAttribute("style");
			css = new CSS(cssString);
		}

		// table
		if (this.getRoot().getNodeName().equalsIgnoreCase("TR"))
		{
			return;
		}

		CSS parentCss = null;
		if (getParent() != null)
			parentCss = getParent().getCss();
		String attr;

		if (param == null)
		{
			if (getParent() == null)
			{
				// the BODY tag or the created first level layout
				param = new MarginLayoutParams(MarginLayoutParams.WRAP_CONTENT,
						MarginLayoutParams.WRAP_CONTENT);
			} else if (getParent().getView() instanceof RelativeLayout)// ((attr=css.getStyleValue("position"))!=null)
			{
				param = new RelativeLayout.LayoutParams(
						MarginLayoutParams.WRAP_CONTENT,
						MarginLayoutParams.WRAP_CONTENT);
				RelativeLayout.LayoutParams p = (RelativeLayout.LayoutParams) param;
				if (parentCss.textAlign != null)
				{
					if ((parentCss.textAlign.equalsIgnoreCase("center")))
						p.addRule(RelativeLayout.CENTER_HORIZONTAL,
								RelativeLayout.TRUE);
					// else if(
					// (css.textAlign.equalsIgnoreCase("top")))p.addRule(RelativeLayout.ALIGN_TOP,RelativeLayout.TRUE);
					else if ((parentCss.textAlign.equalsIgnoreCase("left")))
						p.addRule(RelativeLayout.ALIGN_LEFT,
								RelativeLayout.TRUE);
					else if ((parentCss.textAlign.equalsIgnoreCase("right")))
						p.addRule(RelativeLayout.ALIGN_RIGHT,
								RelativeLayout.TRUE);
					// else if(
					// (css.textAlign.equalsIgnoreCase("bottom")))p.addRule(RelativeLayout.ALIGN_BOTTOM,RelativeLayout.TRUE);
				}
				else
				{
					//default is center
					p.addRule(RelativeLayout.CENTER_HORIZONTAL,
							RelativeLayout.TRUE);
				}
				if (parentCss.verticalAlign != null)
				{
					if ((parentCss.verticalAlign.equalsIgnoreCase("middle") || (css.verticalAlign
							.equalsIgnoreCase("center"))))
						p.addRule(RelativeLayout.CENTER_VERTICAL,
								RelativeLayout.TRUE);
					else if (parentCss.verticalAlign.equalsIgnoreCase("top"))
						p.addRule(RelativeLayout.ALIGN_TOP, RelativeLayout.TRUE);
					else if (parentCss.verticalAlign.equalsIgnoreCase("bottom"))
						p.addRule(RelativeLayout.ALIGN_BOTTOM,
								RelativeLayout.TRUE);
				}
				else
				{
					//default is middle
					p.addRule(RelativeLayout.CENTER_VERTICAL,RelativeLayout.TRUE);
				}
			}
			// table
			else if (this.getRoot().getNodeName().equalsIgnoreCase("TABLE"))
			{
				param = new MarginLayoutParams(MarginLayoutParams.WRAP_CONTENT,
						MarginLayoutParams.WRAP_CONTENT);
			}

			// table row
			else if (getParent().getRoot().getNodeName().equalsIgnoreCase("TR"))
			{
				TableRow.LayoutParams p = new TableRow.LayoutParams(
						TableRow.LayoutParams.WRAP_CONTENT,
						TableRow.LayoutParams.WRAP_CONTENT);
				param = p;
			} else if (getParent().getView() instanceof LinearLayout)
			{
				LinearLayout.LayoutParams p = new LinearLayout.LayoutParams(
						MarginLayoutParams.WRAP_CONTENT,
						MarginLayoutParams.WRAP_CONTENT);

				if (css.bounds.weight > 0)
				{
					p.weight = css.bounds.weight;
				}
				param = p;
			} else if (getParent().getView() instanceof FrameLayout)
			{
				FrameLayout.LayoutParams p = new FrameLayout.LayoutParams(
						MarginLayoutParams.WRAP_CONTENT,
						MarginLayoutParams.WRAP_CONTENT);
				param = p;
			}

			else
				param = new MarginLayoutParams(MarginLayoutParams.WRAP_CONTENT,
						MarginLayoutParams.WRAP_CONTENT);
		}
		if (param == null)
			return;

		// if (css.weight>0 &&
		// (parent.getRoot().getNodeName().equalsIgnoreCase("TR"))) {
		// System.out.println("this "+this.id+", weight="+css.weight);
		// TableRow.LayoutParams p=((TableRow.LayoutParams)param);
		// p.weight=css.weight;
		//
		// }
		//
		// else
		if (css.bounds.weight > 0 && param instanceof LinearLayout.LayoutParams)
		{
			((LinearLayout.LayoutParams) param).weight = css.bounds.weight;
		}

		// param.= Gravity.LEFT | Gravity.TOP;
		// String name = root.getNodeName();

		if ((attr = css.getStyleValue("background-color")) != null)
		{
			this.setBackgroundColor(attr);
		}
		
		this.setBorder();
		
//		System.out.println("css.color=" + css.color);
		if (css.color != 0)
//		if ((attr = css.getStyleValue("color")) != null)
			this.setColor(css.color);

		// System.out.println("background-image=" + css.getStyleValue("background-image"));
		if ((attr = css.getStyleValue("background-image")) != null)
		{
			setBackgroundImageUrl(CSS.parseImageUrl(attr));
		}
		// set position attributes
		// System.out.println("top=" + css.getStyleValue("top"));
		if ((attr = css.getStyleValue("top")) != null)
		{
			this.setTop(CSS.parseInt(attr));
		}
		// System.out.println("left=" + css.getStyleValue("left"));
		if ((attr = css.getStyleValue("left")) != null)
		{
			this.setLeft(CSS.parseInt(attr));
		}
		// System.out.println("width=" + css.getStyleValue("width"));
		if ((attr = css.getStyleValue("width")) != null)
		{
			if (attr.equals("auto"))
			{
				param.width = LayoutParams.MATCH_PARENT;
			} else
				this.setWidth(CSS.parseInt(attr));
		}

		// System.out.println("height=" + css.getStyleValue("height"));
		if ((attr = css.getStyleValue("height")) != null)
		{
			if (attr.equals("auto"))
			{
				param.height = LayoutParams.MATCH_PARENT;
			} else
				this.setHeight(CSS.parseInt(attr));
		}

		// System.out.println("visibility=" + css.getStyleValue("visibility"));
		if ((attr = css.getStyleValue("visibility")) != null)
		{
			setVisibility(css.visibility);
		}
		// System.out.println("alpha=" + css.getStyleValue("alpha"));
		// System.out.println("css alpha=" + css.alpha);
		if ((attr = css.getStyleValue("alpha")) != null)
		{
			this.setAlpha(css.alpha);
		}
		// System.out.println("text=" + css.getStyleValue("text"));
		if ((attr = css.getStyleValue("text")) != null)
		{
			this.setText(attr);
		}

		param.setMargins(css.margin.left, css.margin.top, css.margin.right,
				css.margin.bottom);
		
		
		//add border's width as padding, or the children will be painted on the border
		v.setPadding(css.padding.left+css.border.width, 
				css.padding.top+css.border.width, 
				css.padding.right+css.border.width,
				css.padding.bottom+css.border.width);
		
		this.setFont();
		
		
		String text = root.getTextContent();
		if (text != null && !text.trim().equals(""))
			this.setText(text);

		v.setLayoutParams(param);

		v.requestLayout();
	}

	// private void parseChildren(Node root) {
	// NodeList nl = root.getChildNodes();
	// for (int i = 0; i < nl.getLength(); i++) {
	// Node n = nl.item(i);
	// if (n != null && n.getNodeType() == Node.ELEMENT_NODE) {
	// }
	// }
	// }
	
	public static  Handler mHandler = new Handler(){  
        public void handleMessage(Message msg){  
        	
        	LuaContext.getInstance().doString((String)msg.obj);
//        	int i=((Integer)msg.obj).intValue();
//        	LuaContext.getInstance().doString("ProgressBar:setValue("+i+")");
//        	LuaContext.getInstance().doString("test_text:setText('"+i+"%')");
        }  
    };  
    private class Monitor extends AsyncTask<String, Integer, String> {
    	
    	@Override
		protected void onPostExecute(String result) {
			System.out.println("wedgit.onPostExecute");
					
		}
		@Override
		protected String doInBackground(String... params)
		{
			System.out.println("wedgit.doInBackground="+params[0]);
			LuaContext.getInstance().doString(params[0]);
			return "";
		}
    }
//    private class EventThread implements Runnable
//	{
//    	String event;
//    	public EventThread(String event)
//    	{
//    		this.event=event;
//    	}
//		@Override
//		public void run() {
//			Looper.prepare();
//			LuaContext.getInstance().doString(event);
//			Looper.loop();
//		}
//
//		
//	}
//    public int i;
////    Handler mHandler1 = new Handler();
//    Runnable mRunnable = new Runnable() {
//    	
//
//        @Override
//        public void run() {
//            //mTextView.setText("haha");
//        	//LuaContext.getInstance().doString(onclick);
//        	LuaContext.getInstance().doString("ProgressBar:setValue("+i+")");
//        	LuaContext.getInstance().doString("test_text:setText('"+i+"%')");
//        
//        }
//    };

    public void setOnclick(String onclick)
    {
    	this.onclick=onclick;
    }
    public void setPressed(String pressed)
    {
    	this.pressed=pressed;
    }
    public void setReleased(String released)
    {
    	this.released=released;
    }
    
	protected void clicked()
	{
		if (threadClick != null)
		{
			System.out.println("IWedgit is clicked, lua function=" + onclick);
			//LuaContext.getInstance().doString(onclick);
			new Thread() {
                public void run() {
                	boolean running=true;
                	while(running)
                	{
                		try{
//                		LuaContext.getInstance().doString(onclick);
                		int start=threadClick.indexOf('(');
                		int end=threadClick.indexOf(')');
                		String method=threadClick.substring(0,start);
                		String paramstr=threadClick.substring(start+1,end);
                		String[] params;
                		if(paramstr.trim().equals(""))params=new String[0];
                		else params=paramstr.split(",");
                		
                		LuaState lua=LuaContext.getInstance().getLuaState();
                		lua.getField(LuaState.LUA_GLOBALSINDEX, method);
                		 
                		 for(int j=0;j<params.length;j++)
                		 {
                			 String p=params[j].trim();
                			 if(p.startsWith("'") || p.startsWith("\"")) lua.pushString(p);
                			 else if(p.charAt(0)>='0' && p.charAt(0)<='9') lua.pushNumber(Integer.parseInt(p));
                			 else lua.pushJavaObject(p);
                				 
                		 }
                		 lua.call(params.length,1);
                		// save returned value to param "result"   
                	        lua.setField(LuaState.LUA_GLOBALSINDEX, "result");   
                	         
                	        // read result
                	        LuaObject lobj =lua.getLuaObject("result");   
                	        boolean isBreak=lobj.getBoolean();
                	        if(isBreak)break;
                		}catch(Exception e)
                		{
                			e.printStackTrace();
                		}
                	      
                	try
        			{
        				Thread.sleep(100);
        			} catch (InterruptedException e)
        			{
        				// TODO Auto-generated catch block
        				e.printStackTrace();
        			}
                	}
                }
            }.start();
            System.out.println(" end IWedgit  clicked");
		}
		
		if (this.ansyClick != null)
		{
			System.out.println("IWedgit is ansyClick,lua function=" + onclick);
//			LuaContext.getInstance().doString(onclick);
			Monitor m=new Monitor();
			m.execute(ansyClick);
			// lua.LdoString(onclick);
//			Message msg = new Message();  
//	        //msg.what = STOP;  
//			msg.obj=onclick;
//	        mHandler.sendMessage(msg); 
			
			//putting in thread with Looper is in order to suit Ansy progress and UI creation(Img download Ansytask),sine Ansytask cannot invoke another Ansytask
//			EventThread et= new EventThread(onclick);
//			Thread t=new Thread(et);
//			t.start();
		}
		if (this.handlerClick != null)
		{
			System.out.println("IWedgit is handlerClick,lua function=" + onclick);
			Message msg = new Message();  
	        //msg.what = STOP;  
			msg.obj=handlerClick;
	        mHandler.sendMessage(msg); 
		}
		
		if (this.onclick != null)
		{
			LuaContext.getInstance().doString(onclick);
		}
	}

	protected void pressed()
	{
		// System.out.println("IWedgit is pressed,lua function=" + pressed);
		if (pressed != null)
		{
			LuaContext.getInstance().doString(pressed);
		}
	}

	protected void released()
	{
		if (released != null)
		{
			LuaContext.getInstance().doString(released);
		}
	}

	public void setText(String text)
	{
		if (v instanceof TextView)
		{
			text = text.replaceAll("\\\\n", "\n");
			text = text.replaceAll("\\\\\n", "\\\\n");
			text=text.replaceAll("\n", "<br>");
//			text=text.replaceAll("\\\\\n", "\\\\n");
//			btn.setText(text);
//			btn.requestLayout();
			CharSequence charSequence = Html.fromHtml(text);
       
			TextView t=(TextView) v;
			((TextView) v).setText(text);
			t.setText(charSequence);
		    t.setMovementMethod(LinkMovementMethod.getInstance());//点击时产生超
			t.requestLayout();
			v.refreshDrawableState();
		}
	}


	public String getText()
	{
		if (v instanceof TextView)
			return ((TextView) v).getText().toString();
		else
			return null;
	}

	public int getWidth()
	{
		return css.bounds.width;
	}

	public void setWidth(int width)
	{
		param.width =(int) (width*Main.scale);
		css.bounds.width = width;
	}

	public int getHeight()
	{
		return v.getHeight();
		//return css.bounds.height;
	}

	public void setHeight(int height)
	{
		param.height = (int) (height*Main.scale);;
		css.bounds.height = height;
	}

	public int getBackgroundColor()
	{

		return css.backgroundColor;
	}

	public void setBackgroundColor(String backgroundColor)
	{
//		System.out.println("back-color="+backgroundColor);
		int bg = CSS.parseColor(backgroundColor);
		setBackgroundColor(bg);
	}

	public void setBackgroundColor(int backgroundColor)
	{
//		System.out.println("back-color="+backgroundColor);
		v.setBackgroundColor(backgroundColor);
		css.backgroundColor = backgroundColor;
	}

	public int getColor()
	{
		return css.color;
	}

	public void setColor(String color)
	{
		int c = CSS.parseColor(color);
		setColor(c);

	}

	public void setColor(int color)
	{
		css.color = color;
		if (v instanceof TextView)
			((TextView) v).setTextColor(color);
	}

	public void setVisibility(boolean visibile)
	{
		if (visibile)
			v.setVisibility(View.VISIBLE);
		else
			v.setVisibility(View.GONE);
	}

	public void setVisibility(String value)
	{
		css.visibility = value;
		if (value.equalsIgnoreCase("block"))
		{
			v.setVisibility(View.GONE);
		} else if (value.equalsIgnoreCase("hidden"))
		{
			v.setVisibility(View.INVISIBLE);
		} else
		{
			v.setVisibility(View.VISIBLE);
		}

	}

	public void setAlpha(float alpha)
	{
		try
		{
			v.getBackground().setAlpha((int) (alpha * 255));
		} catch (Exception e)
		{
			e.printStackTrace();
		}
	}
	
	public void setFont(String s)
	{
		css.font.setFont(s);
		setFont();
	}
	private void setFont()
	{
		if (v instanceof TextView)
		{
			Typeface tf=Typeface.create(css.font.family, css.font.style);
			
			TextView t=((TextView) v);
			if(css.font.size>0)t.setTextSize(css.font.size);
			t.setTypeface(tf);
		}
	}
	public void setBorder(String s)
	{
		css.border.setBorder(s);
		setBorder();
		
	}
	private void setBorder()
	{
		if(css.border.width>0)
		{
		IBorder b=new IBorder(this.getBackgroundColor(),css.border.color,(int)(css.border.width*Main.scale),(int)(css.border.radius*Main.scale));
		v.setBackground(b);
		}
	}
	
	public String getBackgroundImageUrl()
	{
		return css.backgroundImageURL;
	}

	public void setBackgroundImageUrl(String backgroundImageUrl)
	{
		setBackgroundImageUrl(backgroundImageUrl,null);
	}
	/**
	 * for that  URLs which need cookies/logon status
	 * @param backgroundImageUrl
	 * @param cookies
	 */
	public void setBackgroundImageUrl(String backgroundImageUrl,String cookies)
	{
		// v.setBackground( new
		// BitmapDrawable(returnBitMap(backgroundImageURL)));
		// BitmapDrawable bd=new
		// BitmapDrawable(returnBitMap(backgroundImageURL));
		backgroundImageUrl=backgroundImageUrl.trim();
		String base="";
//		if(PortalProperties.getInstance().getAppProperties()!=null)base=PortalProperties.getInstance().getAppProperties().getAppBase();
//		else base=PortalProperties.getInstance().getAppBase();
		base=OLA.appBase;
		String bgImageURL;
		if(backgroundImageUrl.startsWith("file://"))
		{
			bgImageURL=backgroundImageUrl.substring(7);
		}
		else if(backgroundImageUrl.startsWith("http://"))
		{
			bgImageURL=backgroundImageUrl;
		}
		else
		{
			//is it started with the Root path
			if(backgroundImageUrl.startsWith("$/"))
			{
				bgImageURL= OLA.base + backgroundImageUrl.substring(1);
			}
			else
			{
				bgImageURL= base + backgroundImageUrl;
			}
		}
		System.out.println(bgImageURL);
		try{
		if (bgImageURL.startsWith("http://"))
		{
			DownloadImage task = new DownloadImage();
			task.execute(bgImageURL,cookies);
			
		} else
		{
//			Bitmap img=getImageFromAssetsFile(backgroundImageURL);
//			v.setBackgroundDrawable(new BitmapDrawable(img));
//			//img.recycle();
//			img=null;
		
			InputStream is = new FileInputStream(bgImageURL);
			Drawable drawable=Drawable.createFromStream(is, null);

			v.setBackground(drawable);
			is.close();
		}
		}catch(Exception e)
		{
			e.printStackTrace();
		}


		System.gc();
		css.backgroundImageURL = bgImageURL;
	}

	public static PictureDrawable getcontentPic(String imageUri)
	{
		URL imgUrl = null;
		try
		{
			imgUrl = new URL(imageUri);
		} catch (MalformedURLException e1)
		{
			e1.printStackTrace();
		}
		System.out.println(imageUri);
		PictureDrawable icon = null;
		try
		{
			HttpURLConnection hp = (HttpURLConnection) imgUrl.openConnection();
			
			icon = new PictureDrawable(Picture.createFromStream(hp.getInputStream()));// ��������ת����bitmap
			hp.disconnect();// �ر�����
		} catch (Exception e)
		{
			e.printStackTrace();
		}
		return icon;
	}

	public static Bitmap returnBitMap(String url)
	{

		URL myFileUrl = null;
		Bitmap bitmap = null;

		try
		{
			myFileUrl = new URL(url);
			HttpURLConnection conn = (HttpURLConnection) myFileUrl
					.openConnection();
//			conn.setDoInput(true);
//			conn.connect();
			InputStream is = conn.getInputStream();
			Options opts = new Options(); 
			opts.inSampleSize = 4;
			opts.inPreferredConfig = Config.ARGB_4444;
			bitmap = BitmapFactory.decodeStream(is, null, opts);
			is.close();
			conn.disconnect();
			
		} catch (IOException e)
		{
			e.printStackTrace();
		}
		return bitmap;
	}
	
	public static Drawable returnDrawable(String url,String cookies)
	{

		URL myFileUrl = null;
		Drawable drawable = null;

		try
		{
			myFileUrl = new URL(url);
			HttpURLConnection conn = (HttpURLConnection) myFileUrl.openConnection();
			if(cookies!=null && !cookies.trim().equals(""))
			{
				conn.setRequestProperty("Cookie",cookies);
			}
//			conn.setDoInput(true);
//			conn.connect();
			InputStream is = conn.getInputStream();
			drawable=Drawable.createFromStream(is, null);
			is.close();
			conn.disconnect();
			
		} catch (IOException e)
		{
			e.printStackTrace();
		}
		return drawable;
	}

	private Bitmap getImageFromAssetsFile(String fileName)
	{
		Bitmap image = null;
		//AssetManager am = context.getResources().getAssets();
//		try
//		{
			//InputStream is = am.open(fileName);
			Options opts = new Options(); 
			opts.inSampleSize = 4;
			image = BitmapFactory.decodeFile(fileName);
			//is.close();
//		} catch (IOException e)
//		{
//			e.printStackTrace();
//		}

		return image;

	}

	private class DownloadImage extends AsyncTask<String, Integer, Drawable>
	{

		protected Drawable doInBackground(String... urls)
		{
			Drawable image = null;
			// backgroundImageURL = url;
			String cookies=null;
			try
			{
				
				cookies=urls[1];
				image = returnDrawable(urls[0],cookies);
			} catch (Exception e1)
			{
				e1.printStackTrace();
			} finally
			{

			}
			return image;

		}

		protected void onProgressUpdate(Integer... progress)
		{

		}

		protected void onPostExecute(Drawable result)
		{
			//BitmapDrawable db=new BitmapDrawable(result);
			v.setBackground(result);
//			v.setBackground(null);
//			result.recycle();
			result=null;
			
			
		}

	}
	
	public static  Handler mListenerHandler = new Handler(){  
        public void handleMessage(Message msg){  
        	ListenerHandler lh=(ListenerHandler)msg.obj;
			lh.wedgit.gesture = new GestureDetector(lh.ctx,lh.ig);
			lh.view.setLongClickable(true);
			lh.view.setOnTouchListener(lh.listener);
        }  
    }; 
    class ListenerHandler
    {
    	IWedgit wedgit;
    	Context ctx;
    	View view;
    	IGestureListener ig;
    	ButtonListener listener;
    }
	protected void addListner()
	{
		// TODO changed to Handler
		
		if (!(this instanceof ITextField))
		{
			IGestureListener ig=new IGestureListener(context);
			ButtonListener listener = new ButtonListener();
			ListenerHandler lh=new ListenerHandler();
			lh.wedgit=this;
			lh.ctx=context;
			lh.view=v;
			lh.ig=ig;
			lh.listener=listener;
			Message msg = new Message();  
			msg.obj=lh;
			mListenerHandler.sendMessage(msg);

			
//			new Thread()
//			{
//				public void run()
//				{
			//Looper will display cannot create weak pipe Error when reload several times later
//					Looper.prepare();
			
//					IGestureListener ig=new IGestureListener(context);
//					gesture = new GestureDetector(context,ig);
//					v.setLongClickable(true);
//					ButtonListener listener = new ButtonListener();
					// v.setOnClickListener(listener);
//					v.setOnTouchListener(listener);
//					Looper.loop();

//				}
//
//			}.start();
		}

		// btn.setOnClickListener(new View.OnClickListener() {

		// public void onClick(View v) {
		//
		// // LuaObject lo=lua.getLuaObject("btn2");
		// // System.out.println(lo);
		// // try {
		// // LuaObject f=lo.getField("onClick");
		// //
		// //// Object[] o=new Object[1];
		// //// o[0]="32";
		// //// f.call(o);
		// // f.call(null);
		// // } catch (LuaException e) {
		// // e.printStackTrace();
		// // }
		// //lua.LdoString("btn2:Buttontest()");//ִ��һ���޲��ຯ��
		//
		// // lua.getField(LuaState.LUA_GLOBALSINDEX, onclick);
		// // lua.call(0,0);
		// clicked();
		//
		// }

		// }
		// );
	}

	/*
	 * l onClick(View v) һ����ͨ�ĵ����ť�¼�
	 * 
	 * l boolean onKeyMultiple(int keyCode,int repeatCount,KeyEvent
	 * event)�����ڶ���¼�����ʱ�������ڰ����ظ�����������@Overrideʵ��
	 * 
	 * l boolean onKeyDown(int keyCode,KeyEvent event) �����ڰ�����а���ʱ����
	 * 
	 * l boolean onKeyUp(int keyCode,KeyEvent event�� �����ڰ�������ͷ�ʱ����
	 * 
	 * l onTouchEvent(MotionEvent event)�������¼������ڴ��������ж���ʱ����
	 * 
	 * l boolean onKeyLongPress(int keyCode, KeyEvent event)���㳤ʱ�䰴ʱ�������ʣ���
	 */

	class ButtonListener implements OnClickListener, OnTouchListener
	{

		public void onClick(View v)
		{
			System.out.println("onClick");
			// clicked();
		}

		@Override
		public boolean onTouch(View v, MotionEvent event)
		{
			// System.out.println("event.getAction() ="+event.getAction());
			// return gesture.onTouchEvent(event);

			if (event.getAction() == MotionEvent.ACTION_UP)
			{
				System.out.println("onrelease");
				released();
				// return false;

			} else if (event.getAction() == MotionEvent.ACTION_CANCEL)
			{
				System.out.println("oncancel");
				released();
				// return false;
			}

			else if (event.getAction() == MotionEvent.ACTION_MOVE)
			{

				// return false;
			}
			/*
			 * else if (event.getAction() == MotionEvent.ACTION_DOWN) {
			 * System.out.println("onpress"); pressed(); //return false; }
			 */

			// released();
			return gesture.onTouchEvent(event);

		}

	}

	class IGestureListener extends SimpleOnGestureListener
	{
		private static final int SWIPE_MIN_DISTANCE = 120;
		private static final int SWIPE_MAX_OFF_PATH = 250;
		private static final int SWIPE_THRESHOLD_VELOCITY = 200;

		public IGestureListener(Context ctx)
		{
			/*--click
			 * ondown
			 * onrelease
			 * onSingleTapUp
			 * onSingleTapConfirmed
			 */

			/*
			 * --onDoubleTap ondown onrelease onSingleTapUp onDoubleTap
			 * onDoubleTapEvent ondown onrelease onDoubleTapEvent
			 */
			/*
			 * --onLongPress onDown onSHowPress on long press onrelease
			 */

		}

		// 双击，手指在触摸屏上迅速点击第二下时触发
		@Override
		public boolean onDoubleTap(MotionEvent e)
		{
			// TODO Auto-generated method stub
			System.out.println("onDoubleTap");
			return super.onDoubleTap(e);
		}

		// 短按，触摸屏按下后片刻后抬起，会触发这个手势，如果迅速抬起则不会
		public void onShowPress(android.view.MotionEvent e)
		{
			System.out.println("onShowPress:id=" + objId);
			// need to be put into Handler, or an error will be throw out: UI
			// must be updated in the main thread(from Ibutton's code:
			// drawable1.clearColorFilter();)
			// released();

		}

		// 双击的按下跟抬起各触发一次
		public boolean onDoubleTapEvent(android.view.MotionEvent e)
		{
			System.out.println("onDoubleTapEvent");
			return false;
		}

		// 单击，触摸屏按下时立刻触发
		@Override
		public boolean onDown(MotionEvent e)
		{
			System.out.println("onDown");
			pressed();
			return false;
		}

		// 抬起，手指离开触摸屏时触发(长按、滚动、滑动时，不会触发这个手势
		@Override
		public boolean onSingleTapUp(MotionEvent e)
		{
			System.out.println("onSingleTapUp");
			clicked();
			return false;
		}

		// 单击确认，即很快的按下并抬起，但并不连续点击第二下
		public boolean onSingleTapConfirmed(android.view.MotionEvent e)
		{
			System.out.println("onSingleTapConfirmed");
			return false;
		}

		@Override
		public void onLongPress(MotionEvent e)
		{
			System.out.println("on long press...");
		}

		/**
		 * after long pressed, only the Move(Drag)action is trigged
		 * 
		 * @param e
		 */
		public void onMove(MotionEvent e)
		{
			System.out.println("on Drag");
			// not implemented
		}

		// 滑动，触摸屏按下后快速移动并抬起，会先触发滚动手势，跟着触发一个滑动手势
		@Override
		public boolean onFling(MotionEvent e1, MotionEvent e2, float velocityX,
				float velocityY)
		{
			System.out.println("on fling:id=" + objId);
			return swipe(e1, e2);
			// return false;
		}

		@Override
		public boolean onScroll(MotionEvent e1, MotionEvent e2,
				float distanceX, float distanceY)
		{
			System.out.println("on scroll:id=" + objId);
			return false;
		}

		private boolean swipe(MotionEvent e1, MotionEvent e2)
		{
			System.out.println("e1=" + e1);
			System.out.println("e2=" + e2);
			if (e1 == null || e2 == null)
				return false;
			if (e1.getX() - e2.getX() > this.SWIPE_MIN_DISTANCE)// &&
																// Math.abs(velocityY)
																// <
																// this.SWIPE_THRESHOLD_VELOCITY)
			{
				LuaContext.getInstance().doString("swipe(1)");
				System.out.println("left........");
			} else if (e2.getX() - e1.getX() > this.SWIPE_MIN_DISTANCE)// &&
																		// Math.abs(velocityY)
																		// <
																		// this.SWIPE_THRESHOLD_VELOCITY)
			{
				LuaContext.getInstance().doString("swipe(2)");
				System.out.println("right........");
			} else if (e1.getY() - e2.getY() > this.SWIPE_MIN_DISTANCE)// &&
																		// Math.abs(velocityX)
																		// <
																		// this.SWIPE_THRESHOLD_VELOCITY)
			{
				LuaContext.getInstance().doString("swipe(4)");
				System.out.println("bottom........");
			} else if (e2.getY() - e1.getY() > this.SWIPE_MIN_DISTANCE)// &&
																		// Math.abs(velocityX)
																		// <
																		// this.SWIPE_THRESHOLD_VELOCITY)
			{
				LuaContext.getInstance().doString("swipe(3)");
				System.out.println("top........");
			}

			return true;
		}
	}

	@Override
	public View getView()
	{
		return v;
	}

	public Node getRoot()
	{
		return this.root;
	}

	public int getTop()
	{
		return css.bounds.top;
	}

	public void setTop(int top)
	{
		param.topMargin = top;
		css.margin.top = top;
	}

	public int getLeft()
	{
		return css.bounds.left;
	}

	public void setLeft(int left)
	{
		param.leftMargin = left;
		css.margin.left = left;
	}

	public MarginLayoutParams getLayoutParams()
	{
		return this.param;
	}

	@Override
	public CSS getCss()
	{
		return css;
	}

	public IView getParent()
	{
		return parent;
	}

	public void setParent(IView parent)
	{
		// clear the param while the view has no a previous parent
		// if(this.parent==null)
		param = null;
		this.parent = parent;
//		System.out.println("parent=" + parent);
		// rebuild the properties which will be related to the current parent.
		this.parseCSS();

	}
	String getId()
	{
		return objId;
	}

}
