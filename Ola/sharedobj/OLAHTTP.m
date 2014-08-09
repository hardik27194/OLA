//
//  OLAAsyncDownload.m
//  Ola
//
//  Created by Terrence Xing on 5/2/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#import "OLAHTTP.h"
#import "ProgressBar.h"
#import "OLAProperties.h"
#import "OLALuaContext.h"
#import "OLAUIMessage.h"


@implementation HttpResponse
@synthesize state,content;
@end

@implementation OLAHTTP


@synthesize progressBar,complitedCallback,processingCallback;
@synthesize currentUrl,request;
@synthesize receiveData,theConnection;

@synthesize total,err,process,state;
@synthesize  finished;

@synthesize startTime,speed;

int contentLength;

long long tmpDataLength;
- (id) initWithUrl:(NSString *)urlString
{
    self=[super init];
    self.currentUrl =  [[NSURL alloc] initWithString:urlString];
    self.state=-1;
    return self;
}

+(id) create:(NSString *)url
{
    OLAHTTP * down=[[OLAHTTP alloc] initWithUrl:url];
    return down;
}

- (void) setProgressBar:(NSString *)barId
{
    self.progressBar  =   [[OLALuaContext getInstance] getObject:barId];//(IProgressBar)(LuaContext.getInstance().getObject(barId));
}

- (void) sendRequest
{
    self.state=0;
    [self downloadAsync];
}

- (void) receive
{
    //HTTP request is not sent
    if(self.state==-1)return;
    
    while(self.state!=2 && self.state>=-1)
    {
        
        [NSThread sleepForTimeInterval:0.05];
    }
}

- (void) downloadAsync
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
        BOOL running=YES;
        //while(self.urls.count>0)
        {
            //processedFileCount,currentFile,currentUrl,total,err,process,state;
            NSLog(@"url=%@",[currentUrl absoluteString]);

            finished=NO;
            total=0;
            process=0;
            state=0;
            self.startTime=[NSDate date].timeIntervalSince1970;
            [self downloadURL:self.currentUrl];
            while(!finished) {
                [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            }
            
        }
        
        
    });
}


- (void) downloadURL:(NSURL *)url
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
        NSRange range=[luaCallback rangeOfString:@")" options:(NSBackwardsSearch)];
        if (range.location != NSNotFound) {
            [luaCallback deleteCharactersInRange:range];
        }
        
        [luaCallback appendString:@","];
        [luaCallback appendFormat:@"%i,",state ];
        [luaCallback appendFormat:@"%lli,",total ];
        [luaCallback appendFormat:@"%lli)",process ];
        
        
        
        NSLog(@"callback=%@",luaCallback);
        [msg updateMessage:luaCallback];
    }
    double now=[NSDate date].timeIntervalSince1970;
    if(now-startTime >=1.0)
    {
        speed=tmpDataLength/ (now-startTime);
        
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
    state=-2;
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
    
    self.content=[[NSString alloc]  initWithData:receiveData encoding:NSUTF8StringEncoding];
    state=2;
    
    OLAUIMessage *msg=[[OLAUIMessage alloc] init];
    
    if(self.complitedCallback!=nil)
    {
        
        HttpResponse* res=[[HttpResponse alloc] init];
        res.state=self.state;
        res.content=self.content;
        OLALuaContext *lua= [OLALuaContext getInstance];
        [lua regist:res withGlobalName:@"HttpResponse"];
        
        NSMutableString *luaCallback=[[NSMutableString alloc] initWithString:self.complitedCallback];
        [luaCallback appendString:@"(HttpResponse)"];
        /*
         NSRange range=[luaCallback rangeOfString:@")" options:(NSBackwardsSearch)];
         if (range.location != NSNotFound) {
         [luaCallback deleteCharactersInRange:range];
         }
         [luaCallback appendString:@"("];
         [luaCallback appendFormat:@"%i,",processedFileCount+urls.count];
         [luaCallback appendFormat:@"%i,",processedFileCount ];
         [luaCallback appendFormat:@"'%@',",currentUrl.absoluteString];
         [luaCallback appendFormat:@"'%@')",currentFile];
         */
        
        NSLog(@"callback=%@",luaCallback);
        [msg updateMessage:luaCallback];
        [lua remove:@"HttpResponse"];
    }
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



@end
