package com.lohool.ola;

import android.os.Handler;
import android.os.Message;

public class MyHandler
{
	private Handler handler=new Handler()  
    {  
         public void handleMessage(Message msg)  
        {  
        if (!Thread.currentThread().isInterrupted()) {  
            switch (msg.what) {  
            case 0:  
            	//start
                break;  
            case 1:  
//                progressBar.setProgress(DownedFileLength);  
//                int x=DownedFileLength*100/FileLength;  
//                textView.setText(x+"%");  
                break;  
            case 2:  
                //finished
                break;  
                   
            default:  
                break;  
            }  
        }     
        }  
            
    };  

}
