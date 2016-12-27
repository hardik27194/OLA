//
//  OLAUIFactory.m
//  Ola
//
//  Created by Terrence Xing on 3/20/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#import "OLAUIFactory.h"
#import "OLABodyView.h"
#import "OLAView.h"
#import "OLALayout.h"
#import "XMLDocument.h"
#import "XMLElement.h"
#import "OLALinearLayout.h"
#import "OLAFrameLayout.h"
#import "OLARelativeLayout.h"
#import "OLALuaContext.h"
#import "OLAButton.h"
#import "OLATable.h"
#import "OLALabel.h"
#import "OLATableRow.h"
#import "OLATextField.h"
#import "OLAScrollView.h"
#import "OLAProperties.h"
#import "OLAProgressBar.h"
#import "OLAPortalProperties.h"
#import "OLAAppProperties.h"
#import "OLA.h"
#import "OLARoundImage.h"
#import "OLALineChart.h"
#import "OLAWebView.h"

@implementation OLAUIFactory


@synthesize  ctx,bodyView;


static NSMutableDictionary * viewCache;
	

+ (NSMutableDictionary * )getViewCache
{
    @synchronized(self)
    {
        if(viewCache==nil)
        {
            viewCache = [[NSMutableDictionary alloc] initWithCapacity:5];
        }
    }
    return viewCache;
}

- (id) initWithContext:(OLABodyView *) olaBodyView withContext:(OLAView *) context;
	{
        self=[super init];
		[self setBodyView:olaBodyView];
        [self setCtx:context];
        return self;
	}

- (void) switchView:(NSString *) viewName callback:(NSString *) callback  params:(NSString  *) params
	{
        NSLog(@"switch view name=%@",viewName);
        [self switchView:viewName callback:callback params:params needReload:NO];
	}
	
- (void) switchView:(NSString *)viewName callback:(NSString *) callback  params:(NSString *) params  needReload:(BOOL) needReload
    {
        NSMutableDictionary * viewCache = [OLAUIFactory getViewCache];
        
        //OLAProperties * prop = [OLAProperties getInstance];
        //NSString * name=[prop.appUrl stringByAppendingString:viewName];
        NSString * name=[[OLA getAppBase] stringByAppendingString:viewName];
        
        //run the exit function of the old view
        
        OLALuaContext* preLuaCtx=[OLALuaContext getInstance];
        
        
		OLABodyView *v;
		id obj=[viewCache objectForKey:name];
		if(obj!=nil && !needReload)
		{
			v=(OLABodyView *)obj;
		}
		else
		{
            //v=new BodyView(ctx,name);
            v=[[OLABodyView alloc] initWithViewController:self.ctx andViewXMLUrl:name];
            if(!needReload) [viewCache setObject:v forKey:name];//viewCache.put(name, v);
		}
        NSLog(@"cache size 2=%d",viewCache.count);
        v.parameters=params;
        
        
		[v show];
        [preLuaCtx doString:@"exit()"];
        
        // do not close or set the preLuaCtx to nil, since in IOS, only one LuaCtx there which is used by the porttal and all of the apps.
        
        [v executeLua];
        [v execCallBack:callback];
        
    }

	- (NSString *) getParameters
{
		return bodyView.parameters;
	}

    //	public  Layout loadXML(String url)
    //	{
    //	 return loadXML(url,true);
    //	}


-(NSString*)getRootViewId
{
    return [self.bodyView.bodyLayout getId];
}



/**
	 * load and create an first Level Layout from an XML file
	 * @return
	 */
-  (OLALayout *) createLayout:(OLAView *) parentView withXMLFile:(NSString *) url
{
		OLALayout * layout = nil;
    
    NSString * xml=[OLAUIFactory loadResourceTextDirectly:url];
    //NSLog(@"xml=%@",xml);
    
    NSData * xmlData= [xml dataUsingEncoding:NSUTF8StringEncoding];
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:xmlData];
    XMLDocument *parser = [[XMLDocument alloc] initXMLParser];
    [xmlParser setDelegate:parser];
    [xmlParser parse];
    
    XMLElement * root= parser.root;

    layout= [self createActiveBody:parentView withXMLElement:root];

		return layout;
	}


