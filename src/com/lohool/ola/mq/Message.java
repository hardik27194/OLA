package com.lohool.ola.mq;

public class Message
{
	//four number
	String msgId;
	//8 numbers, 
	int msgLength;
	String msg;
	
	public Message(String rawMsg)
	{
		msgId=rawMsg.substring(0,4);
		msgLength=Integer.parseInt(rawMsg.substring(4,12));
		msg=rawMsg.substring(12,msgLength);
	}
}
