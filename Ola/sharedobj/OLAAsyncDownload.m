//
//  OLAAsyncDownload.m
//  Ola
//
//  Created by Terrence Xing on 5/2/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#import "OLAAsyncDownload.h"
#import "ProgressBar.h"
#import "OLAAppProperties.h"
#import "OLAPortalProperties.h"
#import "OLALuaContext.h"
#import "OLAUIMessage.h"

@implementation OLAAsyncDownload


@synthesize progressBar,totalProgressBar,complitedCallback,processingCallback;
@synthesize urls,request;
@synthesize receiveData,theConnection;
@synthesize downloadDir;
@synthesize processedFileCount,currentFile,currentUrl,total,err,process,state;
@synthesize  finished;

@synthesize startTime,speed;

int contentLength;

long long tmpDataLength;
- (id) init
{
    self=[super init];
    self.urls = [[OLAQueue alloc] init];
    //self.downloadDir = [[OLAProperties getInstance].fileBase stringByAppendingString:@"/download/"];
    OLAPortalProperties *prop=[OLAPortalProperties getInstance];
    OLAAppProperties *appProp=prop.currentApp;
    self.downloadDir = [appProp.fileBase stringByAppendingString:@"/download/"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSLog(@"download dir=%@",downloadDir);
    if(![fileManager fileExistsAtPath:self.downloadDir])
    {
         [[NSFileManager defaultManager] createDirectoryAtPath:self.downloadDir withIntermediateDirectories:YES attributes:nil error:nil
          ] ;
        
    }
    processedFileCount=0;
    return self;
}

	
	+(id) create
	{
		return [[OLAAsyncDownload alloc] init];
	}
    +(id) create:(NSString *)url
	{
		OLAAsyncDownload * down=[[OLAAsyncDownload alloc] init];
        [down addUrl:url];
        return down;
        
	}
-(void) addUrl:(NSString *)url
{

        //URL mUrl = new URL(url);
    NSURL *_url=[[NSURL alloc] initWithString:url];
    [urls push:_url];

}




- (void) setProgressBar:(NSString *)barId
	{
		
		self.progressBar  =   [[OLALuaContext getInstance] getObject:barId];//(IProgressBar)(LuaContext.getInstance().getObject(barId));
	}

	
- (void) setTotalProgressBar:(NSString *)barId
	{
		self.totalProgressBar  =   [[OLALuaContext getInstance] getObject:barId];
	}

- (void) start
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
        BOOL running=YES;
        while(self.urls.count>0)
        {
            //processedFileCount,currentFile,currentUrl,total,err,process,state;
            NSURL *url=[self.urls pop];
            self.currentUrl=url;
            NSLog(@"url=%@",[url absoluteString]);
            //NSString *path = [currentUrl path];
            NSString *fileName = [[currentUrl pathComponents] lastObject];//path.substring(path.lastIndexOf('/') + 1,path.length());
            
            currentFile=fileName;
            
            finished=NO;
            total=0;
            process=0;
            state=0;
            self.startTime=[NSDate date].timeIntervalSince1970;
            [self download:self.currentUrl];
            while(!finished) {
                [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            }
            
            
        }
        
        
    });
}


- (void) download:(NSURL *)url
{
    
    //request=[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy  timeoutInterval:60.0];
    request=[NSURLRequest requestWithURL:url];
    NSLog(@"http method=%@",request.HTTPMethod);
    self.receiveData = [[NSMutableData alloc] init];
    self.theConnection = [[NSURLConnection alloc] initWithRequest:self.request delegate:self startImmediately:YES];
    NSLog(@"downloaded url=%@",theConnection.description);
    //[self.theConnection start];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    state=1;
    total = [response expectedContentLength];
    NSLog(@"data length is %lli", total);
}

//传输数据
-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
    process += data.length;
    [receiveData appendData:data];
    if(self.processingCallback!=nil)
    {
        OLAUIMessage *msg=[[OLAUIMessage alloc] init];
        
        NSMutableString *luaCallback=[[NSMutableString alloc] initWithString:self.processingCallback];
        [luaCallback appendString:@"("];
        [luaCallback appendFormat:@"%i,",state ];
        [luaCallback appendFormat:@"%lli,",total ];
        [luaCallback appendFormat:@"%lli,",process ];
        [luaCallback appendFormat:@"'%@',",currentUrl.absoluteString];
        [luaCallback appendFormat:@"'%@')",currentFile];
        
        //=processingCallback+"("+state+","+total+","+process+",'"+(currentUrl.getHost()+"/"+currentUrl.getPath())+"','"+(currentFile.getAbsolutePath())+"')";
        //NSLog(@"callback=%@",luaCallback);
        [msg updateMessage:luaCallback];
    }
    double now=[NSDate date].timeIntervalSince1970;
    if(now-startTime >=1.0)
    {

        speed=tmpDataLength/ (now-startTime);
        //NSLog(@"net speed= %f",speed);
    
        self.startTime=[NSDate date].timeIntervalSince1970;
        tmpDataLength=0;
    }
    else{
        tmpDataLength+=data.length;
    }
}

//错误
- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    state=-1;
    err=error.description;
    finished=YES;
    [self releaseObjs];
    NSLog(@"err=%@",error.description);
}

- (void) releaseObjs{
    self.receiveData = nil;
    //self.fileName = nil;
    self.request = nil;
    self.theConnection = nil;
}

//成功下载完毕
- (void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"download finished");
    
    NSString *_localFilePath = [NSString stringWithFormat:@"%@/%@",downloadDir, currentFile];
    //创建文件
    [receiveData writeToFile:_localFilePath atomically:YES];
    //String luaCallback=complitedCallback+"("+(processedFileCount+urls.size())+","+processedFileCount+",'"+(currentUrl.getHost()+"/"+currentUrl.getPath())+"','"+(currentFile.getAbsolutePath())+"')";
    
    self.processedFileCount++;
    state=2;
    
    OLAUIMessage *msg=[[OLAUIMessage alloc] init];
    
    NSMutableString *luaCallback=[[NSMutableString alloc] initWithString:self.complitedCallback];
    [luaCallback appendString:@"("];
    [luaCallback appendFormat:@"%i,",processedFileCount+urls.count];
    [luaCallback appendFormat:@"%i,",processedFileCount ];
    [luaCallback appendFormat:@"'%@',",currentUrl.absoluteString];
    [luaCallback appendFormat:@"'%@')",currentFile];
    

    NSLog(@"callback=%@",luaCallback);
    [msg updateMessage:luaCallback];

    [self releaseObjs];
    finished=YES;
}

/**
 * -1:error,0: prepare,1: downloading, 2: complited
 *
 * @return
 */
/*
	- (int) getState()
	{
		return state;
	}
    */
	- (NSString *) getError
	{
		return err;
	}
    
	- (long long) getTotalSize
	{
		return total;
	}
    
	- (long long) getValue
	{
		return process;
	}
    
	- (NSString *) getUrl
	{
		if (self.currentUrl != nil)
			return [currentUrl path];
		else
			return @"";
	}
	
	- (NSString *)getFilename
	{
		if (currentFile != nil)
			return currentFile;
		else
			return @"";
	}
    


@end
