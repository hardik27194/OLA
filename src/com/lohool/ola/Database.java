package com.lohool.ola;

import java.io.File;
//import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
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
//	PreparedStatement pstmt;
	
	//for prepared statements
	String pstmtSql;	
	ArrayList pstmtParams=new ArrayList();
	
	public Database()
	{
		this.ctx=Main.ctx;
	}
	public static Database create()
	{
		return new Database();
	}
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
	
    public void createPreparedStatement(String sql) throws  SQLException
	{
    	pstmtSql=sql;
	}
    //reset the prepare stmt's params list
    public void resetPreparedStatement()
    {
    	pstmtParams.clear();
    }
    public void setColumn(String value) throws SQLException
    {
    	pstmtParams.add(value);
    }

    public void setColumn(int value) throws SQLException
    {
    	pstmtParams.add(value);
    }

    public void setColumn(long value) throws SQLException
    {
    	pstmtParams.add(value);
    }

    public void setColumn(float value) throws SQLException
    {
    	pstmtParams.add(value);
    }

    public void setColumn(double value) throws SQLException
    {
    	pstmtParams.add(value);
    }

    public void setColumn( byte value) throws SQLException
    {
    	pstmtParams.add(value);
    }

    public void setColumn(short value) throws SQLException
    {
    	pstmtParams.add(value);
    }

    public void setColumn(String date,String dateformat) throws SQLException, ParseException
    {
    	SimpleDateFormat form = new SimpleDateFormat(dateformat);
    	pstmtParams.add(form.parse(date));
    }

    public void setColumn(Object value) throws SQLException
    {
    	pstmtParams.add(value);
    }

    
    public void executePreparedStatement() throws  SQLException
    {
    	//Object[] p=new Object[pstmtParams.size()];
    	db.execSQL(pstmtSql, pstmtParams.toArray());
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
			int size=cursor.getColumnCount();
			//values = new HashMap();
			for(int i=0;i<size;i++)
			{
				String name=cursor.getColumnName(i);
				String value=cursor.getString(i).replace("\"", "\\\"");
				 //value=value.replace("'", "\\'");
				//values.put(name, value);
				if(i!=0)buf.append(",");
				buf.append(name).append("=\"").append(value).append("\"");
			}
			//results.add(values);
			buf.append("}");
			buf.append(",");
		}
		cursor.close();
		System.out.println("results.size="+cursor.getCount());
		
		if(buf.length()>0)buf.deleteCharAt(buf.length()-1);
		//System.out.println("results="+buf.toString());
		return buf.toString();
	}

	public void close()
	{
		db.close();
		db=null;
	}

}
