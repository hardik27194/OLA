package com.lohool.ola.wedgit;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.InputStream;

import org.w3c.dom.Node;

import com.lohool.ola.OLA;
import com.lohool.ola.UIFactory;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Context;
import android.graphics.Color;
import android.graphics.drawable.AnimationDrawable;
import android.graphics.drawable.ClipDrawable;
import android.graphics.drawable.ColorDrawable;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.GradientDrawable;
import android.graphics.drawable.ShapeDrawable;
import android.graphics.drawable.shapes.OvalShape;
import android.graphics.drawable.shapes.Shape;
import android.os.AsyncTask;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.view.animation.Animation;
import android.view.animation.LinearInterpolator;
import android.view.animation.RotateAnimation;
import android.widget.FrameLayout;
import android.widget.ProgressBar;

/**
 * Usage
 * 
 * @see UIMessage
 * @author xingbao-
 * 
 */
@SuppressLint("NewApi")
public class IProgressBar extends IWedgit
{
	String defaultStyle = "style:horizontal;width:auto;align:center;valign:middle;indeterminate:false;indeterminateOnly:false;progress-color:#FFCC66;indeterminate-color:#C2D7EB;";

	ProgressBar progressBar;

	public IProgressBar(IView parent, Context context, Node root,UIFactory ui)
	{
		super(parent, context, root,ui);
		progressBar = new ProgressBar(context);
		progressBar.setMax(100);
		progressBar.setMinimumHeight(20);
		progressBar.setProgress(0);

		super.defaultCSSStyle = defaultStyle;
		v = progressBar;
		super.initiate();
		// progressBar.setGravity(css.getGravity());
		parseMyAttribute();
	}

	public void parseMyAttribute()
	{
		// ProgressBar progressBar=(ProgressBar)v;
		// System.out.println("indeterminate="+css.getStyleValue("indeterminate"));
		// System.out.println("indeterminateOnly="+css.getStyleValue("indeterminateOnly"));
		// System.out.println("style="+css.getStyleValue("style"));
		// System.out.println("value="+css.getStyleValue("value"));
		String attr;
		if ((attr = css.getStyleValue("indeterminate")) != null)
		{
			setIndeterminate(Boolean.parseBoolean(attr));
		}
		if ((attr = css.getStyleValue("indeterminateOnly")) != null)
		{
			setIndeterminateOnly(Boolean.parseBoolean(attr));
		}
		if ((attr = css.getStyleValue("type")) != null)
		{
			setStyle(attr);
		}

		if ((attr = css.getStyleValue("indeterminate-color")) != null)
		{
			
			String style = css.getStyleValue("type");
			
			if (style != null && (style.equalsIgnoreCase("horizontal") || style.equalsIgnoreCase("bar")))
			{
				ColorDrawable cd = new ColorDrawable(CSS.parseColor(attr));
				progressBar.setBackground(cd);
				ClipDrawable d;
				d = new ClipDrawable(new ColorDrawable(
						CSS.parseColor("#FFCC66")), Gravity.LEFT,
						ClipDrawable.HORIZONTAL);
				progressBar.setProgressDrawable(d);
			} 
			else if (style != null &&  style.equalsIgnoreCase("rotate"))
			{
				
			}
			else
			{
				
				/*
				 * int strokeWidth = 10; // 3dp 边框宽度 int roundRadius = 15; //
				 * 8dp 圆角半径 int strokeColor = Color.parseColor("#2E3135");//边框颜色
				 * int fillColor = Color.parseColor("#00DFDFE0");//内部填充颜色
				 * 
				 * GradientDrawable gd = new GradientDrawable();//创建drawable
				 * gd.setColor(fillColor); gd.setCornerRadius(roundRadius);
				 * gd.setStroke(strokeWidth, strokeColor);
				 * 
				 * //渐变色 //int colors[] = { 0xffffffff , 0xff00ff00, 0x00a6c0cd
				 * };//分别为开始颜色，中间夜色，结束颜色 //gd = new
				 * GradientDrawable(GradientDrawable.Orientation.TOP_BOTTOM,
				 * colors);
				 * 
				 * 
				 * 
				 * ShapeDrawable activeDrawable = new ShapeDrawable();
				 * gd.setShape(GradientDrawable.OVAL);
				 * 
				 * d = new ClipDrawable(gd, Gravity.CENTER,
				 * ClipDrawable.HORIZONTAL); d.setLevel(5000);
				 * progressBar.setRotation(5);
				 * progressBar.setProgressDrawable(gd);
				 * //progressBar.setIndeterminateDrawable
				 * (progressBar.getBackground());
				 * //progressBar.setIndeterminate(true);
				 * progressBar.setIndeterminate(true);
				 * //progressBar.setBackgroundColor(Color.rgb(0x88, 0xcc,
				 * 0xff));
				 * //progressBar.setProgressDrawable(context.getResources
				 * ().getDrawable(android.R.drawable.progress_horizontal));
				 * progressBar.setIndeterminateDrawable(gd);
				 */
			}

		}
		if ((attr = css.getStyleValue("value")) != null)
		{
			setValue(Integer.parseInt(attr));
		}
	}

