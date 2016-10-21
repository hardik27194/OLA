package com.lohool.ola.util;

import com.lohool.ola.HTTP;
import com.lohool.ola.Main;

import android.content.Intent;
import android.database.Cursor;
import android.net.Uri;
import android.provider.ContactsContract;

public class Pim
{
	
	public static void call(String number)
	{
		Intent intent = new Intent(Intent.ACTION_CALL,Uri.parse("tel:"+number));  
        Main.activity.startActivity(intent);
	}
	public static void dial(String number)
	{
		Intent intent = new Intent(Intent.ACTION_DIAL,Uri.parse("tel:"+number));  
        Main.activity.startActivity(intent);
	}
	
	public static String readContacts()
	{
		Uri uri = ContactsContract.CommonDataKinds.Phone.CONTENT_URI; // 联系人Uri；  
        // 查询的字段  
        String[] projection = { ContactsContract.CommonDataKinds.Phone._ID,  
                ContactsContract.CommonDataKinds.Phone.DISPLAY_NAME,  
                ContactsContract.CommonDataKinds.Phone.NUMBER,                
                ContactsContract.CommonDataKinds.Phone.SORT_KEY_PRIMARY,
                ContactsContract.CommonDataKinds.Phone.CONTACT_ID,  
                ContactsContract.CommonDataKinds.Phone.PHOTO_ID,  
                ContactsContract.CommonDataKinds.Phone.LOOKUP_KEY,
                ContactsContract.CommonDataKinds.Phone.DATA1
                };  
        Cursor cursor = Main.ctx.getContentResolver().query(
        		ContactsContract.CommonDataKinds.Phone.CONTENT_URI, 
        		projection, 
                null, 
                null, 
                null);
        StringBuffer buf=new StringBuffer();
        while(cursor.moveToNext()) {
        	String name = cursor.getString(1);  
            String number = cursor.getString(2);  
            String sortKey = cursor.getString(3);  
            int contactId = cursor.getInt(4);  
            Long photoId = cursor.getLong(5);  
            String lookUpKey = cursor.getString(6); 
            System.out.println("name="+name+"; number="+number+",sortKey="+sortKey
            		+",contactId="+contactId
            		+",photoId="+photoId
            		+",lookUpKey="+lookUpKey
            		);
            
            buf.append(",");
            buf.append("{");
            buf.append("\"name\":\"").append(name).append("\"");
            buf.append(",");
            buf.append("\"number\":\"").append(number).append("\"");
            buf.append("}");
            

        }
        cursor.close();
        if(buf.length()>0)buf.deleteCharAt(0);

        return buf.toString();
        
        
	}
	


	/**
	 * upload the personal contacts to a cloud server
	 * @param uploadTo
	 * @param cookie if need to be logon, the cookie will be used to pass throught the logon acton
	 */
	public static void upload(String uploadToUrl,String cookies)
	{
		Uri uri = ContactsContract.CommonDataKinds.Phone.CONTENT_URI; // 联系人Uri；  
        // 查询的字段  
        String[] projection = { ContactsContract.CommonDataKinds.Phone._ID,  
                ContactsContract.CommonDataKinds.Phone.DISPLAY_NAME,  
                ContactsContract.CommonDataKinds.Phone.NUMBER,
                ContactsContract.CommonDataKinds.Phone.DATA1, "sort_key",  
                ContactsContract.CommonDataKinds.Phone.CONTACT_ID,  
                ContactsContract.CommonDataKinds.Phone.PHOTO_ID,  
                ContactsContract.CommonDataKinds.Phone.LOOKUP_KEY };  
        Cursor cursor = Main.ctx.getContentResolver().query(
        		ContactsContract.CommonDataKinds.Phone.CONTENT_URI, 
        		projection, 
                null, 
                null, 
                null);
        
        boolean urlHasParams=uploadToUrl.indexOf('?')>0?true:false;

        while(cursor.moveToNext()) {
        	String name = cursor.getString(1);  
            String number = cursor.getString(2);  
            String sortKey = cursor.getString(3);  
            int contactId = cursor.getInt(4);  
            Long photoId = cursor.getLong(5);  
            String lookUpKey = cursor.getString(6); 
            System.out.println("name="+name+"; number="+number+",sortKey="+sortKey);
            
            String url=uploadToUrl+(urlHasParams?"&":"?")+"name="+name+"& number="+number;
            HTTP http=new HTTP(url);
            if(cookies!=null && !cookies.trim().equals(""))http.setCookies(cookies);
            http.sendRequest();
        }
	}
}
