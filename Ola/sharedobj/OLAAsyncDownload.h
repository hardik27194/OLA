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

@interface OLAAsyncDownload : NSObject
{
    ProgressBar *progressBar;
	ProgressBar *totalProgressBar;
	NSString *processingCallback;
	NSString *complitedCallback;
    
    
	//File tmpDir = new File(LMProperties.fileBase + "/download/");
    
    OLAQueue *urls;
    @private
    NSString *downloadDir;
    NSURLRequest * request;
    NSMutableData *receiveData;
    NSURLConnection *theConnection;
    
    int processedFileCount ;
    long long total;
    long long process ;
    int state ;
    NSString *err ;
    NSURL *currentUrl;
    NSString *currentFile;
    
    BOOL finished;
    
    CGFloat speed;
    double startTime;

}
@property (nonatomic,retain) ProgressBar *progressBar;
@property (nonatomic,retain) ProgressBar *totalProgressBar;
@property (nonatomic,retain) NSString *processingCallback;
@property (nonatomic,retain) NSString *complitedCallback;
@property (nonatomic,retain) NSString *downloadDir;

@property (nonatomic,retain) OLAQueue *urls;

@property (nonatomic,retain) NSURLRequest * request;
@property (nonatomic,retain) NSMutableData *receiveData;
@property (nonatomic,retain) NSURLConnection *theConnection;

@property (nonatomic) int processedFileCount ;
@property (nonatomic) long long total;
@property (nonatomic) long long process ;
@property (nonatomic) int state ;
@property (nonatomic) NSString *err ;
@property (nonatomic) NSURL *currentUrl;
@property (nonatomic) NSString *currentFile;

@property (nonatomic)BOOL finished;
@property (nonatomic)CGFloat speed;
@property (nonatomic)double startTime;

+(id) create;
+(id) create:(NSString *)url;
-(void) addUrl:(NSString *)url;

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
- (void) connectionDidFinishLoading:(NSURLConnection *)connection;
- (NSString *) getError;
- (long long) getTotalSize;
- (long long) getValue;
- (NSString *) getUrl;
- (NSString *)getFilename;
@end
