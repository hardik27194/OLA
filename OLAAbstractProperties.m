//
//  OLAAbstractProperties.m
//  Ola
//
//  Created by Terrence Xing on 6/17/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//



#import "OLAAbstractProperties.h"
#import "OLA.h"
#import "OLALuaContext.h"
#import "XMLDocument.h"
#import "XMLElement.h"
#import "OLAUIFactory.h"
#import "OLALog.h"
#import "OLAFileInputStream.h"
#import "OLAFileOutputStream.h"
#import "OLAStringUtil.h"
#import "OLASoundPlayer.h"
#import "OLAUIMessage.h"
#import "OLAAsyncDownload.h"
#import "OLAZipUtil.h"
#import "OLAHTTP.h"
#import "lua.h"
#import "lualib.h"
#import "lauxlib.h"
#import "OLADatabase.h"
#import "OLAMethodThread.h"

@implementation OLAAbstractProperties


/**
 * the main lua mobile properties
 * @author xingbao-
 *
 */

@synthesize fileBase,currentApp,appName,lua;

/*
NSString *  appName;
NSString *  appPackage=@"";

long installedTime;
long lastUsedTime;

int state=1;

OLALuaContext * lua;
*/

static id  instance;
/*
+  (id ) getInstance
{
    @synchronized(self){  //为了确保多线程情况下，仍然确保实体的唯一性
        
        if (!instance) {
            
            instance=[[self alloc] init]; //该方法会调用 allocWithZone
            [instance initiate];
            
        }
        
        
    }
    
    return instance;
}
*/

-(id) init
{
    self=[super init];
    appBase=@"apps/";
	appServer=@"";
	mode=@"developement";
    fileBase=@"";

	appPackage=@"";
	sandboxRoot=@".";

	
	os=@"IOS";
	version=1.0;
	
	isPlatformApp=NO;
	state=1;
    return self;
}

