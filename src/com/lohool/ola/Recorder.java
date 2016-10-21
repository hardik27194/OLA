package com.lohool.ola;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;

import android.content.ContentResolver;
import android.content.ContentValues;
import android.content.Context;
import android.content.Intent;
import android.media.*;
import android.net.Uri;
import android.os.Environment;
import android.provider.MediaStore;

public class Recorder
{
	private MediaRecorder mediaRecorder;  
	   private File file = null;  
	   static String PREFIX = "CR-"; // CallReading by kylin  
	   static final String EXTENSION = ".amr";// .3gpp by kylin  
	   public static boolean recorderOn = false;  
	 
	   // Add by kylin 2011.10.21 begin  
	   private String mDisplayName;  
	   private String mDisplayNumber;  
	 
	   Context mContext;  
	 
	   /** 
	    * This method starts recording process 
	    *  
	    * @param displayNumber 
	    * @throws Exception 
	    */  
	 
	public static Recorder create()
	{
		return new Recorder("Test","10");
	}
	   
	   public Recorder( String displayName,  String displayNumber) {  
	       mContext = Main.ctx;  
	       mDisplayName = displayName;  
	       mDisplayNumber = displayNumber;  
	 
	       if (null != mDisplayName && !mDisplayName.trim().equals("")) {  
	           PREFIX = PREFIX + mDisplayName + "-";  
	       } else {  
	           PREFIX = PREFIX + mDisplayNumber + "-";  
	       }  
	 
	   }  
	 
	   // end  
	 
	   public void startRecording() throws Exception {  
	       mediaRecorder = new MediaRecorder();  
	       mediaRecorder.setAudioSource(MediaRecorder.AudioSource.MIC);  
	       mediaRecorder.setOutputFormat(MediaRecorder.OutputFormat.THREE_GPP);  
	       mediaRecorder.setAudioEncoder(MediaRecorder.AudioEncoder.AMR_NB);  
	 
	       // Mod by kylin 2011.10.03 begin  
	       String dir = Environment.getExternalStorageDirectory() + "/esb";  
	       
	       if (file == null) {  
	           // File rootDir = Environment.getExternalStorageDirectory();  
	           File newRootDir = new File(dir);  
	           if (!newRootDir.exists()) {  
	               newRootDir.mkdir();  
	           }  
	           file = File.createTempFile(PREFIX, EXTENSION, newRootDir);  
	       }  
	       System.out.println("Recorder file:"+file.getAbsolutePath());
	       mediaRecorder.setOutputFile(file.getAbsolutePath());  
	       // mediaRecorder.setOutputFile(dir);  
	       // end  
	       mediaRecorder.prepare();  
	       mediaRecorder.start();  
	   }  
	 
	   /** 
	    * This method stops recording 
	    */  
	   public void stopRecording() {  
	       mediaRecorder.stop();  
	       mediaRecorder.release();  
	       mediaRecorder = null;  
	        PREFIX = "CR-"; // Add by kylin 2011.10.21  
	    }  
	  
	    /** 
	     * This method sets all metadata for audio file 
	     */  
	    public void saveToDB() {  
	        ContentValues values = new ContentValues(3);  
	        long current = System.currentTimeMillis();  
	        long modDate = file.lastModified();  
	        Date date = new Date(current);  
	        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");  
	        String title = formatter.format(date);  
	        values.put(MediaStore.Audio.Media.IS_MUSIC, "0");  
	        values.put(MediaStore.Audio.Media.TITLE, title);  
	        values.put(MediaStore.Audio.Media.DATA, file.getAbsolutePath());  
	        values.put(MediaStore.Audio.Media.DATE_ADDED, (int) (current / 1000));  
	        values.put(MediaStore.Audio.Media.DATE_MODIFIED, (int) (modDate / 1000));  
	        values.put(MediaStore.Audio.Media.MIME_TYPE, "audio/mp3");  
	        values.put(MediaStore.Audio.Media.ARTIST, "CallRecord");  
	        values.put(MediaStore.Audio.Media.ALBUM, "CallRecorder");  
	        ContentResolver contentResolver = mContext.getContentResolver();  
	        Uri base = MediaStore.Audio.Media.EXTERNAL_CONTENT_URI;  
	        Uri newUri = contentResolver.insert(base, values);  
	        mContext.sendBroadcast(new Intent(  
	                Intent.ACTION_MEDIA_SCANNER_SCAN_FILE, newUri));  
	    }  
	  

}
