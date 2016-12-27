package com.lohool.ola.wedgit;

import java.util.HashMap;
import java.util.Map;

import android.graphics.Color;
import android.graphics.Typeface;
import android.view.Gravity;
import android.widget.TextView;

public class CSS
{

	String css;

	String name;

	String position;
	boolean display = true;
	String visibility = "visible";
	float alpha = 1;
	String verticalAlign;
	int sIndex;

	String backgroundImageURL;
	int backgroundColor;
	int color;

	
	// text position
	String textAlign;
	String orientation;

	Map styles = new HashMap();

	Bounds bounds = new Bounds();
	Margin margin = new Margin();
	Padding padding = new Padding();
	
	Border border=new Border();
	
	Font font =new Font();

	protected class Bounds
	{
		int bottom;
		int left;
		int right;
		int top;

		int width;
		int height;

		int weight;
	}
	
	protected class Border
	{
		int width;
		int color;
		int radius;
		
		void setBorder(String s)
		{
			String[] items = s.split(" ");
			this.width=parseInt(items[1]);
			this.color=parseColor(items[2]);
			this.radius=parseInt(items[3]);
		}
		
	}
	class Font
	{
		int size;
		int style=Typeface.NORMAL;
		String family="Arial";
		public void setFont(String s)
		{
			//Typeface tf=Typeface.SANS_SERIF.create(familyName, style);
			String[] items = s.split(" ");
			boolean isBold=false;
			boolean isItalic=false;
			boolean isSerif=false;
			boolean isSans=false;
			boolean isNormal=false;

			for(String f: items)
			{
				if(f.trim().equals(""))continue;
				if(f.equalsIgnoreCase("bold"))isBold=true;
				else if(f.equalsIgnoreCase("Italic"))isItalic=true;
				//else if(f.equalsIgnoreCase("SANS_SERIF"))isSans=true;
				//else if(f.equalsIgnoreCase("Serif"))isSerif=true;
				//else if(f.equalsIgnoreCase("Normal"))isNormal=true;
				else if(f.matches("[0-9]{1,3}.*"))
				{
					size= parseInt(f);
				}
				else family=f;
			}
			if(isBold)style=Typeface.BOLD;
			if(isItalic) style=Typeface.ITALIC;
			if(isBold && isItalic)style=Typeface.BOLD_ITALIC;
			
		}
	}

	protected class Margin
	{
		int left, top, right, bottom;
		String marginLeft, marginTop, marginRight, marginBottom;
		String margin;

		public void setMargin(String px)
		{
			margin = px;
			int p = parseInt(margin);
			//System.out.println("margin=" + px);
			left = top = right = bottom = p;
		}

		public void setMarginLeft(String px)
		{
			marginLeft = px;
			left = parseInt(px);
		}

		public void setMarginTop(String px)
		{
			marginTop = px;
			top = parseInt(px);
		}

		public void setMarginRight(String px)
		{
			marginRight = px;
			right = parseInt(px);
		}

		public void setMarginBottom(String px)
		{
			marginBottom = px;
			bottom = parseInt(px);
		}
	}

	protected class Padding
	{
		int left, top, right, bottom;
		String paddingLeft, paddingTop, paddingRight, paddingBottom;
		String padding;

		public void setPadding(String px)
		{
			padding = px;
			int p = parseInt(padding);
			left = top = right = bottom = p;
		}

		public void setPaddingLeft(String px)
		{
			paddingLeft = px;
			left = parseInt(px);
		}

		public void setPaddingTop(String px)
		{
			paddingTop = px;
			top = parseInt(px);
		}

		public void setPaddingRight(String px)
		{
			paddingRight = px;
			right = parseInt(px);
		}

		public void setPaddingBottom(String px)
		{
			paddingBottom = px;
			bottom = parseInt(px);
		}

	}

	public CSS(String css)
	{
		this.css = css;
		parse(css);
	}

