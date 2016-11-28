package com.lohool.ola.util;

public class Log
{
	public static void d(String tag, String msg)
	{
		android.util.Log.d(tag, msg);
	}
	public static void i(String tag, int i)
	{
		android.util.Log.i(tag, Integer.toString(i));
	}
	public static void f(String tag, double f)
	{
		android.util.Log.v(tag, Double.toString(f));
	}
}
