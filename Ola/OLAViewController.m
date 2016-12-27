//
//  OLAViewController.m
//  Ola
//
//  Created by Terrence Xing on 3/19/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#import "OLAViewController.h"
#import "OLALuaContext.h"

#import "lua.h"
#import "lualib.h"
#import "lauxlib.h"
#import "OLALog.h"

#import "LinearLayout.h"
#import "OLAProperties.h"
#import "OLABodyView.h"
#import "OLAFileOutputStream.h"
#import "OLAFileInputStream.h"

#import <CommonCrypto/CommonCryptor.h>

#import "OLADES3Encrypt.h"
#import "OLAStringUtil.h"
#import "OLADatabase.h"

#import "OLAZipUtil.h"
#import "OLAAbstractProperties.h"
#import "OLA.h"
#import "OLALineChart.h"

@implementation OLAViewController

@synthesize viewController;

@synthesize bodyView;


- (OLAViewController * ) getViewController
{
    return viewController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    bodyView=[[OLAView alloc] init];
    bodyView.v=self.view;
    [OLA setMainView:self.view];
    
    
    OLAProperties *properties=[[OLAProperties alloc] init];//[OLAProperties getInstance];
    properties.appName=@"olaos/";
    OLABodyView * v=nil;
    
    [properties loadAppsInfo];
    [properties reset];

    NSString *name=[properties getFirstViewName] ;

    NSLog(@"first view name=%@",name);
    
    if(name!=nil)
    {
        v=[[OLABodyView alloc] initWithViewController:bodyView andViewXMLUrl:name];
        //OLAUIFactory.viewCache.clear();//
        //UIFactory.viewCache.put(name, v);
    }
    [v show];
    [v executeLua];
    
    //OLALineChart *lc=[[OLALineChart alloc]init];
    //[self.view addSubview:lc.v];
    
   // [self initPlot];
    
    //[self testWriteFile];
    //[self.view addSubview:v.bodyLayout.v];
    
    //OLAZipUtil *zip= [OLAZipUtil open:[NSHomeDirectory() stringByAppendingString:@"/Documents/a/a.zip"]];
    //[zip unzipTo:@"/Users/terrencexing/Documents/a"];
    
    //OLAAbstractProperties * prop = [[OLAAbstractProperties alloc] init];
    //[prop initiateLuaContext];
    //[prop loadAppsInfo];
    
    /*
    //test des3
    char * s1="lohool@hotmail.com";
    char * s2="";
    char * s3="";
    char * key[3]={s1,s2,s3};
    Byte * encypt;
    
    char * context="anabdon";
    encypt=[OLADES3Encrypt encypt:context key:key];
    
    int len = (sizeof(encypt) / sizeof(encypt[0]));
    for(int i=0;i<len;i++)
    {
        NSLog(@"%x",encypt[i]);
    }
    */
    
    //test UTF16LE StringUtil
    //NSLog(@"%@",[OLAStringUtil toUTF6LE:@"99,0,99,0,98,0,102,-117,-71,101"]);
    
    //[self testDB];
}








/******************************************************************************
 函数名称 : + (NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key 
 函数描述 : 文本数据进行DES加密 输入参数 : (NSData *)data              (NSString *)key 
 输出参数 : N/A 
 返回参数 : (NSData *) 
 备注信息 : 此函数不可用于过长文本 
 ******************************************************************************/
+ (NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key
{    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES, kCCOptionPKCS7Padding | kCCOptionECBMode, keyPtr, kCCBlockSizeDES,                                          NULL,  [data bytes], dataLength,   buffer, bufferSize,  &numBytesEncrypted);
    if (cryptStatus == kCCSuccess)
    {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    free(buffer);
    return nil;}
/*
+ (NSString*)TripleDES:(NSString*)plainText encryptOrDecrypt:(CCOperation)encryptOrDecrypt key:(NSString*)key {
    
    
    const void *vplainText;
    size_t plainTextBufferSize;
    
    if (encryptOrDecrypt == kCCDecrypt)
    {
        NSData *EncryptData = [GTMBase64 decodeData:[plainText dataUsingEncoding:NSUTF8StringEncoding]];
        plainTextBufferSize = [EncryptData length];
        vplainText = [EncryptData bytes];
    }
    else
    {
        NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
        plainTextBufferSize = [data length];
        vplainText = (const void *)[data bytes];
    }
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    // uint8_t ivkCCBlockSize3DES;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    // memset((void *) iv, 0x0, (size_t) sizeof(iv));
    
    //    NSString *key = @"123456789012345678901234";
    NSString *initVec = @"init Vec";
    const void *vkey = (const void *) [key UTF8String];
    const void *vinitVec = (const void *) [initVec UTF8String];
    
    ccStatus = CCCrypt(encryptOrDecrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding,
                       vkey, //"123456789012345678901234", //key
                       kCCKeySize3DES,
                       vinitVec, //"init Vec", //iv,
                       vplainText, //"Your Name", //plainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    //if (ccStatus == kCCSuccess) NSLog(@"SUCCESS");
   //else if (ccStatus == kCC ParamError) return @"PARAM ERROR";
    // else if (ccStatus == kCCBufferTooSmall) return @"BUFFER TOO SMALL";
    // else if (ccStatus == kCCMemoryFailure) return @"MEMORY FAILURE";
    // else if (ccStatus == kCCAlignmentError) return @"ALIGNMENT";
     //else if (ccStatus == kCCDecodeError) return @"DECODE ERROR";
    // else if (ccStatus == kCCUnimplemented) return @"UNIMPLEMENTED"; 
    
    NSString *result;
    
    if (encryptOrDecrypt == kCCDecrypt)
    {
        result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr
                                                                length:(NSUInteger)movedBytes]
                                        encoding:NSUTF8StringEncoding]
                  ;
    }
    else
    {
        NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
        result = [GTMBase64 stringByEncodingData:myData];
    }
    
    return result;
    
}
*/

-(void) testWriteFile
{
    OLAFileOutputStream * o= [OLAFileOutputStream open:@"test.f"];
    //[o writeBoolean:true];
    [o writeInt:1];
    [o writeLong:10];
    [o writeShort:65530];
    [o writeByte:1];
    [o writeDouble:1.234];
    [o writeStringWithLength:@"ABCD中国"];
    
    [o close];
    /*
    OLAFileInputStream *i=[OLAFileInputStream open:@"test.f"];
    NSLog(@"int=%d",[i readInt]);
    NSLog(@"long=%x",[i readLong]);
    NSLog(@"short=%d",[i readShort]);
     NSLog(@"byte=%d",[i readByte]);
    NSLog(@"double=%f",[i readDouble]);
    NSLog(@"str=%@",[i readStringWithLength]);
    NSLog(@"end write file");
    [i close];
     */
}
- (void)onScreenTouch:(NSNotification *)notification
{
    UIEvent *event=[notification.userInfo objectForKey:@"data"];
    
    NSLog(@"touch screen!!!!!");
    

}

- (void) clicked:(UITapGestureRecognizer*)recognizer
{
    //recognizer.cancelsTouchesInView=YES;
    //[recognizer cancelsTouchesInView];
    NSLog(@"layout.view=%@,clicked=%@",[self class],@"");
    
}

- (void) pressed:(UILongPressGestureRecognizer *)recognizer
{
    if (recognizer.state ==
        UIGestureRecognizerStateBegan) {
        NSLog(@"layout.UIGestureRecognizerStateBegan,view class=%d",recognizer.view.tag);
    }
    if (recognizer.state ==
        UIGestureRecognizerStateChanged) {
        NSLog(@"layout.UIGestureRecognizerStateChanged");
        //draged
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"layout.UIGestureRecognizerStateEnded");

    }
    
}