-(void) initiateLuaContext
{
    
    lua=[OLALuaContext getInstance];
    [OLALuaContext registInstance:lua];
    sandboxRoot=NSHomeDirectory();
    
    [lua regist:self withGlobalName:@"LMProperties" ];
    [lua registClass:[OLALog class] withGlobalName:@"_Log"];
    [lua doFile:@"Log.lua"];
    
    
    [lua registClass:[OLAFileInputStream class] withGlobalName:@"fis"];
    
    [lua registClass:[OLAFileOutputStream class] withGlobalName:@"fos"];
    [lua registClass:[OLAStringUtil class] withGlobalName:@"str"];
    
    [lua registClass:[OLASoundPlayer class] withGlobalName:@"MediaPlayer"];
    [lua registClass:[OLAUIMessage class] withGlobalName:@"uiMsg"];
    [lua registClass:[OLAAsyncDownload class] withGlobalName:@"AsyncDownload"];
    
    [lua registClass:[OLAHTTP class] withGlobalName:@"HTTP"];
    [lua registClass:[OLAZipUtil class] withGlobalName:@"Zip"];
    
    [lua registClass:[OLAMethodThread class] withGlobalName:@"Thread"];
    
    /*
     
     lua regist(FileConnector.class withGlobalName:@"FileConnector");
     
     lua regist(DES3Encrypt.class  withGlobalName:@"des3");
     */
    
     [lua registClass:[OLADatabase class] withGlobalName:@"DBConn"];
    
    
    globalScripts =[[NSMutableArray alloc] initWithCapacity:1];
    initScripts = [[NSMutableArray alloc] initWithCapacity:1];
    views = [[NSMutableArray alloc] initWithCapacity:1];
    
    [lua doFile:@"OLA.lua"];
    //[lua doFile:@"assets/olaos/lua/test.lua"];
    //[lua doFile:@"assets/olaos/lua/JSON4Lua.lua"];
    
    
    mode=[lua getGlobalString:@"OLA.mode"];
    appBase=[lua getGlobalString:@"OLA.base"];
    appServer=[lua getGlobalString:@"OLA.app_server"];
    if(appServer==nil)appServer=@"";
    
    //appBase=[sandboxRoot stringByAppendingString: appBase];
    
     NSFileManager *fileManager = [NSFileManager defaultManager];
    
    
    OLA.appBase=[appBase stringByAppendingFormat:@"%@/",appName];
    OLA.base=appBase;
    
    //sdcard dir
    fileBase=[lua getGlobalString:@"OLA.storage"];
    

    //[lua setGlobal:[self getRootPath] withId:@"OLA.storage"];
    NSMutableString * tmp=[[NSMutableString alloc] initWithString:[self getRootPath]];
    [tmp appendString:@"/"];
    [tmp appendString:fileBase];
    fileBase=tmp;
    
   if(![fileManager fileExistsAtPath:fileBase])
   {
       [fileManager createDirectoryAtPath:fileBase withIntermediateDirectories:TRUE attributes:nil error:nil];
   }
    
    //Get documents directory
    //NSArray *directoryPaths = NSSearchPathForDirectoriesInDomains  (NSDocumentDirectory, NSUserDomainMask, YES);
    //NSString *documentsDirectoryPath = [directoryPaths objectAtIndex:0];
    if ([fileManager fileExistsAtPath:fileBase]==NO) {
         BOOL bo = [[NSFileManager defaultManager] createDirectoryAtPath:fileBase withIntermediateDirectories:YES attributes:nil error:nil];
        if(!bo)
        {
            NSLog(@"Error to create folder:%@",fileBase);
        }
    }
    
    

    
    NSMutableString * storage=[[NSMutableString alloc] initWithString:@"OLA.storage='"];
    //[storage appendString:[self getRootPath]];
    //[storage appendString:@"/"];
    [storage appendString:fileBase];
    [storage appendString:@"'"];
    [lua doString:storage];
    
    [lua doString:[@"OLA.app_path=" stringByAppendingFormat:@"'%@'",NSHomeDirectory()]];
    
    
    lua_State *L=[lua getLuaState];
    NSString *json=[OLAUIFactory  loadResourceTextDirectly:@"assets/olaos/lua/JSON4Lua.lua"];
    const char *cJson=[json UTF8String];
    //NSLog(@"cJson=%s",cJson);
    //int errCode=luaL_loadbuffer(L, cJson, strlen(cJson) ,"JSON4Lua");
    //const char * err=lua_tostring(L, -1);
    //NSLog(@"lua error(code=%i)=%s",errCode,err);
    
    lua_getglobal(L, "package");            // package
    /*
    lua_getfield(L, -1, "loaders");// L.getField(-1, "loaders");         // package loaders
    int nLoaders = lua_objlen(L, -1);// L.objLen(-1);       // package loaders
    lua_pushcfunction(L, assetLoader);
    // package loaders loader
    lua_rawseti(L, -2, nLoaders+1);//L.rawSetI(-2, nLoaders + 1);       // package loaders
    lua_pop(L, 1);// L.pop(1);                          // package
    */
    lua_getfield(L, -1, "path");// L.getField(-1, "path");            // package path
    const char * value=lua_tostring(L, -1);
    NSLog(@"app base=%@",appBase);
    NSLog(@"package.path=%s",value);
    NSMutableString *path= [[NSMutableString alloc] initWithString:@";"];
    [path appendFormat:@"%@%@",sandboxRoot,@"/Ola.app/assets/lua/?.lua"];
    [path appendFormat:@"%@%@",sandboxRoot,@"/lua/?.lua"];
    [path appendFormat:@";%@",@"assets/lua/?.lua"];

    //NSString *customPath =[@";" stringByAppendingFormat:@"%@%@",sandboxRoot,@"/lua/?.lua"];
    lua_pushstring(L, [path UTF8String]);// L.pushString(";" + customPath);    // package path custom
    lua_concat(L, 2);// L.concat(2);                       // package pathCustom
    lua_setfield(L, -2, "path"); //L.setField(-2, "path");            // package
    lua_pop(L, 1);// L.pop(1);
    
}

- (void) loadAppsInfo
{

    NSString *appsJson=[appBase stringByAppendingFormat:@"%s","/apps.json"];

    NSLog(@"json file=%@",appsJson);
    NSFileManager *fm = [NSFileManager defaultManager];
    NSDictionary * appObj=[NSJSONSerialization  JSONObjectWithData:[fm contentsAtPath:appsJson] options:NSJSONReadingMutableLeaves error:nil];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:appObj options:0 error:nil];
    [lua doString:@"require 'JSON4Lua'"];
    NSString * jsonStr=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",jsonStr);
    [lua doString:[@"OLA.apps=" stringByAppendingFormat:@"json.decode('%@')",  jsonStr]];
    //[lua doString:@"OLA.apps=json.decode('{\"user_apps\":{\"A\":\"AAA\"}}')"];
    [lua doString:@"Log:d('json=',type(json))"];
    [lua doString:@"Log:d('OLA apps type=',type(OLA.apps.user_apps))"];
    [lua doString:@"Log:d('OLA apps len=',''..#OLA.apps.user_apps)"];

}
- (void) reset
{
    
}

