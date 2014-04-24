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
#import "OLALuaContext.h"
#import "OLAButton.h"
#import "OLATable.h"
#import "OLALabel.h"
#import "OLATableRow.h"
#import "OLATextField.h"
#import "OLAScrollView.h"
#import "OLAProperties.h"
#import "OLAProgressBar.h"

@implementation OLAUIFactory


@synthesize  bodyView;


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

- (id) initWithBodyView:(OLAView *) bodyViewObj
	{
        self=[super init];
		bodyView=bodyViewObj;
        return self;
	}

- (void) switchView:(NSString *) viewName callback:(NSString *) callback  params:(NSString  *) params
	{
        [self switchView:viewName callback:callback params:params needReload:NO];
	}
	
- (void) switchView:(NSString *)viewName callback:(NSString *) callback  params:(NSString *) params  needReload:(BOOL) needReload
    {
        NSMutableDictionary * viewCache = [OLAUIFactory getViewCache];
        
        OLAProperties * prop = [OLAProperties getInstance];
        NSString * name=[prop.appUrl stringByAppendingString:viewName];
		OLABodyView *v;
		id obj=[viewCache objectForKey:name];
        NSLog(@"cache size 1=%d",viewCache.count);
		if(obj!=nil && !needReload)
		{
			v=(OLABodyView *)obj;
		}
		else
		{
            //v=new BodyView(ctx,name);
            v=[[OLABodyView alloc] initWithViewController:bodyView andViewXMLUrl:name];
            if(!needReload) [viewCache setObject:v forKey:name];//viewCache.put(name, v);
            
		}
        NSLog(@"cache size 2=%d",viewCache.count);
        v.parameters=params;
        [v execCallBack:callback];
		[v show];
        
    }
 /*
	- (NSString *) getParameters
{
		return bodyView.parameters;
	}
	*/
    //	public  Layout loadXML(String url)
    //	{
    //	 return loadXML(url,true);
    //	}






/**
	 * load and create an first Level Layout from an XML file
	 * @return
	 */
-  (OLALayout *) createLayout:(OLAView *) parentView withXMLFile:(NSString *) url
{
		OLALayout * layout = nil;
    
    NSString * xml=[OLAUIFactory loadResourceTextDirectly:url];
    
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
				OLALayout *layout= [OLALayout createLayout:nil withXMLElement:root];
				v=layout;
			}
        
			else if([root.tagName caseInsensitiveCompare:@"TR"]==NSOrderedSame)
			{
				v= [[OLATableRow alloc] initWithParent:nil andUIRoot:root];
			}
        
			else
			{
				//TODO
				OLAView *view= [OLAUIFactory createView:nil withXMLElement:root];
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
                
                NSString * css=[n.attributes objectForKey:@"style"];
                css=[[[css stringByAppendingString:@"width:"] stringByAppendingString:[NSString stringWithFormat:@"%g",viewParent.v.frame.size.width]] stringByAppendingString:@"px;"];
                css=[[[css stringByAppendingString:@"height:"] stringByAppendingString:[NSString stringWithFormat:@"%g",viewParent.v.frame.size.height]] stringByAppendingString:@"px;"];
                [n.attributes setObject:css forKey:@"style"];
                
                layout= [OLALayout createLayout:viewParent withXMLElement:n];
                
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
+ (NSString *) loadLayoutLuaCode:(NSString *) xmlUrl
	{
		NSString * temp = [OLAUIFactory loadAssert:[xmlUrl stringByAppendingString:@".lua"]];
		return temp;
	}
    
	
+ (OLAView *) createView:(OLAContainer *) rootView withXMLElement:(XMLElement *) n
	{
		OLAView *v=nil;
		NSString * name=n.tagName;
    	if ([name caseInsensitiveCompare:@"BUTTON"]==NSOrderedSame )
    	{
    		v= [[OLAButton alloc] initWithParent:rootView withXMLElement:n];
    		
    	}
        
    	else if ([name caseInsensitiveCompare:@"LABEL"]==NSOrderedSame )
    	{
    		v= [[OLALabel alloc] initWithParent:rootView withXMLElement:n];

    	}
        
    	else if ([name caseInsensitiveCompare:@"TEXTFIELD"]==NSOrderedSame )
    	{
    		v= [[OLATextField alloc] initWithParent:rootView withXMLElement:n];
    		//rootView.addView(text);
    	}
        
    	else if ([name caseInsensitiveCompare:@"TABLE"]==NSOrderedSame )
    	{
    		v= [[OLATable alloc] initWithParent:rootView andUIRoot:n];
    		//rootView.addView(text);
    	}
        
    	else if ([name caseInsensitiveCompare:@"SCROLLVIEW"]==NSOrderedSame )
    	{
    		v= [[OLAScrollView alloc] initWithParent:rootView withXMLElement:n];
    		//rootView.addView(text);
    	}
        else if ([name caseInsensitiveCompare:@"PROGRESSBAR"]==NSOrderedSame )
    	{
    		v= [[OLAProgressBar alloc] initWithParent:rootView withXMLElement:n];
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
        
        NSData *data = [fm contentsAtPath:resPath];
        NSString *text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return text;
	}
    


@end
