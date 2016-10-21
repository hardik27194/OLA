package com.lohool.ola.wedgit;

import org.w3c.dom.*;

import android.annotation.SuppressLint;
import android.content.Context;


//Layout
@SuppressLint("NewApi")
public abstract class Layout extends IContainer
{

	int[] bounds;
	/*
	int width;
	int height;
	int top;
	int left;
	int backgroundColor;
	int color;
	*/
	String layout="FrameLayout";
	
//	LuaState lua;
//	String backgroundImageURL;
	
//	String clickFun;
	
//	ViewGroup v;
//	MarginLayoutParams param;
//	
//	Context context;
//	Node root;
//	CSS css;
	
	
	protected Layout(Context context) {
		//super(context);
		super(null,context,null);
		
//		addListner();
		
	}
	
	protected Layout(IView parent,Context context,Node root) {
		super(parent, context,  root);

		this.context=context;

		this.root=root;
//		parseLayout();
//		super.init();
//		parseLayoutAttr();
		
		
		//initiate();
//		addListner();
		
	}
	//public abstract void createView();
	public static Layout createLayout(IView parent,Context context, Node root)
	{
		String name=root.getNodeName();
    	//System.out.println("Tag name="+name);
		String layoutName=((Element)root).getAttribute("layout");
		//System.out.println("layout name ="+layoutName);
		
		Layout v=null;
		if(layoutName.equalsIgnoreCase("FrameLayout"))
		{
			v=new IFrameLayout(parent, context,root);
		}
		else if(layoutName.equalsIgnoreCase("LinearLayout"))
		{
			v=new ILinearLayout(parent, context,  root);
		}
		else if(layoutName.equalsIgnoreCase("RelativeLayout"))
		{
			v=new IRelativeLayout(parent, context,  root);
			
		}
		else if(layoutName.equalsIgnoreCase("WebView"))
		{
			v=new IWebView(parent, context,  root);
			
		}
		return v;
	}
	
/*
	private void initiate()
	{
		int a=0,b=0;
		
		if (css.textAlign != null) {
			if ((css.textAlign.equalsIgnoreCase("center")))
				{
				a=Gravity.CENTER_HORIZONTAL;
				}
			else if ((css.textAlign.equalsIgnoreCase("left")))a=Gravity.LEFT;
			else if ((css.textAlign.equalsIgnoreCase("right")))a=Gravity.RIGHT;
		}
		if (css.verticalAlign != null) {
			if ((css.verticalAlign.equalsIgnoreCase("middle") || (css.verticalAlign.equalsIgnoreCase("center"))))
			{
				b=Gravity.CENTER_VERTICAL;
			}
			else if (css.verticalAlign.equalsIgnoreCase("top"))b=Gravity.TOP;
			else if (css.verticalAlign.equalsIgnoreCase("bottom"))b=Gravity.BOTTOM;
		}
		
		String layoutName=((Element)root).getAttribute("layout");
		if(layoutName.equalsIgnoreCase("FrameLayout"))
		{

		}
		else if(layoutName.equalsIgnoreCase("LinearLayout"))
		{
			LinearLayout t=(LinearLayout)v;
			if(a==Gravity.CENTER_HORIZONTAL && b==Gravity.CENTER_VERTICAL)t.setGravity(Gravity.CENTER);
			else t.setGravity(a|b);
		}
		else if(layoutName.equalsIgnoreCase("RelativeLayout"))
		{
			RelativeLayout t=new RelativeLayout(context);
			if(a==Gravity.CENTER_HORIZONTAL && b==Gravity.CENTER_VERTICAL)t.setGravity(Gravity.CENTER);
			else t.setGravity(a|b);
			
		}
		
		

	}
	
	void parseLayout()
	{
		String name=root.getNodeName();
    	System.out.println("Tag name="+name);
		String layoutName=((Element)root).getAttribute("layout");
		System.out.println("layout name ="+layoutName);
		
		
		if(layoutName.equalsIgnoreCase("FrameLayout"))
		{
			v=new FrameLayout(context);
		}
		else if(layoutName.equalsIgnoreCase("LinearLayout"))
		{
			v=new LinearLayout(context);
		}
		else if(layoutName.equalsIgnoreCase("RelativeLayout"))
		{
			v=new RelativeLayout(context);
			
		}

	}
	void parseLayoutAttr()
	{
		String name=root.getNodeName();

		String layoutName=((Element)root).getAttribute("layout");

		if(layoutName.equalsIgnoreCase("FrameLayout"))
		{
			
		}
		else if(layoutName.equalsIgnoreCase("LinearLayout"))
		{
			LinearLayout l=(LinearLayout)v;
			if(css.orientation!=null && css.orientation.equals("vertical"))
				l.setOrientation(LinearLayout.VERTICAL);
			else
				l.setOrientation(LinearLayout.HORIZONTAL);

		}
		else if(layoutName.equalsIgnoreCase("RelativeLayout"))
		{
			
			
		}
	}
	*/
	

//	public void addView(IView child)
//	{
//		v.addView(child);
//	}
	
	
//	public void onClick()
//	{
//		System.out.println("Div is clicked");
//		if(clickFun!=null)
//		lua.LdoString(clickFun);
//	}
//	private void clicked()
//	{
//		onClick();
//	}
//	private void addListner()
//	{
//		v.setOnClickListener(new View.OnClickListener() {
//   		 
//            public void onClick(View v) {
//    
////           	 LuaObject lo=lua.getLuaObject("btn2");
////           	 System.out.println(lo);
////           	 try {
////					LuaObject f=lo.getField("onClick");
////					
//////					Object[] o=new Object[1];
//////					o[0]="32";
//////					f.call(o);
////					f.call(null);
////				} catch (LuaException e) {
////					// TODO Auto-generated catch block
////					e.printStackTrace();
////				}
//           	 //lua.LdoString("btn2:Buttontest()");//ִ��һ���޲��ຯ��
//           	 
////           	 lua.getField(LuaState.LUA_GLOBALSINDEX, onclick);
////           	 lua.call(0,0);
//            	clicked();
//    
//            }
//    
//        }
//   	);
//	}
//	
//	public int[] getBounds() {
//		return bounds;
//	}
//
//	public void setBounds(int[] bounds) {
//		this.bounds = bounds;
//	}

