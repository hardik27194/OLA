package com.lohool.ola;

import java.io.IOException;

import android.content.Intent;
import android.media.MediaPlayer;
import android.net.Uri;
import android.os.Environment;
import android.view.SurfaceHolder;
import android.view.SurfaceView;
import android.view.ViewGroup.LayoutParams;
import android.view.ViewGroup.MarginLayoutParams;
import android.widget.FrameLayout;
import android.widget.MediaController;
import android.widget.VideoView;

public class VideoPlayer
{
	String url;
	
	public static VideoPlayer create(String mediaFileURL) 
	{
		try
		{
			return new VideoPlayer(mediaFileURL);
		} catch (Exception e)
		{
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}
	
	
	public VideoPlayer(String url)
	{
		this.url=url;
	}

	public void play()
	{
		Uri uri = Uri.parse(url);   
	        Intent intent = new Intent(Intent.ACTION_VIEW);  

	        intent.setDataAndType(uri, "video/mp4");  
	        Main.activity.startActivity(intent);

	}
	public void play2()
	{
		Uri uri = Uri.parse(url);   
	        
	        VideoView videoView = new VideoView(Main.ctx);  
	        LayoutParams p1 = new LayoutParams(
	        		LayoutParams.MATCH_PARENT,
	        		LayoutParams.MATCH_PARENT);
	        videoView.setLayoutParams(p1);
	        
	        videoView.setMediaController(new MediaController(Main.activity));  
	        videoView.setVideoURI(uri);  
	        Main.activity.setContentView(videoView);
	        videoView.start();  
	        videoView.requestFocus();  
	}
	public void play3()
	{
		Uri uri = Uri.parse(url);   
		MediaPlayer mediaPlayer = new MediaPlayer();   
		SurfaceView surfaceView = new SurfaceView(Main.ctx);  
        LayoutParams p1 = new LayoutParams(
        		LayoutParams.MATCH_PARENT,
        		LayoutParams.MATCH_PARENT);
        surfaceView.setLayoutParams(p1);
        //把输送给surfaceView的视频画面，直接显示到屏幕上,不要维持它自身的缓冲区  
        surfaceView.getHolder().setType(SurfaceHolder.SURFACE_TYPE_PUSH_BUFFERS);  
        surfaceView.getHolder().setFixedSize(176, 144);  
        surfaceView.getHolder().setKeepScreenOn(true);  
        //.getHolder().addCallback(new SurfaceCallback());  
        mediaPlayer.reset();  
        try
		{
			mediaPlayer.setDataSource(url);
		} catch (IllegalArgumentException e)
		{
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SecurityException e)
		{
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IllegalStateException e)
		{
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e)
		{
			// TODO Auto-generated catch block
			e.printStackTrace();
		}  
        mediaPlayer.setDisplay(surfaceView.getHolder());  
        try
		{
			mediaPlayer.prepare();
		} catch (IllegalStateException e)
		{
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e)
		{
			// TODO Auto-generated catch block
			e.printStackTrace();
		}//缓冲  
        
        mediaPlayer.start();
        
        Main.activity.setContentView(surfaceView);

	}
}
