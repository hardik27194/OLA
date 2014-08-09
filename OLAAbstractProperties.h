//
//  OLAAbstractProperties.h
//  Ola
//
//  Created by Terrence Xing on 6/17/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "OLALuaContext.h"


@interface OLAAbstractProperties : NSObject
{
    NSMutableArray * globalScripts;
    NSMutableArray * initScripts;
    NSMutableArray * views;
    NSMutableArray * apps;
    
    id currentApp;
    
    OLALuaContext *lua;
    
   // NSString *  appUrl;

    NSString * appBase;

    NSString * appServer;
    NSString * mode;
    NSString * fileBase;
    
    NSString * appName;
    NSString * appTitle;
    NSString * appPackage;
    NSString * sandboxRoot;
    
    long long installedTime;
    long long lastUsedTime;
    
    NSString * os;
    double version;
    
    BOOL isPlatformApp;
    /**
     * the application's status
     * 0, not installed; 1--new installed, first time executed; 2--exectued
     */
    int state;
}

//@property (nonatomic,retain)NSString *  appUrl;
@property (nonatomic,retain)NSString * fileBase;
@property (nonatomic) id currentApp;
@property (nonatomic,retain)NSString * appName;
@property (nonatomic) OLALuaContext *lua;

-(id) init;
- (NSString *)  getRootPath;
-(void) initiateLuaContext;

- (NSString *)  getFirstViewName;
-(void) execGlobalScripts;
-(void) execInitScripts;
- (void) loadAppsInfo;
-  (void) loadXML;
-  (OLALuaContext*) getLuaContext;
- (void) printtype;
@end
