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


@implementation OLAHttpResponse
@synthesize state,content,cookies;
-(NSString *) getContent
{
    return content;
}
-(int) getState
{
    return state;
}
-(NSString *) getCookies
{
    return cookies;
}
@end

@implementation OLAHTTP


@synthesize progressBar,complitedCallback,processingCallback;
@synthesize currentUrl,request,cookies;
@synthesize receiveData,theConnection;

@synthesize total,err,process,state,content;
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
        //NSLog(@"HTTP waiting...");
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
    request=[NSMutableURLRequest requestWithURL:url];
    NSLog(@"set cookie:%@", self.cookies);
    if(self.cookies!=nil)[request setValue:self.cookies forHTTPHeaderField:@"Cookie"];
    //NSLog(@"http method=%@",request.HTTPMethod);
    self.receiveData = [[NSMutableData alloc] init];
    self.theConnection = [[NSURLConnection alloc] initWithRequest:self.request delegate:self startImmediately:YES];
    //NSLog(@"downloaded url=%@",theConnection.description);
    //[self.theConnection start];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    state=1;
    total = [response expectedContentLength];
    NSLog(@"data length is %lli", total);
    //get cookie method 1
    // NSArray *cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:fields forURL:url];
                        
    //get cookie method 2
    NSHTTPURLResponse *a=(NSHTTPURLResponse *)response;
    
    NSString *cookietring = [[a allHeaderFields] valueForKey:@"Set-Cookie"];
    NSLog(@"cookie 2=%@", cookietring);
    if(cookietring!=Nil)self.cookies=cookietring;

    /*
    //get cookie method 3
    NSHTTPCookieStorage * cookiear = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    //[cookiear cookiesForURL:[response URL]];
    for (NSHTTPCookie * cookie in [cookiear cookies])
    {
     NSLog(@"cookie 3=%@", cookie);
    }
     */
}

//传输数据
-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
    process += data.length;
    [receiveData appendData:data];
    //NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
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
        
        OLAHttpResponse* res=[[OLAHttpResponse alloc] init];
        res.state=self.state;
        res.content=self.content;
        res.cookies=self.cookies;
        
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
        NSLog(@"callback executed.");
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

 - (int) getState
 {
 return state;
 }


- (NSString *) getContent
{
    return content;
}

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

- (NSString *) getCookies
{
    return cookies;
}


@end
