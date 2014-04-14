package com.example.anluatest.wedgit;

import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;

import org.w3c.dom.Element;
import org.w3c.dom.Node;

import com.example.anluatest.LMProperties;
import com.example.anluatest.LuaContext;

import android.content.Context;
import android.content.res.AssetManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Picture;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.PictureDrawable;
import android.os.AsyncTask;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;
import android.view.GestureDetector;
import android.view.GestureDetector.SimpleOnGestureListener;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.View.OnTouchListener;
import android.view.ViewGroup.LayoutParams;
import android.view.ViewGroup.MarginLayoutParams;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TableRow;
import android.widget.TextView;

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
	
	
	public IWedgit(IView parent, Context context, Node root)
	{
		this.parent = parent;
		this.context = context;
		this.root = root;

	}

	protected void initiate()
	{
		parseAttribute();
		parseCSS();
		addListner();
	}

	protected void parseAttribute()
	{
		String id = ((Element) root).getAttribute("id");
		if (id != null && !id.equals(""))
		{
			this.objId = id.trim();
			// System.out.println("Create View Item by Id="+id);
			LuaContext.getInstance().regist(this, id);
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
			String cssString = ((Element) root).getAttribute("style");
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
		// param=v.getLayoutParams();
		if (param == null)
		{
			if (getParent() == null)
			{
				// the BODY tag or the created first level layout
				param = new MarginLayoutParams(MarginLayoutParams.WRAP_CONTENT,
						MarginLayoutParams.WRAP_CONTENT);
				// System.out.println("layout 1");
			} else if (getParent().getView() instanceof RelativeLayout)// ((attr=css.getStyleValue("position"))!=null)
			{
				// System.out.println("layout 2");
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
			}
			// table
			else if (this.getRoot().getNodeName().equalsIgnoreCase("TABLE"))
			{
				// System.out.println("layout 3");
				param = new MarginLayoutParams(MarginLayoutParams.WRAP_CONTENT,
						MarginLayoutParams.WRAP_CONTENT);
			}

			// table row
			else if (getParent().getRoot().getNodeName().equalsIgnoreCase("TR"))
			{
				// System.out.println("layout 4");
				TableRow.LayoutParams p = new TableRow.LayoutParams(
						TableRow.LayoutParams.WRAP_CONTENT,
						TableRow.LayoutParams.WRAP_CONTENT);
				param = p;
			} else if (getParent().getView() instanceof LinearLayout)
			{
				// System.out.println("layout 5");
				LinearLayout.LayoutParams p = new LinearLayout.LayoutParams(
						MarginLayoutParams.WRAP_CONTENT,
						MarginLayoutParams.WRAP_CONTENT);
				
				
				if (css.bounds.weight > 0)
				{
					p.weight = css.bounds.weight;
				}
				param = p;
			}

			else
				param = new MarginLayoutParams(MarginLayoutParams.WRAP_CONTENT,
						MarginLayoutParams.WRAP_CONTENT);
			// System.out.println("layout 6");
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

		if (css.color != 0)
			this.setColor(css.color);

		// System.out.println("background-image="
		// + css.getStyleValue("background-image"));
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

		// System.out.println("text=" + css.getStyleValue("text"));
		if ((attr = css.getStyleValue("text")) != null)
		{
			this.setText(attr);
		}

		param.setMargins(css.margin.left, css.margin.top, css.margin.right,
				css.margin.bottom);
		
		v.setPadding(css.padding.left, css.padding.top, css.padding.right, css.padding.bottom);

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

	protected void clicked()
	{
		System.out.println("IWedgit is clicked,lua function=" + onclick);
		if (onclick != null)
		{
			// lua.LdoString(onclick);
			LuaContext.getInstance().doString(onclick);
		}
	}

	protected void pressed()
	{
		System.out.println("IWedgit is pressed,lua function=" + pressed);
		if (pressed != null)
		{
			// lua.LdoString(pressed);
			LuaContext.getInstance().doString(pressed);
		}
	}

	protected void released()
	{
		System.out.println("IWedgit is released,lua function=" + released);
		if (released != null)
		{
			// lua.LdoString(released);
			LuaContext.getInstance().doString(released);
		}
	}
	
	
	protected void addListner()
	{
		//TODO changed to Handler
		new Thread() {
			public void run() { 
				Looper.prepare(); 
				gesture=new GestureDetector(context,new IGestureListener(context));
				v.setLongClickable(true);
				ButtonListener listener = new ButtonListener();
				v.setOnClickListener(listener);
				v.setOnTouchListener(listener);
				Looper.loop(); 

			 }

			 }.start();

				

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

	public void setText(String text)
	{
		if (v instanceof TextView)
		{
			text=text.replaceAll("\\\\n", "\n");
			text=text.replaceAll("\\\\\n", "\\\\n");
			((TextView) v).setText(text);
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

		param.width = width;
		css.bounds.width = width;
	}

	public int getHeight()
	{

		return css.bounds.height;
	}

	public void setHeight(int height)
	{
		param.height = height;
		css.bounds.height = height;
	}

	public int getBackgroundColor()
	{

		return css.backgroundColor;
	}

	public void setBackgroundColor(String backgroundColor)
	{
		int bg = CSS.parseColor(backgroundColor);
		setBackgroundColor(bg);
	}

	public void setBackgroundColor(int backgroundColor)
	{
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

	public void setVisibility(boolean visibility)
	{
		if (visibility)
			v.setVisibility(View.VISIBLE);
		else
			v.setVisibility(View.GONE);
	}

	public String getBackgroundImageUrl()
	{
		return css.backgroundImageURL;
	}

	public void setBackgroundImageUrl(String backgroundImageUrl)
	{
		// v.setBackground( new
		// BitmapDrawable(returnBitMap(backgroundImageURL)));
		// BitmapDrawable bd=new
		// BitmapDrawable(returnBitMap(backgroundImageURL));
		String backgroundImageURL=LMProperties.getInstance().getAppBase()+ backgroundImageUrl;
		if (backgroundImageURL.startsWith("http://"))
		{
			DownloadImage task = new DownloadImage();
			task.execute(backgroundImageURL);
		} else
		{

			v.setBackgroundDrawable(new BitmapDrawable(
					getImageFromAssetsFile(backgroundImageURL)));
		}

		// Bitmap image = null;

		// try {
		// image = task.get();
		// } catch (InterruptedException e) {
		// e.printStackTrace();
		// } catch (ExecutionException e) {
		// e.printStackTrace();
		// }
		// v.setBackgroundDrawable(new BitmapDrawable(image));

		// v.setBackgroundDrawable(new BitmapDrawable(
		// returnBitMap(backgroundImageURL)));
		css.backgroundImageURL = backgroundImageURL;
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
			icon = new PictureDrawable(Picture.createFromStream(hp
					.getInputStream()));// ��������ת����bitmap
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
		} catch (MalformedURLException e)
		{
			e.printStackTrace();
		}

		try
		{
			HttpURLConnection conn = (HttpURLConnection) myFileUrl
					.openConnection();
			conn.setDoInput(true);
			conn.connect();
			InputStream is = conn.getInputStream();
			bitmap = BitmapFactory.decodeStream(is);
			is.close();
		} catch (IOException e)
		{
			e.printStackTrace();
		}
		return bitmap;
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

			Log.d("test", "cansal button ---> click");
			clicked();
		}
		@Override
		public boolean onTouch(View v, MotionEvent event)
		{
			System.out.println("button listener on touch.....");
			if (event.getAction() == MotionEvent.ACTION_UP)
			{
				Log.d("test", "cansal button ---> cancel");
				released();
				//return false;

			}
			if (event.getAction() == MotionEvent.ACTION_DOWN)
			{
				Log.d("test", "cansal button ---> down");
				pressed();
				//return false;
			}
			return gesture.onTouchEvent(event);
		}

	}
	
    class IGestureListener extends SimpleOnGestureListener
	{
		private static final int SWIPE_MIN_DISTANCE=120;
		private static final int SWIPE_MAX_OFF_PATH=250;
		private static final int SWIPE_THRESHOLD_VELOCITY=200;
		
		public IGestureListener(Context ctx) 
		{
		}
		@Override
		public void onLongPress(MotionEvent e)
		{
			System.out.println("on on press...");
		}
		@Override
		public boolean onFling(MotionEvent e1, MotionEvent e2, float velocityX, float velocityY)
		{
			System.out.println("on fling:velocityX="+velocityX+";velocityY="+velocityX);
//			System.out.println("e1="+e1);
//			System.out.println("e2="+e2);
			if(e1==null || e2==null) return false;
			if(e1.getX() - e2.getX() > this.SWIPE_MIN_DISTANCE)// && Math.abs(velocityY) < this.SWIPE_THRESHOLD_VELOCITY)
			{
				LuaContext.getInstance().doString("swipe(1)");
				System.out.println("left........");
			}
			else if(e2.getX() - e1.getX() > this.SWIPE_MIN_DISTANCE)// && Math.abs(velocityY) < this.SWIPE_THRESHOLD_VELOCITY)
			{
				LuaContext.getInstance().doString("swipe(2)");
				System.out.println("right........");
			}
			else if(e1.getY() - e2.getY() > this.SWIPE_MIN_DISTANCE)// && Math.abs(velocityX) < this.SWIPE_THRESHOLD_VELOCITY)
			{
				LuaContext.getInstance().doString("swipe(4)");
				System.out.println("bottom........");
			}
			else if(e2.getY() - e1.getY() > this.SWIPE_MIN_DISTANCE)// && Math.abs(velocityX) < this.SWIPE_THRESHOLD_VELOCITY)
			{
				LuaContext.getInstance().doString("swipe(3)");
				System.out.println("top........");
			}
			
			return false;
		}
		@Override
		public boolean onScroll(MotionEvent e1,MotionEvent e2, float distanceX,float distanceY)
		{
			System.out.println("on scroll...");
			return false;
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

	int getTop()
	{
		return css.bounds.top;
	}

	void setTop(int top)
	{
		param.topMargin = top;
		css.margin.top = top;
	}

	int getLeft()
	{
		return css.bounds.left;
	}

	void setLeft(int left)
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
		System.out.println("parent=" + parent);
		// rebuild the properties which will be related to the current parent.
		this.parseCSS();

	}

	private Bitmap getImageFromAssetsFile(String fileName)
	{
		Bitmap image = null;
		AssetManager am = context.getResources().getAssets();
		try
		{
			InputStream is = am.open(fileName);
			image = BitmapFactory.decodeStream(is);
			is.close();
		} catch (IOException e)
		{
			e.printStackTrace();
		}

		return image;

	}

	private class DownloadImage extends AsyncTask<String, Integer, Bitmap>
	{

		protected Bitmap doInBackground(String... urls)
		{
			Bitmap image = null;
			// backgroundImageURL = url;

			try
			{
				image = returnBitMap(urls[0]);
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

		protected void onPostExecute(Bitmap result)
		{

			v.setBackgroundDrawable(new BitmapDrawable(result));
		}

	}
}