	public void setIndeterminate(boolean indeterminate)
	{
		progressBar.setIndeterminate(indeterminate);
	}

	public void setIndeterminateOnly(boolean indeterminateOnly)
	{
		BeanUtils.setFieldValue(progressBar, "mOnlyIndeterminate", new Boolean(
				indeterminateOnly));
	}

	public void setStyle(String style)
	{
		if (style.equalsIgnoreCase("horizontal")
				|| style.equalsIgnoreCase("bar"))
		{
			/*
			 * 设置ProgressBar滑动的颜色，其函数为：progressBar.setProgressDrawable(Drawable
			 * d); 但是，设置一个普通的Drawable是没有用的，ProgressBar会把该图片平铺。
			 * 正确的方式是：设置一个ClipDrawable，ClipDrawable
			 * 是对一个Drawable进行剪切操作，可以控制这个drawable的剪切区域
			 * ，以及相相对于容器的对齐方式，android中的进度条就是使用一个ClipDrawable实现效果的
			 * ，它根据level的属性值，决定剪切区域的大小。
			 * 
			 * //ClipDrawable d = new ClipDrawable(new
			 * ColorDrawable(Color.YELLOW), Gravity.LEFT,
			 * ClipDrawable.HORIZONTAL); //progressBar.setProgressDrawable(d);
			 */
			BeanUtils.setFieldValue(progressBar, "mOnlyIndeterminate",new Boolean(false));
			progressBar.setIndeterminate(false);
			// progressBar.setBackgroundColor(Color.rgb(0x88, 0xcc, 0xff));
			// progressBar.setProgressDrawable(context.getResources().getDrawable(android.R.drawable.progress_horizontal));
			progressBar.setIndeterminateDrawable(context.getResources().getDrawable(android.R.drawable.progress_indeterminate_horizontal));

		} else if (style.equalsIgnoreCase("rotate"))
		{
			// BeanUtils.setFieldValue(progressBar, "mOnlyIndeterminate", new
			// Boolean(false));
			progressBar.setIndeterminate(true);
			RotateAnimation rotate = new RotateAnimation(0f, 360f,
					Animation.RELATIVE_TO_SELF, 0.5f,
					Animation.RELATIVE_TO_SELF, 0.5f);
			LinearInterpolator lin = new LinearInterpolator();
			rotate.setInterpolator(lin);
			rotate.setDuration(1500);// 设置动画持续时间
			rotate.setRepeatCount(-1);// 设置重复次数
			rotate.setFillAfter(true);// 动画执行完后是否停留在执行完的状态
			rotate.setStartOffset(10);// 执行前的等待时间
			// img.setAnimation(rotate);
			progressBar.setAnimation(rotate);

			// progressBar.setBackgroundColor(Color.rgb(0x88, 0xcc, 0xff));
			String attr;
			if ((attr = css.getStyleValue("progress-image")) != null)
			{
				String url = CSS.parseImageUrl(attr);
				InputStream is;
				try
				{
					url = parseUrl(url);
					System.out.println("loading png:" + url);

					if (url.startsWith("http://"))
					{
						DownloadImage task = new DownloadImage();
						task.execute(url);
					} else
					{
						is = new FileInputStream(new File(url));
						Drawable drawable = Drawable.createFromStream(is, null);
						progressBar.setIndeterminateDrawable(drawable);
						progressBar.setProgressDrawable(drawable);
					}
				} catch (Exception e)
				{
					// TODO Auto-generated catch block
					e.printStackTrace();
				}

			}
		}
	}
	/**
	 * keep same method to IOS
	 */
	public void start()
	{
		
	}

	private class DownloadImage extends AsyncTask<String, Integer, Drawable>
	{
		protected Drawable doInBackground(String... urls)
		{
			Drawable image = null;
			try
			{
				image = returnDrawable(urls[0], null);
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
			progressBar.setIndeterminateDrawable(result);
			progressBar.setProgressDrawable(result);
			result = null;
		}
	}

	public void setValue(int value)
	{
		progressBar.setProgress(value);

	}

	public String parseUrl(String gifFileName)
	{
		String base = "";

		base = OLA.appBase;
		String bgImageURL;
		if (gifFileName.startsWith("file://"))
		{
			bgImageURL = gifFileName.substring(7);
		} else if (gifFileName.startsWith("http://"))
		{
			bgImageURL = gifFileName;
		} else
		{
			// is it started with the Root path
			if (gifFileName.startsWith("$/"))
			{
				bgImageURL = OLA.base + gifFileName.substring(1);
			} else
			{
				bgImageURL = base + gifFileName;
			}
		}

		return bgImageURL;
	}

}
