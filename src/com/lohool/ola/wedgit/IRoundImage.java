package com.lohool.ola.wedgit;

import java.io.FileInputStream;
import java.io.InputStream;

import org.w3c.dom.Node;

import com.lohool.ola.OLA;
import com.lohool.ola.UIFactory;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.drawable.Drawable;
import android.os.AsyncTask;
import android.widget.TextView;

public class IRoundImage  extends IWedgit {
	RoundImage t;
	public IRoundImage(IView parent,Context context,Node root,UIFactory ui) {
		super(parent, context,  root,ui);
		t=new RoundImage(context);
		
		v=t;
		super.initiate();
		//t.setGravity(css.getGravity());
		
	}
	
	public void setImageUrl(String backgroundImageUrl)
	{
		// v.setBackground( new
		// BitmapDrawable(returnBitMap(backgroundImageURL)));
		// BitmapDrawable bd=new
		// BitmapDrawable(returnBitMap(backgroundImageURL));
		String base="";
//		if(PortalProperties.getInstance().getAppProperties()!=null)base=PortalProperties.getInstance().getAppProperties().getAppBase();
//		else base=PortalProperties.getInstance().getAppBase();
		base=OLA.appBase;
		String backgroundImageURL;

		
		if(backgroundImageUrl.startsWith("file://"))
		{
			backgroundImageURL=backgroundImageUrl.substring(7);
		}
		else if(backgroundImageUrl.startsWith("http://"))
		{
			backgroundImageURL=backgroundImageUrl;
		}
		else
		{
			//is it started with the Root path
			if(backgroundImageUrl.startsWith("$/"))
			{
				backgroundImageURL= OLA.base + backgroundImageUrl.substring(1);
			}
			else
			{
				backgroundImageURL= base + backgroundImageUrl;
			}
		}
		
		
		System.out.println(backgroundImageURL);
		try{
		if (backgroundImageURL.startsWith("http://"))
		{
			DownloadImage task = new DownloadImage();
			task.execute(backgroundImageURL);
			
		} else
		{
//			Bitmap img=getImageFromAssetsFile(backgroundImageURL);
//			v.setBackgroundDrawable(new BitmapDrawable(img));
//			//img.recycle();
//			img=null;
		
			InputStream is = new FileInputStream(backgroundImageURL);
			Drawable drawable=Drawable.createFromStream(is, null);
			t.setImageDrawable(drawable);
//			Bitmap img=returnBitMap(backgroundImageURL);
//			t.setImageBitmap(img);
			is.close();
		}
		}catch(Exception e)
		{
			e.printStackTrace();
		}


		System.gc();
		css.backgroundImageURL = backgroundImageURL;
	}
	
	class DownloadImage extends AsyncTask<String, Integer, Bitmap>
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
			//BitmapDrawable db=new BitmapDrawable(result);
			//t.setImageDrawable(result);
			t.setImageBitmap(result);
//			v.setBackground(null);
//			result.recycle();
			result=null;
			
			
		}

	}
}
