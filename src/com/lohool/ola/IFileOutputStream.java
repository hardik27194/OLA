package com.lohool.ola;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.RandomAccessFile;

public class IFileOutputStream {
	String path;

	java.io.RandomAccessFile out ;
	boolean isExisted =false;

	public IFileOutputStream(String path) 
	{
		this.path=path;
		File file=new File(path);
		if(file.exists())
		{
			isExisted=true;
			
		}
		try {
			if(!file.exists())file.getParentFile().mkdirs();
			out=new RandomAccessFile(file,"rw");
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	public IFileOutputStream(String path,String append) 
	{
		this.path=path;
		File file=new File(path);
		if(file.exists())
		{
			isExisted=true;
			
		}
		boolean isAppend=append.equalsIgnoreCase("true")?true:false;
		try {
			if(!isExisted)file.getParentFile().mkdirs();
			if(!isAppend && isExisted)file.delete();
			out=new RandomAccessFile(file,"rw");//new DataOutputStream( new FileOutputStream(file,isAppend));
			if(isAppend)out.seek(out.length());
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}	
	public static IFileOutputStream open(String path) throws FileNotFoundException
	{
		return new IFileOutputStream(path);
	}
	public static IFileOutputStream open(String path,String append) throws FileNotFoundException
	{
		return new IFileOutputStream(path,append);
	}
	public boolean exists()
	{
		return isExisted;
	}
	
	public void writeInt(int val) throws IOException
	{
		out.writeInt(val);
	}
	public void writeShort(short val) throws IOException
	{
		out.writeShort(val);
	}
	public void writeLong(long val) throws IOException
	{
		out.writeLong(val);
	}
	public void writeBoolean(String val) throws IOException
	{
		out.writeBoolean(val.equalsIgnoreCase("true")?true:false);
	}
	public void writeBoolean(boolean val) throws IOException
	{
		out.writeBoolean(val);
	}
	public void writeByte(byte val) throws IOException
	{
		out.writeByte(val);
	}
	public void writeString(String val) throws IOException
	{
		byte[] b=val.getBytes("utf-8");
		
		out.write(b);
	}
	public void writeStringWithLength(String val) throws IOException
	{
		byte[] b=val.getBytes("utf-8");
		out.writeInt(b.length);
		out.write(b);
	}
	public void seek(long pos) throws IOException
	{
		out.seek(pos);
	}
	public long  getFilePointer() throws IOException
	{
		return out.getFilePointer();
	}
	public void skipBytes(int count) throws IOException
	{
		out.skipBytes(count);
	}
	public void close() throws IOException
	{
		if(out!=null)out.close();
	}

	
	
	public int readInt() throws IOException {
		return out.readInt();
	}

	public String readIntArray(int len) throws IOException {

		StringBuffer buf = new StringBuffer();
		buf.append("{");
		int i = -1;
		int j = 0;
		while ((i = out.readInt()) != -1) {
			buf.append(i).append(",");
			j++;
			if (j >= len)
				break;
		}
		buf.append("}");
		return buf.toString();
	}

	public long readLong(){
		try
		{
			return out.readLong();
		} catch (IOException e)
		{
			return -1;
		}
	}

	public int readShort() {
		try {
			return out.readShort();
		} catch (IOException e) {
			return -1;
		}
	}

	public String readBoolean() throws IOException {
		return Boolean.toString(out.readBoolean());
	}

	public double readDouble() throws IOException {
		return out.readDouble();
	}

	
	// used for data writed by IFileOutPutStream
	public String readStringWithLength() {
		int len;
		try {
			len = out.readInt();
			byte[] buffer = new byte[len];
			out.read(buffer);
			return new String(buffer);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return "";
	}
	

	// used for external data
	public String readString(int len) throws IOException {
		byte[] buffer = new byte[len];
		out.read(buffer);
		return new String(buffer);
	}
	
	public String readLine() throws IOException {
		String l=out.readLine();
		String s="";
//			s+=	 new String(l.getBytes());
//			s+=	 new String(l.getBytes(),"utf-8");
//			s+=	 new String(l.getBytes(),"iso-8859-1");
//			s+=	 new String(l.getBytes(),"gb2312");
//			s+=	 new String(l.getBytes("utf-8"));
//			s+=	 new String(l.getBytes("utf-8"),"iso-8859-1");
//			s+=	 new String(l.getBytes("utf-8"),"gb2312");
//			s+=	 new String(l.getBytes("iso-8859-1"));
			s+=	 new String(l.getBytes("iso-8859-1"),"utf-8");
//			s+=	 new String(l.getBytes("iso-8859-1"),"gb2312");
//			s+=	 new String(l.getBytes("gb2312"));
//			s+=	 new String(l.getBytes("gb2312"),"utf-8");
//			s+=	 new String(l.getBytes("gb2312"),"iso-8859-1");
			
//			s+=  System.getProperty("file.encoding");
				 return s;
	}

	public byte readByte() {
		try
		{
			return out.readByte();
		} catch (IOException e)
		{
			return -1;
		}
	}

	public String readBytes(int len) {
		byte[] buffer = new byte[len];
		StringBuffer buf = new StringBuffer();
		try {
			out.read(buffer);

//			buf.append("{");
			for (byte b : buffer) {
				buf.append(b).append(",");
			}
//			buf.append("}");
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return buf.toString();
	}

	public byte[] readBytesTest(int len) throws IOException {
		long l = System.currentTimeMillis();
		System.out.println();
		byte[] a = new byte[len];
		for (int i = 0; i < len; i++) {
			a[i] = out.readByte();
		}
		System.out.println(System.currentTimeMillis() - l);
		return a;
	}	
}
