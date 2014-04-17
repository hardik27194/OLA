package com.lohool.ola;

import java.io.DataInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;

public class IFileInputStream {

	String path;

	DataInputStream in;
	boolean isExisted = false;

	public IFileInputStream(String path) {
		try {
			this.path = path;
			File file = new File(path);
			if (file.exists()) {
				isExisted = true;

				in = new DataInputStream(new FileInputStream(file));

			}
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}

	public static IFileInputStream open(String path) {
		return new IFileInputStream(path);
	}

	public static String test() {
		return "fis test...";
	}

	public static boolean testBool(boolean b) {
		return b;
	}

	public static boolean testBool2(boolean b) {
		return b ? true : null;
	}

	public static String testBool3(boolean b) {
		return Boolean.toString(b);
	}

	public static void test1(boolean a) {
		System.out.println("lua boolean=" + a);
	}

	public String exists() {
		return Boolean.toString(isExisted);
	}

	public int available() throws IOException {
		return in.available();
	}

	public int readInt() throws IOException {
		return in.readInt();
	}

	public String readIntArray(int len) throws IOException {

		StringBuffer buf = new StringBuffer();
		buf.append("{");
		int i = -1;
		int j = 0;
		while ((i = in.readInt()) != -1) {
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
			return in.readLong();
		} catch (IOException e)
		{
			return -1;
		}
	}

	public int readShort() {
		try {
			return in.readShort();
		} catch (IOException e) {
			return -1;
		}
	}

	public String readBoolean() throws IOException {
		return Boolean.toString(in.readBoolean());
	}

	public double readDouble() throws IOException {
		return in.readDouble();
	}

	
	// used for data writed by IFileOutPutStream
	public String readStringWithLength() {
		int len;
		try {
			len = in.readInt();
			byte[] buffer = new byte[len];
			in.read(buffer);
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
		in.read(buffer);
		return new String(buffer);
	}

	public byte readByte() {
		try
		{
			return in.readByte();
		} catch (IOException e)
		{
			return -1;
		}
	}

	public String readBytes(int len) {
		byte[] buffer = new byte[len];
		StringBuffer buf = new StringBuffer();
		try {
			in.read(buffer);

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
			a[i] = in.readByte();
		}
		System.out.println(System.currentTimeMillis() - l);
		return a;
	}

	public void skipBytes(int len) throws IOException {
		in.skipBytes(len);
	}

	public void close() throws IOException {
		if (in != null)
			in.close();
	}

	/*
	 * public void copyDataBase() { try { // 获得InputStream对象 // InputStream is =
	 * getResources().getAssets().open("IELTSCore3000.db"); InputStream is =
	 * getAssets().open("IELTSCore3000.aac");
	 * 
	 * FileOutputStream fos = new FileOutputStream("/sdcard/test/test.db");
	 * byte[] buffer = new byte[1024]; int count = 0; // 开始复制db文件 int process =
	 * 0; while (-1 != (count = is.read(buffer))) //while ((count =
	 * is.read(buffer)) > 0) {
	 * System.out.println("len="+count+"; byte1="+buffer[0]); fos.write(buffer,
	 * 0, count); process += count; } fos.close(); is.close(); } catch
	 * (Exception e) { e.printStackTrace(); }
	 * 
	 * }
	 */

}
