package com.example.anluatest.wedgit;

import java.util.HashMap;
import java.util.Map;

import android.graphics.Color;
import android.view.Gravity;
import android.widget.TextView;

public class CSS
{

	String css;

	String name;

	String position;
	boolean display = true;
	boolean visibility = true;
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

	protected class Margin
	{
		int left, top, right, bottom;
		String marginLeft, marginTop, marginRight, marginBottom;
		String margin;

		public void setMargin(String px)
		{
			margin = px;
			int p = parseInt(margin);
			System.out.println("margin=" + px);
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
			styles.put(s.substring(0, pos), s.substring(pos + 1));
			// System.out.println("CSS:"+s.substring(0,pos)+"="+
			// s.substring(pos+1));
			parse(s.substring(0, pos), s.substring(pos + 1));
		}
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

	public static String parseImageUrl(String url)
	{
		if (url.startsWith("url"))
		{
			url = url.substring(4, url.length() - 1);
		}

		return url;
	}

}
