package com.lohool.ola;

import org.keplerproject.luajava.LuaObject;
import org.keplerproject.luajava.LuaState;

public class MethodThread
{
	static MethodThread instance=null;
	//default sleep time in millisecond
	int interval=1000;
	//how many times to run the method,if it is 0, run it with endless until it was terminated
	int runTimes=0;
	boolean isStop=false;
/*
	public static MethodThread create()
	{
		return create(1000,0);
	}
	*/
	public static MethodThread create(int interval)
	{
		return create(interval,0);
	}
	
	private static MethodThread create(int interval,int runTime)
	{
		synchronized(MethodThread.class)
		{
		if(instance==null)instance=new MethodThread();
		}
		instance.interval=interval;
		instance.runTimes=runTime;
		return instance;
	}
	
	public void stop()
	{
		isStop=true;
	}
	public void reset()
	{
		isStop=false;
	}
	public void start(final String methodName)
	{
		new Thread() {
            public void run() {
            	boolean running=true;
            	int times=0;
            	int start=methodName.indexOf('(');
        		int end=methodName.indexOf(')');
        		String method=methodName.substring(0,start);
        		String paramstr=methodName.substring(start+1,end);
        		String[] params;
        		if(paramstr.trim().equals(""))params=new String[0];
        		else params=paramstr.split(",");
        		
        		LuaState lua=LuaContext.getInstance().getLuaState();
            	while((runTimes==0 || times<runTimes) && !isStop)
            	{
            		try{
	//            		LuaContext.getInstance().doString(onclick);
	            		
	            		lua.getField(LuaState.LUA_GLOBALSINDEX, method);
	            		 
	            		 for(int j=0;j<params.length;j++)
	            		 {
	            			 String p=params[j].trim();
	            			 System.out.println("param="+p);
	            			 if(p.startsWith("'") || p.startsWith("\"")) lua.pushString(p.substring(1,p.length()-1));
	            			 else if(p.charAt(0)>='0' && p.charAt(0)<='9') lua.pushNumber(Integer.parseInt(p));
	            			 else lua.pushJavaObject(p);
	            				 
	            		 }
	            		 lua.call(params.length,1);
	            		// save returned value to param "result"   
            	        lua.setField(LuaState.LUA_GLOBALSINDEX, "result");   
            	         
            	        // read result
            	        LuaObject lobj =lua.getLuaObject("result");   
            	        boolean isBreak=lobj.getBoolean();
            	        if(isBreak)break;
            		}catch(Exception e)
            		{
            			e.printStackTrace();
            		}
            	      
	            	try
	    			{
	    				Thread.sleep(interval);
	    			} catch (InterruptedException e)
	    			{
	    				// TODO Auto-generated catch block
	    				e.printStackTrace();
	    			}
            	times++;
            	}
            }
        }.start();
	}
}
