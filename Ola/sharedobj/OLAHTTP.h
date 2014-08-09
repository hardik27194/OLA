//
//  OLAAsyncDownload.h
//  Ola
//
//  Created by Terrence Xing on 5/2/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProgressBar.h"
#import "OLAQueue.h"

@interface HttpResponse : NSObject
{
    int state;
    NSString * content;
}
@property (nonatomic) int state;
@property (nonatomic,retain) NSString * content;
@end

@interface OLAHTTP : NSObject
{
    ProgressBar *progressBar;
    
	NSString *processingCallback;
	NSString *complitedCallback;
    
    NSURL *currentUrl;
    NSString * content;
@private
    NSURLRequest * request;
    NSMutableData *receiveData;
    NSURLConnection *theConnection;
    
    
    long long total;
    long long process ;
    int state ;
    NSString *err ;
    
    BOOL finished;
    
    CGFloat speed;
    double startTime;
    
}
@property (nonatomic,retain) ProgressBar *progressBar;

@property (nonatomic,retain) NSString *processingCallback;
@property (nonatomic,retain) NSString *complitedCallback;


@property (nonatomic,retain) NSURL *currentUrl;
@property (nonatomic,retain) NSString * content;

@property (nonatomic,retain) NSURLRequest * request;
@property (nonatomic,retain) NSMutableData *receiveData;
@property (nonatomic,retain) NSURLConnection *theConnection;


@property (nonatomic) long long total;
@property (nonatomic) long long process ;
@property (nonatomic) int state ;
@property (nonatomic) NSString *err ;


@property (nonatomic)BOOL finished;
@property (nonatomic)CGFloat speed;
@property (nonatomic)double startTime;

+(id) create:(NSString *)url;

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
- (void) connectionDidFinishLoading:(NSURLConnection *)connection;
- (NSString *) getError;
- (long long) getTotalSize;
- (long long) getValue;
- (NSString *) getUrl;

@end
