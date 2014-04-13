//
//  OLAProperties.m
//  Ola
//
//  Created by Terrence Xing on 3/20/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#import "OLAProperties.h"
#import "OLALuaContext.h"
#import "XMLDocument.h"
#import "XMLElement.h"
#import "OLAUIFactory.h"
#import "OLALog.h"
#import "OLAFileInputStream.h"
#import "OLAFileOutputStream.h"
#import "OLAStringUtil.h"

@implementation OLAProperties


/**
 * the main lua mobile properties
 * @author xingbao-
 *
 */

@synthesize appUrl,fileBase;
	

	NSString *  appName;
	NSString *  appPackage=@"";
	
	long installedTime;
	long lastUsedTime;
	
	/**
	 * the application's status
	 * 0, not installed; 1--new installed, first time executed; 2--exectued
	 */
	int state=1;
	
    OLALuaContext * lua;
    

	 static OLAProperties * instance;

+  (OLAProperties *) getInstance
{
    @synchronized(self){  //为了确保多线程情况下，仍然确保实体的唯一性
        
        if (!instance) {
            
            instance=[[self alloc] init]; //该方法会调用 allocWithZone
            [instance initiate];

        }
        
        
    }
    
    return instance;
}


	-(void) initiate
	{
        globalScripts =[[NSMutableArray alloc] initWithCapacity:1];
        initScripts = [[NSMutableArray alloc] initWithCapacity:1];
        views = [[NSMutableArray alloc] initWithCapacity:1];
		lua=[OLALuaContext getInstance];
        [lua doFile:@"OLA.lua"];
        appUrl=[lua getGlobalString:@"OLA.base"];
        fileBase=[lua getGlobalString:@"OLA.storage"];
        //[lua setGlobal:[self getRootPath] withId:@"OLA.storage"];
        NSMutableString * storage=[[NSMutableString alloc] initWithString:@"OLA.storage='"];
        [storage appendString:[self getRootPath]];
        //[storage appendString:@"/"];
        //[storage appendString:fileBase];
        [storage appendString:@"'"];
        [lua doString:storage];
        
        
        
		[lua regist:self withGlobalName:@"LMProperties" ];
        [lua registClass:[OLALog class] withGlobalName:@"_Log"];
        [lua doFile:@"Log.lua"];
        

        [lua registClass:[OLAFileInputStream class] withGlobalName:@"fis"];
        
        [lua registClass:[OLAFileOutputStream class] withGlobalName:@"fos"];
        [lua registClass:[OLAStringUtil class] withGlobalName:@"str"];
        
        /*
		
		lua regist(FileConnector.class withGlobalName:@"FileConnector");
		
		lua regist(DES3Encrypt.class  withGlobalName:@"des3");
		lua regist(StringUtil.class  withGlobalName:@"str");
		
         */
		[self loadXML];
         
	}
	

	- (NSString *)  getRootPath
	{
        NSLog(@"get root path...");
         NSString *homeDirectory = NSHomeDirectory();
		return  [[homeDirectory stringByAppendingString:@"/"] stringByAppendingString:fileBase];
	}


    
	-  (void) loadXML
{
    NSString * xml=[OLAUIFactory  loadResourceTextDirectly:[appUrl stringByAppendingString:@"Main.xml"]];

    NSData * xmlData= [xml dataUsingEncoding:NSUTF8StringEncoding];
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:xmlData];
    XMLDocument *parser = [[XMLDocument alloc] initXMLParser];
    [xmlParser setDelegate:parser];
    [xmlParser parse];
    
    
    [self parse:parser.root];
    /*

            XMLProperties xmlRoot = new XMLProperties(UIFactory.loadResourceTextDirectly(appUrl+"Main.xml"));
            System.out.print(UIFactory.loadResourceTextDirectly(appUrl+"Main.xml"));
            Element html = xmlRoot.getRootElement();
            parse(html);
     */

	}

-(void) parse:(XMLElement * )root
	{
		for(XMLElement * n in root.children)
        {
            NSLog(@"main xml tag=%@",n.tagName);
                if ([n.tagName caseInsensitiveCompare:@"app-name"]==NSOrderedSame)
                {
                    appName= n.textContent.value;
                }
                else if ([n.tagName caseInsensitiveCompare:@"global"]==NSOrderedSame)
                {
                    [self parseGlobalScripts:n];
                }
                else if ([n.tagName caseInsensitiveCompare:@"init"]==NSOrderedSame)
                {
                    [self parseInitScripts:n];
                }
                else if ([n.tagName caseInsensitiveCompare:@"views"]==NSOrderedSame)
                {
                    
                    [self parseViews:n];
                }

		}
	}

-(void) parseGlobalScripts:(XMLElement *) root
	{
		for(XMLElement * n in root.children)
        {
                if ([n.tagName caseInsensitiveCompare:@"script"]==NSOrderedSame)
                {
                    NSString *  src=[n.attributes objectForKey:@"src"];
                    [globalScripts addObject:src];

                }
		}
	}
-(void) parseInitScripts:(XMLElement *) root
{
    for(XMLElement * n in root.children)
    {
        if ([n.tagName caseInsensitiveCompare:@"script"]==NSOrderedSame)
        {
            NSString *  src=[n.attributes objectForKey:@"src"];
            [initScripts addObject:src];
            
        }
    }
}
-(void) parseViews:(XMLElement *) root
	{
		for(XMLElement * n in root.children)
        {
                if ([n.tagName caseInsensitiveCompare:@"view"]==NSOrderedSame)
                {
                    NSString *  src=[n.attributes objectForKey:@"src"];
                    [views addObject:src];
                }
		}
	}
	- (NSString *)  getFirstViewName
	{
		NSString *  name=nil;
		if(views.count>0)name= (NSString *)[views firstObject];
		return [appUrl stringByAppendingString:name];
	}
	-(void) execInitScripts
	{
		for(NSString *  src in initScripts)
		{
			
			[lua doString:[OLAUIFactory loadResourceTextDirectly:[appUrl stringByAppendingString:src]]];//  .doNSString * (UIFactory.loadResourceTextDirectly(src));
		}
	}
	-(void) execGlobalScripts
	{
		for(NSString *  src in globalScripts)
		{
            NSLog(@"execute global scripts,src=%@",src);
            [lua doString:[OLAUIFactory loadResourceTextDirectly:[appUrl stringByAppendingString:src]]];
		}
	}


@end
