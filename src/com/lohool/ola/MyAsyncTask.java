package com.lohool.ola;

import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.net.ConnectException;
import java.net.HttpURLConnection;

import com.lohool.ola.wedgit.UIMessage;

import android.os.AsyncTask;

public class MyAsyncTask 
{
	public static MyAsyncTask create()
	{
		MyAsyncTask msg = new MyAsyncTask();  
		return msg;
	}

	public void sendMessage(String msg)
	{System.out.println("UI message:"+msg);
//		InitOLAPortalTask task= new InitOLAPortalTask();
//        task.execute(msg);
	new Thread(new AsyncMessage(msg)).start();
	}
    private class InitOLAPortalTask extends AsyncTask<String, Integer, String> {
    	PortalProperties properties;
		@Override
		protected String doInBackground(String... params) {
			UIMessage msg= UIMessage.create();
			msg.updateMessage(params[0]);
			return "";
		}
		@Override
		protected void onPostExecute(String result) {

					
		}
    }
    private class AsyncMessage implements Runnable
	{
    	String message;
    	AsyncMessage(String msg)
    	{
    		this.message=msg;
    	}
		@Override
		public void run()
		{
			UIMessage msg=new UIMessage();

			msg.updateMessage(message);
						
		}
		
	}
}
