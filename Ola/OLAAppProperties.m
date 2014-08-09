//
//  OLAAppProperties.m
//  Ola
//
//  Created by Terrence Xing on 6/18/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#import "OLAAppProperties.h"
#import "OLAPortalProperties.h"
#import "OLABodyView.h"
#import "OLAView.h"
#import "OLAViewController.h"
#import "OLA.h"

@implementation OLAAppProperties

//	static AppProperties instance;
-(id) initWithAppName:(NSString *)applicationName
{
    self=[super init];

    appServer=@"";
    
    appName=applicationName;;
    isPlatformApp=NO;
    
    [self initiateLuaContext];
    [self loadXML];
    NSLog(@"lua instance 11=%@",[OLALuaContext getInstance].description);
    return self;
}

- (void) exit
{
     NSLog(@"lua instance 1=%@",[OLALuaContext getInstance].description);
    //[self performSelectorOnMainThread:@selector(_startApp:)withObject:appName waitUntilDone:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self _exit];
    });
    
}
- (void) _exit
{
   
    OLAPortalProperties *prop=[OLAPortalProperties create];
    [prop reset];
    [prop execGlobalScripts];
     NSLog(@"lua instance 2=%@",[OLALuaContext getInstance].description);
    OLABodyView * v=nil;
    
    
    NSString *name=[prop getFirstViewName] ;
    
    NSLog(@"exit first view name=%@",name);
    OLAView *view=[[OLAView alloc] init];
    view.v=[OLA getMainView];
    
    if(name!=nil)
    {
        v=[[OLABodyView alloc] initWithViewController:view andViewXMLUrl:name];
        //OLAUIFactory.viewCache.clear();//
        //OLAUIFactory.viewCache.put(name, v);
    }
    [v show];
    


}

- (void) reset
{
    // TODO Auto-generated method stub
    
}

@end
