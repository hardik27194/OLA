package com.lohool.ola.wedgit;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.ConnectException;
import java.net.HttpURLConnection;
import java.net.URL;

import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.w3c.dom.Element;
import org.w3c.dom.Node;

import pl.droidsonroids.gif.GifImageButton;

import com.lohool.ola.HTTP;
import com.lohool.ola.Main;
import com.lohool.ola.OLA;
import com.lohool.ola.UIFactory;
import com.lohool.ola.wedgit.IWedgit.ListenerHandler;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Movie;
import android.graphics.drawable.ClipDrawable;
import android.graphics.drawable.ColorDrawable;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Handler;
import android.os.Message;
import android.util.AttributeSet;
import android.view.GestureDetector;
import android.view.Gravity;
import android.view.View;
import android.webkit.WebView;

public class IGifView  extends IWedgit
{
	String gifFileName;
	MyGifView t;
	public IGifView(IView parent, Context context, Node root,UIFactory ui)
	{
		super(parent, context, root,ui);
		t=new MyGifView(context);
		//t=new GifImageButton(context);
		v=t;
		//super.defaultCSSStyle=defaultStyle;
		super.initiate();
		//t.setGravity(css.getGravity());
		parseMyAttribute();
	}
	
	public void parseMyAttribute()
	{
		String attr;
		
		String src=((Element)root).getAttribute("src");
		if (src != null && !src.trim().equals(""))
		{
			System.out.println("gifview 0:"+src);
			setGifImage(src);			
		}
		
	}
	
	public void setWidth(int width)
	{
		super.setWidth(width);
	}

	public void setHeight(int height)
	{
		super.setHeight(height);
	}

	
	public void setGifImage(String gifName)
	{
		this.gifFileName=gifName.trim();
		t.setImage(gifFileName);
		
		String url=parseUrl(gifName);
		
		System.out.println("gifview 1:"+url);
		Uri uri;
		if(url.startsWith("http://"))
		{
			uri=Uri.parse(url);
		}
		else
		{
			File f=new File(url);
			uri=Uri.fromFile(f);
		}
		
		System.out.println("gifview 2:"+uri);
		//t.setImageURI(uri);
		/*
		
		int w=t.getWidth();
		int h=t.getHeight();
		System.out.println("w=:"+w+";h="+h);
		t.loadData("<img src=\""+url+"\" style=\"width:"+w+"px; height:"+h+"px\" />", "text/html", "UTF-8");
		*/
	}

	public String parseUrl(String bgImageURL)
	{
	String base="";

	base=OLA.appBase;

	if(gifFileName.startsWith("file://"))
	{
		bgImageURL=gifFileName.substring(7);
	}
	else if(gifFileName.startsWith("http://"))
	{
		bgImageURL=gifFileName;
	}
	else
	{
		//is it started with the Root path
		if(gifFileName.startsWith("$/"))
		{
			bgImageURL= OLA.base + gifFileName.substring(1);
		}
		else
		{
			bgImageURL= base + gifFileName;
		}
	}
	if(!bgImageURL.startsWith("http://"))
	{
		//bgImageURL="content:/"+bgImageURL;
	}
	return bgImageURL;
	}
	class MyGifView extends View{
		private long movieStart;
		private Movie movie;
		public MyGifView(Context context) 
		{
			super(context);

		}
		
		public void setImage(String bgImageURL)
		{
		String base="";

		base=OLA.appBase;

		if(gifFileName.startsWith("file://"))
		{
			bgImageURL=gifFileName.substring(7);
		}
		else if(gifFileName.startsWith("http://"))
		{
			bgImageURL=gifFileName;
		}
		else
		{
			//is it started with the Root path
			if(gifFileName.startsWith("$/"))
			{
				bgImageURL= OLA.base + gifFileName.substring(1);
			}
			else
			{
				bgImageURL= base + gifFileName;
			}
		}
		System.out.println("gifview:"+bgImageURL);
		InputStream in =null;

			try
			{
				if (bgImageURL.startsWith("http://"))
				{
					
					DownloadImage task = new DownloadImage();
					task.execute(bgImageURL,null);
					
				} else
				{

					in = new FileInputStream(bgImageURL);
					// Drawable drawable=Drawable.createFromStream(is, null);
					//以文件流（InputStream）读取进gif图片资源
					movie=Movie.decodeStream(in);
					movieStart=0;
					this.invalidate();
				}
			} catch (Exception e)
			{
				e.printStackTrace();
			}
		
		
		}
		void repaint()
		{
			this.invalidate();
		}
		private class DownloadImage extends AsyncTask<String, Integer, byte[]>
		{

			protected byte[] doInBackground(String... urls)
			{
				ByteArrayOutputStream out= new ByteArrayOutputStream();
				InputStream in = null;
				try
				{
					URL url = new URL(urls[0]);
					HttpURLConnection urlConn = (HttpURLConnection) url
							.openConnection();
					urlConn.setConnectTimeout(1000);

					in = urlConn.getInputStream();
					
					byte[] bs = new byte[2048];
					
					int count=0;
					while (-1 != (count = in.read(bs)))
					{
						//System.out.println("Total:"+total+"; read bytes:"+count);
						//buf.append(new String(bs,"utf-8"));
						out.write(bs, 0, count);
					}

				}
				catch (Exception e2)
				{
					
					e2.printStackTrace();
				}
				byte[] bs=out.toByteArray();
				try
				{
					out.close();
				} catch (IOException e)
				{
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				return bs;

			}

			protected void onProgressUpdate(Integer... progress)
			{

			}

			protected void onPostExecute(byte[] result)
			{
				movie=Movie.decodeByteArray(result,0,result.length);
				movieStart=0;
				repaint();
					
					// Drawable drawable=Drawable.createFromStream(in, null);
				result=null;
				
				
			}

		}
		

		 
		@Override
		protected void onDraw(Canvas canvas)
		{
			System.out.println("gifview:onDraw....");
			long curTime = android.os.SystemClock.uptimeMillis();
			// 第一次播放
			if (movieStart == 0)
			{
				movieStart = curTime;
			}
			if (movie != null)
			{
				int duraction = movie.duration();
				if (duraction == 0) {
					duraction = 1000;
		        }
				int relTime = (int) ((curTime - movieStart) % duraction);
				movie.setTime(relTime);
				movie.draw(canvas, 0, 0);
				// 强制重绘
				invalidate();
			}
			else
			{
				movieStart = 0;
			}
			super.onDraw(canvas);
		}
	}

	
	
}
