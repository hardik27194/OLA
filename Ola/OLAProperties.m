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
#import "OLASoundPlayer.h"
#import "OLAUIMessage.h"
#import "OLAAsyncDownload.h"

#import "OLAAppProperties.h"
#import "OLAPortalProperties.h"
#import "OLABodyView.h"
#import "OLAView.h"
#import "OLA.h"

@implementation OLAProperties


/**
 * the main lua mobile properties
 * @author xingbao-
 *
 */
-(id) init
{
    self=[super init];

    appServer=@"";

    
    appName=@"olaos/";
    isPlatformApp=YES;
    
    [self initiateLuaContext];
    return self;
}

- (void) reset
{
    self.currentApp=nil;
    [self loadXML];
    [OLALuaContext registInstance:[self getLuaContext]];
}
- (void) startApp:(NSString *)name
{
    //[self performSelectorOnMainThread:@selector(_startApp:)withObject:appName waitUntilDone:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    [self _startApp:name];
    });

}

-(void) _startApp:(NSString *) appName
{
    OLAPortalProperties *properties=[OLAPortalProperties getInstance];
    //properties.currentApp=null;
    [properties reset];
    
    //NSString *packageName=Main.class.getPackage().getName();
    //properties.appPackage=packageName;
    
    [properties execGlobalScripts];
    
    OLABodyView *v=nil;
    NSString *name=[properties getFirstViewName];
    
    if(name!=nil)
    {
        OLAView *bodyView=[[OLAView alloc] init];
        bodyView.v=[OLA getMainView];
        v=[[OLABodyView alloc] initWithViewController:bodyView andViewXMLUrl:name]; //new BodyView(Main.ctx,name);
        //UIFactory.viewCache.clear();//
        //UIFactory.viewCache.put(name, v);
    }
    NSLog(@"v show=%@",v.viewUrl);
    [v show];
}

@end
