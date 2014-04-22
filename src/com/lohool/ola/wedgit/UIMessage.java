package com.lohool.ola.wedgit;

import com.lohool.ola.LuaContext;
import com.lohool.ola.Main;

import android.os.Handler;
import android.os.Looper;
import android.os.Message;

/**
 * 
 * 			
 * the "threadClick" event while execute the body of the Lua function in loop, 
 * and the loop will be broken when the Lua function return TRUE
 * 
 * Example:
 * 	local msg=uiMsg:create()
	local n=0;
	-- the threadClick event
	function testProgressBar20(a,b)
			--the codes in the function body will be run in a loop thread
			n=n+1
			Log:d("time second=",''..n)
			msg:updateMessage("ProgressBar:setValue("..n.."); test_text:setText('"..n.."%')")
			if n>=100 then
				n=0
				return true --exit the loop thread
			else
				return false
			end
	end

 * @author xingbao-
 *
 */
public class UIMessage
{
//	private static  Handler mHandler = new Handler(){  
//        public void handleMessage(Message msg){  
//        	LuaContext.getInstance().doString((String)msg.obj);
////        	int i=((Integer)msg.obj).intValue();
////        	LuaContext.getInstance().doString("ProgressBar:setValue("+i+")");
////        	LuaContext.getInstance().doString("test_text:setText('"+i+"%')");
//        }  
//    };
    String uiUpdateCode="";
    public static int num=0;
    public  UIMessage()
    {
    	
    }
	public  UIMessage(String uiUpdateCode)
	{
		this.uiUpdateCode=uiUpdateCode;
		
	}
	public  void updateMessage(String uiUpdateCode)
	{
		Message msg = new Message();  
		msg.obj=uiUpdateCode;
        IWedgit.mHandler.sendMessage(msg);
        
//		Runnable mRunnable = new Runnable() {
//	    	
//
//	        @Override
//	        public void run() {
//	            //mTextView.setText("haha");
//	        	//LuaContext.getInstance().doString(onclick);
////	        	Looper.prepare();
////	        	LuaContext.getInstance().doString("ProgressBar:setValue("+(num)+")");
////	        	LuaContext.getInstance().doString("test_text:setText('"+(num)+"%')");
//	        	Message msg = new Message();  
//	    		msg.obj=num+=10;
//	        	 IWedgit.mHandler.sendMessage(msg);
//	        	
////	        	Looper.loop();
//	        }
//	    };
//	    new Thread(mRunnable).start();
	}
	
	public static UIMessage create()
	{
		UIMessage msg = new UIMessage();  
		return msg;
	}
	
}
