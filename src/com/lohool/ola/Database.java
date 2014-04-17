package com.lohool.ola;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import android.database.sqlite.SQLiteStatement;

public class Database {
	Context ctx;
	SQLiteDatabase db;
	private HashMap values;
	public Database(Context ctx)
	{
		this.ctx=ctx;
	}
//	public Database getInstance()
//	{
//		return new Database(MainActivity);
//	}
	public boolean isExist(String dbName)
	{

		File db = ctx.getDatabasePath(dbName);
	    if(db==null)return false;
	    else return true;
	}
	public void open(String databse)//,boolean isFile)
	{
//		if(isFile) openFile(databse);
//		else 
			openLocal(databse);
	}
	
	private void openFile(String path)
	{
		db = SQLiteDatabase.openOrCreateDatabase(path, null);
	}
	private void openLocal(String dbName)
	{
		db = ctx.openOrCreateDatabase(dbName, ctx.MODE_PRIVATE, null);
	}
	public void execSQL(String sql)
	{
		db.execSQL(sql);
	}
	
	public long insert(String table, String[] columns,String[] values)
	{
		ContentValues initialValues = new ContentValues();
		for(int i=0;i<columns.length;i++)
		{
			initialValues.put(columns[i], values[i]);
		}
		return db.insert(table, null, initialValues);
	}
	
//	public ArrayList query(String table, String[] columns)
//	{
//		//db.query(distinct, table, columns, selection, selectionArgs, groupBy, having, orderBy, limit, cancellationSignal);
//		Cursor cursor=db.query( table, columns, null, null, null, null, null, null);
//		ArrayList results=new ArrayList();
//		while(cursor.moveToLast())
//		{
//			int size=cursor.getCount();
//			HashMap values=new HashMap();
//			for(int i=0;i<size;i++)
//			{
//				String name=cursor.getColumnName(i);
//				String value=cursor.getString(i);
//				values.put(name, value);
//			}
//			results.add(values);
//		}
//		return results;
//	}
	public String query(String sql,Object selectionArgs)
	{
//		DBHelper helper= new DBHelper(ctx);
//		SQLiteDatabase db=helper.getWritableDatabase();
//		SQLiteStatement stmt=db.compileStatement("");
		
		System.out.println("sql="+sql);
		System.out.println("selectionArgs="+selectionArgs);
		
		Cursor cursor=db.rawQuery(sql, null);
		StringBuffer buf=new StringBuffer();
		while(cursor.moveToNext())
		{
			buf.append("{");
			int size=cursor.getCount();
			//values = new HashMap();
			for(int i=0;i<size;i++)
			{
				String name=cursor.getColumnName(i);
				String value=cursor.getString(i);
				//values.put(name, value);
				if(i!=0)buf.append(",");
				buf.append(name).append("=\"").append(value).append("\"");
			}
			//results.add(values);
			buf.append("}");
			buf.append(",");
		}
		cursor.close();
		System.out.println("results.size=");
		buf.deleteCharAt(buf.length()-1);
		
		return buf.toString();
	}

	public void close()
	{
		db.close();
		db=null;
	}

}
