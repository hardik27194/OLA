package com.lohool.ola;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.net.ConnectException;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;

import android.annotation.SuppressLint;

import android.util.Log;


import com.lohool.ola.wedgit.IProgressBar;
import com.lohool.ola.wedgit.UIMessage;


/**
 * For Lua
 * 
 * @author xingbao-
 * 
 */
@SuppressLint("NewApi")
public class HTTP
{
	IProgressBar bar;

	String processingCallback;
	String complitedCallback;

	URL url ;
	
	 private String cookies; 
	
//	StringBuffer buf=new StringBuffer();
	ByteArrayOutputStream out= new ByteArrayOutputStream();
	String content;
	Download down = new Download();
	int state = -1;
	public HTTP()
	{
		
	}
	public HTTP(String Url)
	{
		try
		{
			url= new URL(Url);
		} catch (MalformedURLException e)
		{
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	public static HTTP create(String url)
	{
		return new HTTP(url);
	}
	
	public void sendRequest()
	{
		state=0;
		Thread t = new Thread(down);
		t.start();
	}
	
	/**
	 * waiting for the end of HTTP request
	 */
	public void receive()
	{
		//HTTP request is not sent
		if(getState()==-1)return;
		
		while(getState()!=2 && getState()>=-1)
		{
			try
			{
				Thread.sleep(50);
			} catch (InterruptedException e)
			{
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}

	
	public void setProcessingCallback(String callback)
	{
		this.processingCallback=callback;
	}
	public void setComplitedCallback(String callback)
	{
		this.complitedCallback=callback;
	}
	
	public void setProgressBar(IProgressBar bar)
	{
		this.bar = bar;
	}
	public void setProgressBar(String barId)
	{
		
		this.bar = (IProgressBar)(LuaContext.getInstance().getObject(barId));
	}



	private class Download implements Runnable
	{

		int total = 0;
		int process = 0;
		
		String err = "";
		@Override
		public void run()
		{
			state = 0;
			UIMessage msg=new UIMessage();

			if (url != null)
			{
				InputStream isread = null;

				HttpURLConnection urlConn =null;
				byte[] bs = new byte[2048];
				try
				{
					
					urlConn = (HttpURLConnection) url.openConnection();
					urlConn.setConnectTimeout(10000);
					if(cookies!=null)
                    {
                        urlConn.setRequestProperty("Cookie",cookies);
                    }
					
					InputStream in = urlConn.getInputStream();
			
					String key;
                    for (int i = 1; (key = urlConn.getHeaderFieldKey(i)) != null; i++)
                    {
                        if (key.equalsIgnoreCase("set-cookie"))
                        {
                            cookies = urlConn.getHeaderField(i);
                            break;
                        }
                    }
					System.out.println("currentUrl:"+url.toString());
					int i = 1;


					int count = 0;
					total = urlConn.getContentLength();
					state = 1;
					
					while (-1 != (count = in.read(bs)))
					{
						//System.out.println("Total:"+total+"; read bytes:"+count);
						//buf.append(new String(bs,"utf-8"));
						out.write(bs, 0, count);
						process += count;
						if (bar != null)
						{
							int percent = (int) ((1.0d * process / total) * 100);
							bar.setValue(percent);
						}
						if(processingCallback!=null)
						{
							String callback=processingCallback.trim();
							//find the last char")"
							int pos=callback.lastIndexOf(')');
							callback=callback.substring( pos);
							String luaCallback=callback+","+state+","+total+","+process+")";
							msg.updateMessage(luaCallback);
						}
						
						try
						{
							Thread.sleep(50);
						} catch (InterruptedException e)
						{
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
					}

					state = 2;
				}
				catch (ConnectException e1)
				{
					err = e1.toString();
					state = -2;
					e1.printStackTrace();
				}
				catch (IOException e1)
				{
					err = e1.toString();
					state = -3;
					e1.printStackTrace();
				}
				 finally
				{
					if(urlConn!=null)
					{
						urlConn.disconnect();
					}
					if (isread != null)
					{
						try
						{
							isread.close();

						} catch (IOException e)
						{
						}
					}
					
					
				}
				
				try
				{
					content=out.toString("utf-8");
				} catch (UnsupportedEncodingException e1)
				{
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}
				try
				{
					out.close();
				} catch (IOException e1)
				{
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}

				if(complitedCallback!=null)
				{
//					String callback=complitedCallback.trim();
//					//find the last char")"
//					int pos=callback.lastIndexOf(')');
//					callback=callback.substring(0, pos).trim();
//					String luaCallback;
//					if(callback.charAt(callback.length()-1)!='(')
//						luaCallback=callback+state+",\""+content+"\")";
//					else luaCallback=callback+","+state+",\""+content+"\")";
					Log.i("HTTP", complitedCallback);
					Response res=new Response();
					res.state=state;
					res.content=content;
					res.cookies=cookies;
					LuaContext lua=LuaContext.getInstance();
            		lua.regist(res, "HttpResponse");
            	    msg.updateMessage(complitedCallback+"(HttpResponse)");
            	    lua.remove("HttpResponse");
				}
				try
				{
					Thread.sleep(100);
				} catch (InterruptedException e)
				{
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
		
			}
			System.out.println("end download..");
		}

	}
	

    public void setCookies(String cookies)
    {
        this.cookies=cookies;
    }
    public String getCookies()
    {
        return cookies;
    }
    
    
	class Response
	{
		int state;
		String cookies;
		String content;
		public int getState()
		{
			return state;
		}
		public String getContent()
		{
			return content;
		}
		public String getCookies()
        {
            return cookies;
        }
	}
	
	/**
	 * -1:error,0: prepare,1: downloading, 2: complited
	 * 
	 * @return
	 */
	public int getState()
	{
		return state;
	}

	public String getError()
	{
		return down.err;
	}

	public int getTotalSize()
	{
		return down.total;
	}

	public int getValue()
	{
		return down.process;
	}

	public String getUrl()
	{
		if (url != null)
			return url.toString();
		else
			return "";
	}
	public String getContent()
	{
		return content;
	}

	
    
    
//   public void executeGet(String url) throws ClientProtocolException, IOException{  
//       HttpClient httpClient=new DefaultHttpClient();  
// 
//       HttpGet httpGet=new HttpGet(url);  
//       setRequestCookies(httpGet);  
// 
//        HttpResponse response=httpClient.execute(httpGet);  
//        appendCookies(response);  
//    }  
//    /** 
//     * 设置请求的Cookie头信息 
//     * @param reqMsg 
//     */  
//    private void setRequestCookies(HttpMessage reqMsg) {  
//        if(!TextUtils.isEmpty(cookies)){  
//            reqMsg.setHeader("Cookie", cookies);  
//        }  
//    }  
//    /** 
//     * 把新的Cookie头信息附加到旧的Cookie后面 
//     * 用于下次Http请求发送 
//     * @param resMsg 
//     */  
//    private void appendCookies(HttpMessage resMsg) {  
//        Header setCookieHeader=resMsg.getFirstHeader("Set-Cookie");  
//        if (setCookieHeader != null  
//                && TextUtils.isEmpty(setCookieHeader.getValue())) {  
//            String setCookie=setCookieHeader.getValue();  
//            if(TextUtils.isEmpty(cookies)){  
//                cookies=setCookie;  
//            }else{  
//                cookies=cookies+"; "+setCookie;  
//            }  
//        }  
//    }  

}

