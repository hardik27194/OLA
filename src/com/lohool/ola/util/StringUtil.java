package com.lohool.ola.util;

public class StringUtil {

	public static String UTF6LE(int uc,int lc)
	{
		if(lc<0)lc=lc&0xFF;
		return  String.valueOf((char) ((uc << 8) + lc));
	}
	
	public static String toUTF6LE(String byteArray)
	{
		StringBuffer buf= new StringBuffer();
//		buf.deleteCharAt(buf.length()-1);
//		buf.deleteCharAt(0);
		String[] bs=byteArray.split(",");
		int i=0;
		for(i=0;i<bs.length;i++)
		{
			if(i>=bs.length || bs[i].equals("") || i+1>=bs.length || bs[i+1].equals(""))
			{
				i++;
			}
			else
			{
				int l=Integer.parseInt(bs[i]);
				i++;
				int h=Integer.parseInt(bs[i]);
				buf.append(UTF6LE(h,l));
			}
		}
		return buf.toString();
	}
}