	/*
	public int getWidth() {
		return width;
	}

	public void setWidth(int width) {
		
		param.width=width;
		this.width = width;
	}

	public int getHeight() {
		
		return height;
	}

	public void setHeight(int height) {
		param.height=height;
		this.height = height;
	}
	int getTop() {
		return top;
	}
	void setTop(int top) {
		param.topMargin=top;
		this.top = top;
	}
	int getLeft() {
		return left;
	}
	void setLeft(int left) {
		param.leftMargin=left;
		this.left = left;
	}
	public int getBackgroundColor() {
		
		return backgroundColor;
	}

	public void setBackgroundColor(int backgroundColor) {
		
		v.setBackgroundColor(backgroundColor);
		
		this.backgroundColor = backgroundColor;
	}

	public int getColor() {
		return color;
	}

	public void setColor(int color) {
		this.color = color;
	}

	public String getBackgroundImageUrl() {
		return backgroundImageURL;
	}

	public void setBackgroundImageUrl(String backgroundImageURL) {
		//v.setBackground( new BitmapDrawable(returnBitMap(backgroundImageURL)));
		//v.setBackgroundDrawable(BitmapDrawable.createFromPath(backgroundImageURL));
		v.setBackgroundDrawable( new BitmapDrawable(returnBitMap(backgroundImageURL)));
		this.backgroundImageURL = backgroundImageURL;
	}

	
	public static PictureDrawable getcontentPic(String imageUri) {  
	    URL imgUrl = null;  
	    try {  
	        imgUrl = new URL(imageUri);  
	    } catch (MalformedURLException e1) {  
	        e1.printStackTrace();  
	    }  
	    System.out.println(imageUri);
	    PictureDrawable icon = null;  
	    try {  
	        HttpURLConnection hp = (HttpURLConnection) imgUrl.openConnection();  
	        icon = new PictureDrawable( Picture.createFromStream(hp.getInputStream()));// ��������ת����bitmap   
	        hp.disconnect();// �ر�����   
	    } catch (Exception e) {  
	    	e.printStackTrace();
	    }  
	    return icon;  
	}  

	public Bitmap returnBitMap(String url) {    

		 URL myFileUrl = null;    
		 Bitmap bitmap = null;    
		 try {    
		 myFileUrl = new URL(url);    
		 } catch (MalformedURLException e) {    
		 e.printStackTrace();    
		}    

		 try {    
		 HttpURLConnection conn = (HttpURLConnection) myFileUrl    
		  .openConnection();    
		 conn.setDoInput(true);    
		 conn.connect();    
		 InputStream is = conn.getInputStream();    
		 bitmap = BitmapFactory.decodeStream(is);    
		 is.close();    
		} catch (IOException e) {    
		  e.printStackTrace();    
		  }    
		  return bitmap;    
		 }

	@Override
	public CSS getCss() {
		return css;
	}    
*/
}
