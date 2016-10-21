package com.lohool.ola.util;

public class Log
{
	public static void d(String tag, String msg)
	{
		android.util.Log.d(tag, msg);
	}
	public static void i(String tag, int i)
	{
		android.util.Log.d(tag, Integer.toString(i));
	}
	public static void f(String tag, double f)
	{
		android.util.Log.d(tag, Double.toString(f));
	}
}
