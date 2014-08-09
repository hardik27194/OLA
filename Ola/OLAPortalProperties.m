//
//  OLAPortalProperties.m
//  Ola
//
//  Created by Terrence Xing on 6/18/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#import "OLAPortalProperties.h"
#import "OLAAppProperties.h"
#import "OLA.h"
#import "OLAView.h"
#import "OLABodyView.h"

@implementation OLAPortalProperties
static OLAPortalProperties *instance;
- (id)init
{
    self= [super init];

    appServer=@"";

    appName=@"olaportal/";
    isPlatformApp=NO;
    
    [super initiateLuaContext];
    [super loadAppsInfo];
    [super loadXML];
    [self reset];
    NSLog(@"lua instance 0=%@",[OLALuaContext getInstance].description);
    return self;
}
- (void) reset
{
    self.currentApp=nil;
    OLA.appBase=[appBase stringByAppendingFormat:@"%@/",appName ];
    [OLALuaContext registInstance:[self getLuaContext]];
}
+ (OLAPortalProperties *) getInstance
{
    NSLog(@"portal properties class=%@",instance.description);
    if(instance==nil)instance=[[OLAPortalProperties alloc] init];
    return instance;
}
+ (OLAPortalProperties *) create
{
    instance=[[OLAPortalProperties alloc] init];
    return instance;
}
- (void) startApp:(NSString *)name
{
    //[self performSelectorOnMainThread:@selector(_startApp:)withObject:appName waitUntilDone:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self _startApp:name];
    });
    
}
- (void) _startApp:(NSString *) name
{
    
    OLAAppProperties *app= [[OLAAppProperties alloc] initWithAppName:name]; //new AppProperties(appName);
    //NSString *packageName=Main.class.getPackage().getName();
    //System.out.println(packageName);
    //app.appPackage=packageName;
    currentApp=app;
    [app execGlobalScripts];
    NSString *firstName=[currentApp getFirstViewName];
    OLABodyView *v=nil;
    if(firstName!=nil)
    {
        OLAView *bodyView=[[OLAView alloc] init];
        bodyView.v=[OLA getMainView];
        v=[[OLABodyView alloc] initWithViewController:bodyView andViewXMLUrl:firstName]; //new BodyView(Main.ctx,name);
        //UIFactory.viewCache.clear();//
        //UIFactory.viewCache.put(name, v);
    }
     [v show];
    
}


@end