- (NSString *)  getRootPath
{
    NSString *homeDirectory = NSHomeDirectory();
    return homeDirectory;
    //return  [[homeDirectory stringByAppendingString:@"/"] stringByAppendingString:fileBase];
}



-  (void) loadXML
{
    NSString *xmlFile=[appBase stringByAppendingFormat:@"%@/Main.xml",appName];// +appName+"/Main.xml";
    NSLog(@"xml file=%@",xmlFile);
    NSString * xml=[OLAUIFactory  loadResourceTextDirectly:xmlFile];
   
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
        if ([n.tagName caseInsensitiveCompare:@"app-title"]==NSOrderedSame)
        {
            appTitle= n.textContent.value;
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
    //if(views.size()>0)name=OLA.appBase + views.get(0).toString();
    if(views.count>0)name= [[OLA getAppBase] stringByAppendingString: (NSString *)[views firstObject]];
    return name;
}
-(void) execInitScripts
{
    for(NSString *  src in initScripts)
    {
        
        [lua doString:[OLAUIFactory loadResourceTextDirectly:[[OLA getAppBase] stringByAppendingString:src]]];//  .doNSString * (UIFactory.loadResourceTextDirectly(src));
    }
}
-(void) execGlobalScripts
{
    for(NSString *  src in globalScripts)
    {
        NSLog(@"execute global scripts,src=%@",src);
        [lua doString:[OLAUIFactory loadResourceTextDirectly:[[OLA getAppBase] stringByAppendingString:src]]];
    }
}



-  (OLALuaContext*) getLuaContext
{
    return lua;
}

-  (id) getAppProperties
{
    return currentApp;
}

- (void) printtype
{
    NSLog(@"properties class type=%@",[self class]);
}

     int assetLoader(lua_State *L)
    {
        const char *name = lua_tostring(L, -1) ;
        
        //NSString * fileNme=[self.appBase];
        NSLog(@"required file name=%s",name);
        NSLog(@"%@",[OLA getAppBase]);
        const char * file=[[[OLA getAppBase] stringByAppendingFormat:@"/lua/%s.lua",name ] cStringUsingEncoding:NSASCIIStringEncoding];
         NSLog(@"required file name=%s",file);
       // luaL_dofile(L,file);

        NSString *json=[OLAUIFactory  loadResourceTextDirectly:@"assets/olaos/lua/JSON4Lua.lua"];
        const char *cJson=[json UTF8String];
        //NSLog(@"cJson=%s",cJson);
        int errCode=luaL_loadbuffer(L, cJson, strlen(cJson) ,"JSON4Lua");
        const char * err=lua_tostring(L, -1);
        NSLog(@"lua error(code=%i)=%s",errCode,err);
        
        //luaL_loadbuffer(<#lua_State *L#>, <#const char *buff#>, <#size_t sz#>, <#const char *name#>)
        //[lua doFile:[[OLA getAppBase] stringByAppendingFormat:@"/lua/%s.lua",name ]];
        //luaL_loadfile(L, [[[OLA getAppBase] stringByAppendingFormat:@"/lua/%s.lua",name ] UTF8String]);

        /*
            InputStream is=null;
            if(!isPlatformApp && appServer.startsWith("http://"))
            {
                System.out.println("HTTP Require lua="+appBase+appName+"/lua/"+name + ".lua");
                URL url = new URL(appBase+appName+"/lua/"+name + ".lua");
                HttpURLConnection urlConn = (HttpURLConnection) url.openConnection();
                is = urlConn.getInputStream();
            }
            else
            {
                File file=new File(appBase+appName+"/lua/"+name + ".lua");
                is = new FileInputStream(file);
            }
            byte[] bytes = readAll(is);
            L.LloadBuffer(bytes, name);
            is.close();
            return 1;
         */
        return 1;

    }

@end
