package com.lohool.ola.wedgit;

import com.lohool.ola.Main;

import android.media.AudioManager;
import android.media.MediaPlayer;
import android.net.Uri;

public class SoundPlayer implements Runnable
{

	protected MediaPlayer player;
	protected int timex;
	private String timeStr = "";
	private int num[];
	private int second;
	// ������ʱ�䳤������
	private int duration;
	boolean isPaused = false;
	long pausedTime;
	String mediaURL;
	long dura;

	private SoundPlayer()
	{
	}

	public SoundPlayer(String mediaFileURL) throws Exception
	{
		this.mediaURL = mediaFileURL;
		createPlayer();
	}
	public static SoundPlayer createPlayer(String mediaFileURL) 
	{
		try
		{
			return new SoundPlayer(mediaFileURL);
		} catch (Exception e)
		{
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}
	
	private void createPlayer() throws Exception
	{
		// �ڴ����µĲ�����ǰ���رվɵĲ�����
		stop();
		if (mediaURL != null)
		{
			player = new MediaPlayer();
			player.reset();// 重置为初始状态
			if (mediaURL.startsWith("/"))
			{

				player.setDataSource(mediaURL);
				//player.prepare();

			} else
			{
				Uri uri = Uri.parse(mediaURL);
				
				player.setDataSource(Main.ctx, uri);
			}
			
			player.setAudioStreamType(AudioManager.STREAM_MUSIC);
			/* 设置Video影片以SurfaceHolder播放 */
			// player.setDisplay(surfaceView.getHolder());
			// player.setDataSource(videoFile.getAbsolutePath());
			player.prepare();// 缓冲
			player.setVolume(1, 1);
		}
	}

	public void play(String url) throws Exception
	{
		this.mediaURL = url;
		if (player != null)
		{
			stop();
		}
		play();
	}

	public void play()
	{
		try
		{
		if (player == null)
		{
			createPlayer();
		}
		if (player == null)
			throw new Exception("Creater player error: null.");
		if (player != null)
		{
			// player.close() ;
			// player.setMediaTime(new Time(1l));
			player.start();

		}
		}catch(Exception e )
		{
			e.printStackTrace();
		}
	}

	public void pause()
	{
		if (player != null)
		{
			if (!isPaused)
			{
				player.pause();
				isPaused = true;
			} else
			{
				player.start();
				isPaused = false;
			}
		}
	}

	public void stop()
	{
		if (player != null)
		{
			player.stop();
			player.release();
		}
		player = null;
		timex = 0;
		timeStr = "00:00";
		second = 0;
		dura = 0;
		duration = 0;
		isPaused = false;
		pausedTime = 0;
		// player=null;
	}

	public void run()
	{
		// String str = null;
		do
		{
			if (player != null)
			{

				long nano = player.getCurrentPosition();
				// if (dura >= 0L && dura < 0x9d29229e000L)
				// {
				// timex = (int) ( ( (float) nano / (float) dura) * 220F);
				// }

				// long time = nano / 0x3b9aca00L;
				// timex=(int)time;
				// int all = (int) (player.getDuration()/0x186a0L);
				// duration = (int)(dura/0x3b9aca00L);
				// if (all < 5940)
				// {
				// int bb = all;
				// int b11 = all / 60;
				// int b22 = bb % 60;
				// timeStr = "ALL TIME: " + b11 + "'" + b22;
				// }

				// ��ǰ�ļ����Ž���ʱ�жϽ����־������1������ǰ�ļ��Ĳ���
				// System.out .println(nano) ;
				if (nano >= dura - 300000)// 500000000
				{
					// System.out .println("dura:"+this.dura ) ;
					Thread.currentThread();
					stop();
					break;
				}
			} else
			{
				timeStr = "ALL TIME: 0'0";
			}
			try
			{
				Thread.currentThread();
				Thread.sleep(50L);
			} catch (InterruptedException _ex)
			{
			}
		} while (player != null);
	}
/*
	public final void playerUpdate(MediaPlayer player, String event, Object data)
	{

		if (event.equals(PlayerListener.END_OF_MEDIA)
				|| event.equals(PlayerListener.STOPPED))
		{
			// try
			{
				if (player != null)
				{
					// if (player.getState() == Player.STARTED)
					// {
					// player.stop();
					// }
					// if (player.getState() == Player.PREFETCHED)
					// {
					// player.deallocate();
					// }
					// if (player.getState() == Player.REALIZED ||
					// player.getState() == Player.UNREALIZED)
					// {
					// player.close();
					// }
					player.removePlayerListener(this);
					player.close();
				}
				player = null;
			}
			// catch (MediaException me)
			// {
			// }
		}

	}
*/
	private void searchnum(String clock)
	{
		if (clock.length() > 5 || clock == null)
		{
			return;
		} else
		{
			num[0] = Integer.parseInt(clock.substring(0, 1));
			num[1] = Integer.parseInt(clock.substring(1, 2));
			num[2] = Integer.parseInt(clock.substring(3, 4));
			num[3] = Integer.parseInt(clock.substring(4, 5));
			return;
		}
	}

	public String getTimeStr()
	{
		return timeStr;
	}

	public int getTimex()
	{
		return timex;
	}

	public int getSecond()
	{
		return second;
	}

	public int getDuration()
	{
		return duration;
	}

	public MediaPlayer getPlayer()
	{
		return player;
	}

	public boolean isPaused()
	{
		return this.isPaused;
	}
}