- (NSString *)getTimeNow
{
    NSString* date;
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    //[formatter setDateFormat:@"YYYY.MM.dd.hh.mm.ss"];
    [formatter setDateFormat:@"YYYYMMddhhmmssSSSS"];
    date = [formatter stringFromDate:[NSDate date]];
     NSString* timeNow = [[NSString alloc] initWithFormat:@"%@", date];
    return timeNow;
}



	/**
	 * create a dynamic view by Lua script
	 * @param xml
	 * @return
	 */
- (NSString *) createView:(NSString *) xml
	{
		NSString *objId=nil;

        NSData * xmlData= [xml dataUsingEncoding:NSUTF8StringEncoding];
        NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:xmlData];
        XMLDocument *parser = [[XMLDocument alloc] initXMLParser];
        [xmlParser setDelegate:parser];
        [xmlParser parse];
        
        XMLElement * root= parser.root;
        
			objId=[root.attributes objectForKey:@"id"];
			if(objId==nil || [trim(objId) compare:@""]==NSOrderedSame)
			{
				objId=[[@"View_ID_" stringByAppendingString:[self getTimeNow]] stringByAppendingString:@"_"];//+arc4random() % 1000);
                
                [root.attributes setObject:objId forKey:@"id"];
			}
			
			OLAView *v=nil;
			if([root.tagName caseInsensitiveCompare:@"DIV"]==NSOrderedSame)
			{
				OLALayout *layout= [self createLayout:nil withXMLElement:root ];
				v=layout;
			}
        
			else if([root.tagName caseInsensitiveCompare:@"TR"]==NSOrderedSame)
			{
				v= [[OLATableRow alloc] initWithParent:nil andUIRoot:root andUIFactory:self];
			}
        
			else
			{
				//TODO
				OLAView *view= [self createView:nil withXMLElement:root];
				v=view;
			}
        [[OLALuaContext getInstance] regist:v withGlobalName:objId];
		
		
		return objId;
	}
    
- (OLALayout *) createActiveBody:(OLAView *) viewParent withXMLElement:(XMLElement *) xmlRoot
	{
		OLALayout *layout = nil;
		
        for(XMLElement *n in xmlRoot.children)
        {
            NSString * name=n.tagName;
            if([name caseInsensitiveCompare:@"body"]==NSOrderedSame)
            {
                /*
                 set the full screen size to the body layout, do not allow the system to auto caculate the size of the body view
                 */
                NSLog(@"body start tag=%@",name);
                NSLog(@"body start repaint=%@",[n.attributes objectForKey:@"id"]);
                
                NSMutableString *css=[[NSMutableString alloc]initWithString:[n.attributes objectForKey:@"style"]];
               // NSString * css=[n.attributes objectForKey:@"style"];
                if(![css hasSuffix:@";"])[css appendString:@";"];
                [css appendFormat:@"width:%gpx;",viewParent.v.frame.size.width];
                [css appendFormat:@"height:%gpx;",viewParent.v.frame.size.height];
                //css=[[[css stringByAppendingString:@"width:"] stringByAppendingString:[NSString stringWithFormat:@"%g",viewParent.v.frame.size.width]] stringByAppendingString:@"px;"];
                //css=[[[css stringByAppendingString:@"height:"] stringByAppendingString:[NSString stringWithFormat:@"%g",viewParent.v.frame.size.height]] stringByAppendingString:@"px;"];
                [n.attributes setObject:css forKey:@"style"];
                
                layout= [self createLayout:viewParent withXMLElement:n];
                
                NSLog(@"body start repaint");
                //set min or max frame of subviews
                [(Layout *)layout.v repaint];
                //[(Layout *)layout.v setFrameMinSize];
                //reset auto fitted subviews to fit its parents
                //[(Layout *)layout.v repaint];
                
                
            }
        }
        NSLog(@"end create active body view layout");
		return layout;
	}
- (NSString *) loadLayoutLuaCode:(NSString *) xmlUrl
	{
		NSString * temp = [OLAUIFactory loadAssert:[xmlUrl stringByAppendingString:@".lua"]];
		return temp;
	}



