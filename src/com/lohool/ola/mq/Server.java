package com.lohool.ola.mq;

import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.ServerSocket;
import java.net.SocketException;

public class Server
{
	Thread t;
	boolean server_running;
	String serverAddress;
	int port=6000;
	public void start() throws SocketException
	
	{
		
		final DatagramSocket socket = new  DatagramSocket (port);

        //mudlog.tracef(1, "Game started. Waiting for connections...");
        server_running = true;

        //System.setSecurityManager(new security_handler());


        t = new Thread() {

            public void run() {
                try {
                    //while (true) 
                	while (Thread.currentThread() == t)
                    {
                    		byte data[] = new byte[1024];
                			DatagramPacket dp = new DatagramPacket(data , data.length);
                			socket.receive(dp); 
                			String rawMsg=new String(dp.getData() , dp.getOffset() , dp.getLength());
                			Message msg=new Message(rawMsg);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        };

        t.start();
        
	}
	
	
	
	public void stop()
	{
		if (t != null)
		{
			t.stop();
			t = null;
		}
	}
}
