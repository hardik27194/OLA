//
//  OLAZipUtil.m
//  Ola
//
//  Created by Terrence Xing on 6/18/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#import "OLAZipUtil.h"
#import "ZipFile.h"
#import "FileInZipInfo.h"
#import "ZipReadStream.h"

@implementation OLAZipUtil

@synthesize zipFileName;

- (id) initWithZipFileName:(NSString *) fileName
{
    if( self=[super init] )
    {
        zipFileName=fileName;
    }
    
    return self;
}
+  (id) open:(NSString *)zipFileName
{
   
    OLAZipUtil *zip =[[OLAZipUtil alloc] initWithZipFileName:zipFileName];
    return zip;
}

-  (void) unzipTo:(NSString *)folderPath
{
    ZipFile *zFile = [[ZipFile alloc] initWithFileName:self.zipFileName mode:ZipFileModeUnzip];
    //mode指示打开zip文件的用途，在ZipFile.h中定义，一共三种模式，ZipFileModeUnzip是解压模式(读模式)，ZipFileModeCreate创建并写入压缩文件(写模式)，ZipFileModeAppend不用说就是追加模式喽。
    
    if (zFile == nil)
    {
        NSLog(@"Cannot found zip file '%@'",self.zipFileName);
        return;
    }
    //接下来就是读取了：
    [zFile goToFirstFileInZip];
    //首先需要进入Zip包中的第一个文件，然后就可以遍历读取zip包中的所有文件
    BOOL bContinue=YES;
    while (bContinue) {
        FileInZipInfo *info = [zFile getCurrentFileInZipInfo];
        
        //获得当前遍历文件的信息，包括大小、文件名、压缩级等等
        ZipReadStream *readStream = [zFile readCurrentFileInZip];
        //将当前文件读入readStream，如果当前文件有加密则使用readCurrentFileInZipWithPassword
        NSMutableData *data = [[NSMutableData alloc] initWithLength:info.length];
        //发现data的长度给的不对就要出问题，所以用文件大小初始化
        [readStream readDataWithBuffer:data];
        [readStream finishedReading];
        //将当前文件内容存入data中，怎么处理就看具体情况了
        NSFileManager *fm = [NSFileManager defaultManager];
        NSMutableString * fileName= [[NSMutableString alloc] initWithString:folderPath];
        [fileName appendFormat:@"/%@",info.name];

            NSMutableString * parent=[[NSMutableString alloc] initWithString:fileName];
            NSRange range=[parent rangeOfString:@"/" options:NSBackwardsSearch];
            range.length=parent.length-range.location;
            [parent deleteCharactersInRange:range];
            
            [fm createDirectoryAtPath:parent withIntermediateDirectories:YES attributes:nil error:nil];
            
            [fm createFileAtPath:fileName contents:data attributes:nil];
            //[data writeToFile:fileName atomically:YES];

        bContinue = [zFile goToNextFileInZip];
        //如果包中没有文件了，返回NO，结束遍历
    }
    [zFile close];
}
-(void) zip
{
    /*
    ZipFile *zFile = [[ZipFile alloc] initWithFileName:fileInPath mode:ZipFileModeCreate];
    //向当前Zip文件中添加文件需要使用ZipFileModeAppend模式
    ZipWriteStream *writeStream = [zFile writeFileInZipWithName:yourfilename compressionLevel:ZipCompressionLevelFast];
    //yourfilename是存入的文件名
    //compressionLevel指示压缩率级别，可以选择ZipCompressionLevelFast(最快), ZipCompressionLevelBest(最大压缩率)，ZipCompressionLevelNone(不压缩)
    //如果使用密码和CRC校验可以使用另外的写入函数
    [writeStream writeData:data];
    //data是需要压入的文件内容(NSData类型)
    [writeStream finishedWriting];
    [zFile close];
     */
}
@end
