package com.lohool.ola;



/**
 * the main lua mobile properties
 * @author xingbao-
 *
 */
public class AppProperties extends AbstractProperties{
	
//	static AppProperties instance;
	AppProperties(String applicationName)
	{
		 super();
//    	 appBase="apps/";
    	 appServer="";
    	
    	 this.appName=applicationName;;
    	 isPlatformApp=false;
    	 
    	 initiateLuaContext();
    	 loadXML();
// 		instance=this;
	}

	public void exit()
	{
		
		PortalProperties.getInstance().reset();
    	BodyView v=null;
    	String name=PortalProperties.getInstance().getFirstViewName();
        if(name!=null)
        {
			v=new BodyView(Main.ctx,name);				
			UIFactory.viewCache.put(name, v);
        }
        v.show();
//        instance=null;
      //android Fatal signal 11
//		lua.close();
	}

//	public static AppProperties getInstance()
//	{
//		return (AppProperties)instance;
//	}
	@Override
	void reset()
	{
		// TODO Auto-generated method stub
		
	}
}