	private void parse(String css)
	{
		// should use Tokennizer to parse the CSS string
		// System.out.println("CSS:"+css);
		if (css == null || css.trim().equals(""))
			return;
		String[] items = css.split(";");
		for (String s : items)
		{
			if (s.trim().equals(""))
				continue;
			int pos = s.indexOf(':');
			if (pos < 0)
				continue;
			String[] pair = s.split(":");
			styles.put(s.substring(0, pos).trim(), s.substring(pos + 1).trim());
			// System.out.println("CSS:"+s.substring(0,pos)+"="+ s.substring(pos+1));
			parse(s.substring(0, pos).trim(), s.substring(pos + 1).trim());
			
		}
		System.out.println("CSS:"+styles.toString());
		System.out.println("orientation:"+this.orientation);
	}

	private void parse(String name, String value)
	{
		if (name.equalsIgnoreCase("left"))
			bounds.left = parseInt(value);
		else if (name.equalsIgnoreCase("right"))
			bounds.right = parseInt(value);
		else if (name.equalsIgnoreCase("top"))
			bounds.top = parseInt(value);
		else if (name.equalsIgnoreCase("bottom"))
			bounds.bottom = parseInt(value);
		else if (name.equalsIgnoreCase("width"))
		{
			bounds.width = parseInt(value);
			bounds.right = bounds.left + bounds.width;
		} else if (name.equalsIgnoreCase("height"))
		{
			bounds.height = parseInt(value);
			bounds.bottom = bounds.top + bounds.height;
		} else if (name.equalsIgnoreCase("weight"))
			bounds.weight = parseInt(value);

		else if (name.equalsIgnoreCase("vertical-Align")
				|| name.equalsIgnoreCase("valign"))
			verticalAlign = value;
		else if (name.equalsIgnoreCase("text-Align")
				|| name.equalsIgnoreCase("align"))
			textAlign = value;
		else if (name.equalsIgnoreCase("text-color")
				|| name.equalsIgnoreCase("color"))
			color = parseColor(value);

		else if (name.equalsIgnoreCase("orientation"))
			orientation = value;
		else if (name.equalsIgnoreCase("margin"))
			margin.setMargin(value);
		else if (name.equalsIgnoreCase("padding"))
			padding.setPadding(value);
		
		else if (name.equalsIgnoreCase("border"))
			border.setBorder(value);
		else if (name.equalsIgnoreCase("font"))
			font.setFont(value);
		else if (name.equalsIgnoreCase("visibility"))
		{
			visibility=value;
		}
		else if (name.equalsIgnoreCase("alpha"))
			alpha = parseFloat(value);

	}

	public int getGravity()
	{

		int a = 0, b = 0;
		if (textAlign != null)
		{
			if ((textAlign.equalsIgnoreCase("center")))
			{
				a = Gravity.CENTER_HORIZONTAL;
			} else if ((textAlign.equalsIgnoreCase("left")))
				a = Gravity.LEFT;
			else if ((textAlign.equalsIgnoreCase("right")))
				a = Gravity.RIGHT;
		}
		if (verticalAlign != null)
		{
			if ((verticalAlign.equalsIgnoreCase("middle") || (verticalAlign
					.equalsIgnoreCase("center"))))
			{
				b = Gravity.CENTER_VERTICAL;
			} else if (verticalAlign.equalsIgnoreCase("top"))
				b = Gravity.TOP;
			else if (verticalAlign.equalsIgnoreCase("bottom"))
				b = Gravity.BOTTOM;
		}
		if (a == Gravity.CENTER_HORIZONTAL && b == Gravity.CENTER_VERTICAL)
			return (Gravity.CENTER);
		else
			return (a | b);

	}

	public String getStyleValue(String name)
	{
		return (String) styles.get(name);
	}

	public static int parseColor(String color)
	{
		// int v;
		// v=Integer.parseInt(color.replace("#", ""), 16);
		// System.out.println("color="+v);
		return Color.parseColor(color);
	}

	public static int parseInt(String number)
	{
		try
		{
			number = number.replaceAll("[pP][xX]", "");
			number = number.replaceAll("[dD][pP]", "");
			return Integer.parseInt(number);
		} catch (Exception e)
		{
			return 0;
		}
	}

	public static float parseFloat(String number)
	{
		try
		{
			return Float.parseFloat(number);
		} catch (Exception e)
		{
			System.out.println("number="+number);
			e.printStackTrace();
			return 1;
		}
	}

	public static String parseImageUrl(String url)
	{
		if (url.startsWith("url"))
		{
			url = url.substring(4, url.length() - 1);
		}

		return url;
	}

}