-  (OLALayout *) createLayout:(OLAView *)parentView  withXMLElement:(XMLElement *) root
{
    NSString * layoutName=trim([root.attributes objectForKey:@"layout"]);
    
    OLALayout * v=nil;
    NSLog(@"layoutName=%@",layoutName);
    if([layoutName caseInsensitiveCompare:@"FrameLayout"]==NSOrderedSame)
    {
        v=[[OLAFrameLayout alloc] initWithParent:parentView andUIRoot:root andUIFactory:self];
    }
    else if([layoutName caseInsensitiveCompare:@"LinearLayout"]==NSOrderedSame)
    {
        v=[[OLALinearLayout alloc] initWithParent:parentView andUIRoot:root andUIFactory:self];
    }
    else if([layoutName caseInsensitiveCompare:@"RelativeLayout"]==NSOrderedSame)
    {
        v=[[OLARelativeLayout alloc] initWithParent:parentView andUIRoot:root andUIFactory:self];
        
    }
    
    
    return v;
}



	
- (OLAView *) createView:(OLAContainer *) rootView withXMLElement:(XMLElement *) n
	{
		OLAView *v=nil;
		NSString * name=n.tagName;
    	if ([name caseInsensitiveCompare:@"BUTTON"]==NSOrderedSame )
    	{
    		v= [[OLAButton alloc] initWithParent:rootView withXMLElement:n andUIFactory:self];
    		
    	}
        
    	else if ([name caseInsensitiveCompare:@"LABEL"]==NSOrderedSame )
    	{
    		v= [[OLALabel alloc] initWithParent:rootView withXMLElement:n andUIFactory:self];

    	}
        
    	else if ([name caseInsensitiveCompare:@"TEXTFIELD"]==NSOrderedSame )
    	{
    		v= [[OLATextField alloc] initWithParent:rootView withXMLElement:n andUIFactory:self];
    		//rootView.addView(text);
    	}
        
        else if ([name caseInsensitiveCompare:@"PASSWORD"]==NSOrderedSame )
    	{
    		v= [[OLATextField alloc] initWithParent:rootView withXMLElement:n andUIFactory:self];
    		//rootView.addView(text);
    	}
        
    	else if ([name caseInsensitiveCompare:@"TABLE"]==NSOrderedSame )
    	{
    		v= [[OLATable alloc] initWithParent:rootView andUIRoot:n andUIFactory:self];
    		//rootView.addView(text);
    	}
        
    	else if ([name caseInsensitiveCompare:@"SCROLLVIEW"]==NSOrderedSame )
    	{
    		v= [[OLAScrollView alloc] initWithParent:rootView withXMLElement:n andUIFactory:self];
    		//rootView.addView(text);
    	}
        else if ([name caseInsensitiveCompare:@"PROGRESSBAR"]==NSOrderedSame )
    	{
    		v= [[OLAProgressBar alloc] initWithParent:rootView withXMLElement:n andUIFactory:self];
    	}
        else if ([name caseInsensitiveCompare:@"ROUNDIMAGE"]==NSOrderedSame )
    	{
    		v= [[OLARoundImage alloc] initWithParent:rootView withXMLElement:n andUIFactory:self];
    	}
        else if ([name caseInsensitiveCompare:@"LINECHART"]==NSOrderedSame )
    	{
    		v= [[OLALineChart alloc] initWithParent:rootView withXMLElement:n andUIFactory:self];
    	}
        else if ([name caseInsensitiveCompare:@"WEBVIEW"]==NSOrderedSame )
    	{
    		v= [[OLAWebView alloc] initWithParent:rootView withXMLElement:n andUIFactory:self];
    	}
         
    	return v;
	}

	
+ (NSString *) loadResourceTextDirectly:(NSString *) resPath
{
        /*
		if([resPath hasPrefix:@"http://"] )//.startsWith("http://"))
        {
            //return loadOnline(resPath);
        }
		else
            */
            return [OLAUIFactory loadAssert:resPath];
        
	}
/*
	public static String loadOnline(String resPath) {
        
		InputStream isread = null;
		StringBuffer buf = new StringBuffer();
		byte[] luaByte = new byte[0];
		try {
			isread = UIFactory.getInputStreamFromUrl(resPath);
            
			int len = 0;
			while ((len = isread.available()) > 0) {
				luaByte = new byte[len];
				isread.read(luaByte);
				buf.append(EncodingUtils.getString(luaByte, "UTF-8"));
			}
		} catch (Exception e1) {
			e1.printStackTrace();
		} finally {
			if (isread != null) {
				try {
					isread.close();
				} catch (IOException e) {
				}
			}
		}
		return buf.toString();
        
	}
 */
	
+  (NSString *) loadAssert:(NSString *) resPath
{
        NSFileManager *fm = [NSFileManager defaultManager];
        //NSString *homeDirectory = NSHomeDirectory();
        NSLog(@"assert file=%@",resPath);
        NSData *data = [fm contentsAtPath:resPath];
        NSString *text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return text;
	}
    


@end