- (void) released:(UITapGestureRecognizer*)recognizer
{
    NSLog(@"layout.released=%@",@"");
    
}
- (void) addListner:(UIView *)v
{
    
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clicked:)];
    tapGesture.delegate = self;
    
    
    //[v addGestureRecognizer:tapGesture];
    
    
    
    UILongPressGestureRecognizer *longPressReger1 = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(pressed:)];
    longPressReger1.minimumPressDuration = 0.2;
    longPressReger1.delegate =  self;
    //[longPressReger1 requireGestureRecognizerToFail:tapGesture];
    [v addGestureRecognizer:longPressReger1];
    
    
    /*
     // 双击的 Recognizer
     UITapGestureRecognizer* double;
     doubleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:selfaction:@selector(DoubleTap：)];
     doubleTapRecognizer.numberOfTapsRequired = 2; // 双击
     //关键语句，给self.view添加一个手势监测；
     [self.view addGestureRecognizer:doubleRecognizer];
     
     // 关键在这一行，双击手势确定监测失败才会触发单击手势的相应操作
     [singleRecognizer requireGestureRecognizerToFail:doubleRecognizer];
     
     
     UISwipeGestureRecognizer *recognizer;
     recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
     [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
     
     [v addGestureRecognizer:recognizer];
     */
    
    
}
- (void) testDB
{
    OLADatabase * db=[OLADatabase create];//[[OLADatabase alloc] init];
    [db open:@"test.db"];
    [db execSQL:@"CREATE TABLE IF NOT EXISTS test(id INT NOT NULL DEFAULT -1,name VARCHAR(32),UNIQUE(id))"];
    //[db execSQL:"insert into test values('1','test1')"];
    //[db execSQL:"insert into test values('2','test2')"];
    NSString * list=[db query:@"select * from test"];
    NSLog(@"database result=%@",list);
    [db close];
    
}
- (void)writeFile:(NSString *)file
{
    //创建文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //获取路径
    //1、参数NSDocumentDirectory要获取的那种路径
    NSArray*  paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    //2、得到相应的Documents的路径
    NSString* DocumentDirectory = [paths objectAtIndex:0];
    //3、更改到待操作的目录下
    [fileManager changeCurrentDirectoryPath:[DocumentDirectory stringByExpandingTildeInPath]];
    //4、创建文件fileName文件名称，contents文件的内容，如果开始没有内容可以设置为nil，attributes文件的属性，初始为nil
    [fileManager removeItemAtPath:@"username" error:nil];
    NSString *path = [DocumentDirectory stringByAppendingPathComponent:@"username"];
    //5、创建数据缓冲区
    NSMutableData  *writer = [[NSMutableData alloc] init];
    //6、将字符串添加到缓冲中
    [writer appendData:[file dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    //7、将其他数据添加到缓冲中
    //将缓冲的数据写入到文件中
    [writer writeToFile:path atomically:YES];

}


- (NSString *)readFile
{
    //创建文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //获取路径
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    [fileManager changeCurrentDirectoryPath:[documentsDirectory stringByExpandingTildeInPath]];
    
    //获取文件路劲
    NSString* path = [documentsDirectory stringByAppendingPathComponent:@"username"];
    NSData* reader = [NSData dataWithContentsOfFile:path];
    return [[NSString alloc] initWithData:reader encoding:NSUTF8StringEncoding];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//按钮响应事件
-(void)btnPressed:(id)sender
{
    UIButton *myBtn = (UIButton *)sender;
    if (myBtn.tag == 10)
    {
        // TODO:
    }
}

@end
