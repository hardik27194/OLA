//
//  OLAFileOutputStream.m
//  Ola
//
//  Created by Terrence Xing on 3/31/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#import "OLAFileOutputStream.h"

@implementation OLAFileOutputStream


@synthesize isExisted,outFile,writer;

-(id) initWithFilePath:(NSString *)filePath
{
    writer = [[NSMutableData alloc] init];
    
    
    
   // NSString *homePath =   [NSHomeDirectory( ) stringByAppendingPathComponent:@"Documents"];
    
    NSString *sourcePath = filePath;//[homePath stringByAppendingPathComponent:filePath];  //源文件路径
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:sourcePath])
    {
        isExisted=true;
        
    }
    if(!isExisted)
    {
        NSString * parent=[sourcePath stringByDeletingLastPathComponent];
        if(![fileManager fileExistsAtPath:parent])
        {
            [fileManager createDirectoryAtPath:parent withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
    }
    NSLog(@"(FileOutputStream -- Info: file name= %@",sourcePath);
    
    [fileManager createFileAtPath:sourcePath contents:nil attributes:nil] ;
    
    outFile = [NSFileHandle fileHandleForWritingAtPath:sourcePath];
    
    
    
    
    return self;
}

+(id) open:(NSString *) fileName
{
    OLAFileOutputStream * outer= [[OLAFileOutputStream alloc] initWithFilePath:fileName];
    //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSString *documentsDirectory = [paths objectAtIndex:0];
    //获取文件路径
    //NSString *path = [documentsDirectory stringByAppendingPathComponent:fileName];
 
    return outer;
}
+(id) openAppend:(NSString *) fileName
{
    OLAFileOutputStream * outer= [[OLAFileOutputStream alloc] initWithFilePath:fileName];
    //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSString *documentsDirectory = [paths objectAtIndex:0];
    //获取文件路径
    //NSString *path = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    
    
    return outer;
}

- (bool) exists
{
    return isExisted;
    /*
    if(!isExisted) //如果不存在
    {
        
        return @"false";
    }
    else{
        
        return @"true";
    }
     */
}

- (void) writeInt:(int) val
{
    Byte b1=val>>24;
    Byte b2=(val>>16)&0xFF;
    Byte b3=(val>>8)&0xFF;
    Byte b4=val&0xFF;
    [writer appendBytes:&b1 length:1];
    [writer appendBytes:&b2 length:1];
    [writer appendBytes:&b3 length:1];
    [writer appendBytes:&b4 length:1];

}
//same format with Java, the low bit is in the end, and the hight bit is in the front;
//eg: short 65530 = 0xFF <<8 + 0xFA, C is:0xFAFF, whilst Java is 0xFFFA
- (void) writeShort:(short) val
{
    Byte b1=val>>8;
    Byte b2=val&0xFF;
    [writer appendBytes:&b1 length:1];
    [writer appendBytes:&b2 length:1];
}
- (void) writeLong:(long long) val
{
    Byte b1=val>>56;
    Byte b2=(val)>>48&0xFF;
    Byte b3=(val)>>40&0xFF;
    Byte b4=(val)>>32&0xFF;
    Byte b5=(val)>>24&0xFF;
    Byte b6=(val)>>16&0xFF;
    Byte b7=(val)>>8&0xFF;
    Byte b8=val&0xFF;
    [writer appendBytes:&b1 length:1];
    [writer appendBytes:&b2 length:1];
    [writer appendBytes:&b3 length:1];
    [writer appendBytes:&b4 length:1];
    [writer appendBytes:&b5 length:1];
    [writer appendBytes:&b6 length:1];
    [writer appendBytes:&b7 length:1];
    [writer appendBytes:&b8 length:1];
}

- (void) writeDouble:(double) d
{
    union LDouble ld;
    ld.d=d;
    [writer appendBytes:&ld.c[7] length:1];
    [writer appendBytes:&ld.c[6] length:1];
    [writer appendBytes:&ld.c[5] length:1];
    [writer appendBytes:&ld.c[4] length:1];
    [writer appendBytes:&ld.c[3] length:1];
    [writer appendBytes:&ld.c[2] length:1];
    [writer appendBytes:&ld.c[1] length:1];
    [writer appendBytes:&ld.c[0] length:1];
}

- (void) writeBoolean:(bool) val
{
    Byte b=1;
    if(val)//[val caseInsensitiveCompare:@"true"]==NSOrderedSame)
    {
        [writer appendBytes:&b length:1];
    }
    else
    {
        b=0;
        [writer appendBytes:&b length:1];
    }
}
/*
- (void) writeBoolean:(NSString *) val
{
    Byte b=1;
    if(val caseInsensitiveCompare:@"true"]==NSOrderedSame)
    {
        [writer appendBytes:&b length:1];
    }
    else
    {
        b=0;
        [writer appendBytes:&b length:1];
    }
}
*/
- (void) writeByte:(Byte) val
{
    [writer appendBytes:&val length:sizeof(val)];
}
- (void) writeString:(NSString *)val
{
    //NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(NSUTF16LittleEndianStringEncoding);
    NSData *data = [val dataUsingEncoding:NSUTF8StringEncoding];//[val dataUsingEncoding:enc];
    [writer appendData:data];
}
- (void) writeStringWithLength:(NSString *)val
{
    int len=[val lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    [self writeInt:len];
    [self writeString:val];
}
- (void) seek:(long long) pos
{
    [outFile seekToFileOffset:pos];
}
- (void) skipBytes:(long long) count
{
    [outFile writeData:writer];
    writer = [[NSMutableData alloc] init];
    [outFile seekToFileOffset:[outFile  offsetInFile]+count];
}
-(long long) getFilePointer
{
    return [outFile offsetInFile];
}
-(void) flush
{
    [outFile writeData:writer];
    
    writer = [[NSMutableData alloc] init];
}
- (void) close
{
    [outFile writeData:writer];
    [outFile closeFile];
}


-(void) stringToBytes:(NSString *) strs
{
    NSString *str = @"你好啊,aBc!";
    //NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(NSUTF16BigEndianStringEncoding);
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];//dataUsingEncoding:enc];
    Byte *byte = (Byte *)[data bytes];
    for (int i=0 ; i<[data length]; i++) {
        NSLog(@"byte = %d",byte[i]);
    }
}


- (int) readInt {
    NSData *data = [outFile readDataOfLength:4];
    Byte * readBuffer=(Byte * )[data bytes];
    if([data length]<4) return -1;
    return (readBuffer[0]<<24)+(readBuffer[1]<<16)+(readBuffer[2]<<8)+readBuffer[3];
}

- (NSString *) readIntArray:(int )len
{
    
    NSMutableString * buf = [[NSMutableString alloc] initWithCapacity:len];
    [buf appendString:@"{"];

    NSData *data = [outFile readDataOfLength:4*len];
    
    Byte * readBuffer=(Byte * )[data bytes];

    for( int i=0;i<len;i++)
    {
        int num= (readBuffer[(i*4)+0]<<24)+(readBuffer[(i*4)+1]<<16)+(readBuffer[(i*4)+2]<<8)+readBuffer[(i*4)+3];
        [buf appendString:[NSString stringWithFormat:@"%d",num]];
        [buf appendString:@","];
    }
    
    [buf appendString:@"}"];
    return buf;
}

- (long long) readLong {

    NSData *data = [outFile readDataOfLength:8];
    Byte * readBuffer=(Byte * )[data bytes];
    if([data length]<8) return -1;
    union BLong l;
    l.c[0]=readBuffer[7];
    l.c[1]=readBuffer[6];
    l.c[2]=readBuffer[5];
    l.c[3]=readBuffer[4];
    l.c[4]=readBuffer[3];
    l.c[5]=readBuffer[2];
    l.c[6]=readBuffer[1];
    l.c[7]=readBuffer[0];
    
    return l.l;
}

- (int) readShort
{
    NSData *data = [outFile readDataOfLength:2];
    Byte * readBuffer=(Byte * )[data bytes];
    if([data length]<2) return -1;
    return (readBuffer[0]<<8)+readBuffer[1];
}

- (NSString *)readBoolean {
    NSData *data = [outFile readDataOfLength:1];
    Byte * readBuffer=(Byte * )[data bytes];
    if([data length]<1) return @"false";
    if(readBuffer[0]>=1) return @"true";
    else return @"false";
}

- (double) readDouble {
    long long longNum=[self readLong];
    if(longNum<0)return -1;
    union LDouble d;
    d.i=longNum;
    return d.d;
}


// used for data writed by IFileOutPutStream
- (NSString *) readStringWithLength
{
    int len=[self readInt];
    NSData *data = [outFile readDataOfLength:len];
    Byte * readBuffer=(Byte * )[data bytes];
    
    //NSString *readBufferString =[[NSString alloc] initWithBytesNoCopy: readBuffer length: bytesRead encoding: NSUTF8StringEncoding freeWhenDone: NO];
    NSString * a=[[NSString alloc] initWithBytes:readBuffer length:[data length] encoding:NSUTF8StringEncoding];
    
    return a;
    
}

// used for external data
- (NSString *)readString:(int) len
{
    NSData *data = [outFile readDataOfLength:len];
    Byte * readBuffer=(Byte * )[data bytes];
    
    NSString *readBufferString =[[NSString alloc] initWithBytes:readBuffer length:[data length] encoding:NSUTF8StringEncoding];
    
    return readBufferString;
}

- (Byte) readByte {
    
    NSData *data = [outFile readDataOfLength:1];
    Byte * readBuffer=(Byte * )[data bytes];
    if([data length]<81) return -1;
    return readBuffer[0];
}

- (NSString *) readBytes:(int) len {
    NSData *data = [outFile readDataOfLength:len];
    Byte * readBuffer=(Byte * )[data bytes];

    NSMutableString * buf = [[NSMutableString alloc] initWithCapacity:len];
    
    for (int i=0;i<[data length];i++)
    {
        [buf appendString:[NSString stringWithFormat:@"%d",readBuffer[i]]];
		[buf appendString:@","];
    }
    
    return buf;
}


@end
