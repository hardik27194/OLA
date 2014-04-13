//
//  OLAProperties.h
//  Ola
//
//  Created by Terrence Xing on 3/20/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OLAProperties : NSObject
{
    NSMutableArray * globalScripts;
    NSMutableArray * initScripts;
    NSMutableArray * views;
    
    NSString *  appUrl;
	//NSString *  appUrl="test/";
    NSString * fileBase;
}

@property (nonatomic,retain)NSString *  appUrl;
@property (nonatomic,retain)NSString * fileBase;

+  (OLAProperties *) getInstance;
- (NSString *)  getRootPath;
-(void) initiate;
- (NSString *)  getFirstViewName;
-(void) execGlobalScripts;
-(void) execInitScripts;
@end
