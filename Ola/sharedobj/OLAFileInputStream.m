//
//  OLAFileInputStream.m
//  Ola
//
//  Created by Terrence Xing on 4/1/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#import "OLAFileInputStream.h"

@implementation OLAFileInputStream

@synthesize isExisted,reader,filePath;
    
	
//NSFileHandle  *inFile;


    
	-(id) initWithFilePath:(NSString *)path
{
    //NSString *homePath =   [NSHomeDirectory( ) stringByAppendingPathComponent:@"Documents"];
    NSString *sourcePath = path;//[homePath stringByAppendingPathComponent:path];  //源文件路径
    filePath=sourcePath;
    NSLog(@"file=%@",sourcePath);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:filePath])
    {
        isExisted=true;
        reader= [[NSInputStream alloc] initWithFileAtPath: filePath];
        [reader open];
    }
    else{
    //inFile=[NSFileHandle fileHandleForReadingAtPath:sourcePath];
    //NSUInteger length=[inFile availableData].length;
    
    //reader=[inFile readDataToEndOfFile];
        
        
        
    }

    return self;
	}
    
+ (id) open:(NSString *) filePath
{
    id iner= [[OLAFileInputStream alloc] initWithFilePath:filePath];
    return iner;

	}
    

    
	- (NSString *) exists
{
    NSLog(@"input stream exists()...");
        if(!isExisted) //如果不存在
        {
            
            return @"false";
        }
        else{

            return @"true";
        }
	}
    
	- (int) available
{
		//return [inFile availableData].length;;
    return 0;
	}
    
	- (int) readInt {
        uint8_t readBuffer [4];
        
		NSInteger bytesLen=[reader read:readBuffer maxLength:4];
        if(bytesLen<=3)return -1;
        /*
        NSLog(@"---int---");
        NSLog(@"len=%x",bytesLen);
        NSLog(@"b0=%x",readBuffer[0]);
        NSLog(@"b1=%x",readBuffer[1]);
        NSLog(@"b2=%x",readBuffer[2]);
        NSLog(@"b3=%x",readBuffer[3]);
         */
        return (readBuffer[0]<<24)+(readBuffer[1]<<16)+(readBuffer[2]<<8)+readBuffer[3];
	}
    
- (NSString *) readIntArray:(int )len
{
    
		NSMutableString * buf = [[NSMutableString alloc] initWithCapacity:len];
    [buf appendString:@"{"];
    
    uint8_t readBuffer [4*len];
    NSInteger bytesLen=[reader read:readBuffer maxLength:4*len];
    for( int i=0;i<bytesLen/4;i++)
    {
        int num= (readBuffer[(i*4)+0]<<24)+(readBuffer[(i*4)+1]<<16)+(readBuffer[(i*4)+2]<<8)+readBuffer[(i*4)+3];
        [buf appendString:[NSString stringWithFormat:@"%d",num]];
        [buf appendString:@","];
    }

		[buf appendString:@"}"];
		return buf;
	}
    
	- (long long) readLong {
        uint8_t readBuffer [8];
        
		NSInteger bytesLen=[reader read:readBuffer maxLength:8];
        if(bytesLen<8)return -1;
        //return (readBuffer[0]<<56)+(readBuffer[1]<<48)+(readBuffer[2]<<40)+(readBuffer[3]<<32)+(readBuffer[4]<<24)+(readBuffer[5]<<16)+(readBuffer[6]<<8)+readBuffer[7];
        /*
        NSLog(@"---long---");
        NSLog(@"len=%x",bytesLen);
        NSLog(@"b0=%x",readBuffer[0]);
        NSLog(@"b1=%x",readBuffer[1]);
        NSLog(@"b2=%x",readBuffer[2]);
        NSLog(@"b3=%x",readBuffer[3]);
        NSLog(@"b4=%x",readBuffer[4]);
        NSLog(@"b5=%x",readBuffer[5]);
        NSLog(@"b6=%x",readBuffer[6]);
        NSLog(@"b7=%x",readBuffer[7]);
        */
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
		uint8_t readBuffer [2];
        
		NSInteger bytesLen=[reader read:readBuffer maxLength:2];
    if(bytesLen<=0)return -1;
        return (readBuffer[0]<<8)+readBuffer[1];
	}
    
	- (NSString *)readBoolean {
		uint8_t readBuffer [1];
        
		NSInteger bytesLen=[reader read:readBuffer maxLength:1];
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
    uint8_t readBuffer [len];
    NSInteger bytesRead = [reader read: readBuffer maxLength:len];

    //NSString *readBufferString =[[NSString alloc] initWithBytesNoCopy: readBuffer length: bytesRead encoding: NSUTF8StringEncoding freeWhenDone: NO];
    NSString * a=[[NSString alloc] initWithBytes:readBuffer length:bytesRead encoding:NSUTF8StringEncoding];

		return a;
        
	}
    
	// used for external data
- (NSString *)readString:(int) len
{
    uint8_t readBuffer [len];
    NSInteger bytesRead = [reader read: readBuffer maxLength:len];
    
    NSString *readBufferString =[[NSString alloc] initWithBytes:readBuffer length:bytesRead encoding:NSUTF8StringEncoding];
    
    return readBufferString;
	}
    
	- (Byte) readByte {
        
        uint8_t readBuffer [1];
        NSInteger bytesRead = [reader read: readBuffer maxLength:1];
		return readBuffer[0];
	}

- (NSString *) readBytes:(int) len {
    NSLog(@"readBytes...len=%d",len);
    NSLog(@"file=%@",filePath);
    
    uint8_t readBuffer [len];
    NSInteger bytesRead = [reader read: readBuffer maxLength:len];
    NSLog(@"read bytes count=%d",bytesRead);
    NSMutableString * buf = [[NSMutableString alloc] initWithCapacity:len];

    for (int i=0;i<len;i++)
    {
        [buf appendString:[NSString stringWithFormat:@"%d",readBuffer[i]]];
		[buf appendString:@","];
			}

		return buf;
	}

    
	- (void) skipBytes:(int) len {
        NSLog(@"reader skip bytes,len=%d",len);
        if(len>0)
        {
		uint8_t readBuffer [len];
        NSInteger bytesRead = [reader read: readBuffer maxLength:len];
        }
	}

	- (void) close {
		[reader close];
	}
    

    






                     
/*
 int、char、double与byte相互转换的程序
 
 2009-12-31 15:36:29|  分类： C#编程 |举报|字号 订阅
 尽管实际上对 C 或 C++ 中的每种指针类型构造，C# 都设置了与之对应的引用类型，但仍然会有一些场合需要访问指针类型。例如，当需要与基础操作系统进行交互、访问内存映射设备，或实现一些以时间为关键的算法时，若没有访问指针的手段，就不可能或者至少很难完成。为了满足这样的需求，C# 提供了编写不安全代码的能力。
 
 在不安全代码中，可以声明和操作指针，可以在指针和整型之间执行转换，还可以获取变量的地址，等等。在某种意义上，编写不安全代码很像在 C# 程序中编写 C 代码。
 
 无论从开发人员还是从用户角度来看，不安全代码事实上都是一种“安全”功能。不安全代码必须用修饰符 unsafe 明确地标记，这样开发人员就不会误用不安全功能，而执行引擎将确保不会在不受信任的环境中执行不安全代码。
 
 using System;
 
 using System.Runtime.InteropServices;
 
 
 
 namespace CSPointer
 
 {
 
 //// <summary>

/// PointerConvert 的摘要说明。

/// 指针转换类

/// 通过指针的方式更改数据类型

/// 支持:byte <-> int/float/double

///      string 类型可以通过

///      System.Text.Encoding进行编码

/// 用途:数据传输

///

/// 作者:萧寒

/// http://www.cnblogs.com/chinasf

/// mailluck@Gmail.com

/// 最后更新日期:2005.5.27

/// </summary>

public unsafe class PointerConvert

{
    
    public PointerConvert(){;}
    
    
    
    //// <summary>
    
    /// 转换Int数据到数组
    
    /// </summary>
    
    /// <param name="data"></param>
    
    /// <returns></returns>
    
    public static byte[] ToByte(int data)
    
    {
        
        unsafe
        
        {
            
            byte* pdata = (byte*)&data;
            
            byte[] byteArray = new byte[sizeof(int)];
            
            for (int i = 0; i < sizeof(int); ++i)
                
                byteArray[i] = *pdata++;
            
            return byteArray;
            
        }
        
    }
    
    
    
    
    
    //// <summary>
    
    /// 转换float数据到数组
    
    /// </summary>
    
    /// <param name="data"></param>
    
    /// <returns></returns>
    
    public static byte[] ToByte(float data)
    
    {
        
        unsafe
        
        {
            
            byte* pdata = (byte*)&data;
            
            byte[] byteArray = new byte[sizeof(float)];
            
            for (int i = 0; i < sizeof(float); ++i)
                
                byteArray[i] = *pdata++;
            
            return byteArray;
            
        }
        
    }
    
    
    
   //// <summary>
    
    /// 转换double数据到数组
    
    /// </summary>
    
    /// <param name="data"></param>
    
    /// <returns></returns>
    
    public static byte[] ToByte(double data)
    
    {
        
        unsafe
        
        {
            
            byte* pdata = (byte*)&data;
            
            byte[] byteArray = new byte[sizeof(double)];
            
            for (int i = 0; i < sizeof(double); ++i)
                
                byteArray[i] = *pdata++;
            
            return byteArray;
            
        }
        
    }
    
    
    
    
    
    //// <summary>
    
    /// 转换数组为整形
    
    /// </summary>
    
    /// <param name="data"></param>
    
    /// <returns></returns>
    
    public static int ToInt(byte[] data)
    
    {
        
        unsafe
        
        {
            
            int n = 0;
            
            fixed(byte* p=data)
            
            {
                
                n = Marshal.ReadInt32((IntPtr)p);
                
            }
            
            return n;
            
        }
        
    }
    
    
    
    //// <summary>
    
    /// 转换数组为float
    
    /// </summary>
    
    /// <param name="data"></param>
    
    /// <returns></returns>
    
    public static float ToFloat(byte[] data)
    
    {
        
        float a=0;
        
        byte i;
        
        
        
        byte[] x = data;
        
        void *pf;
        
        fixed(byte* px=x)
        
        {
            
            pf =&a;
            
            for(i=0;i<data.Length;i++)
                
            {
                
                *((byte *)pf+i)=*(px+i);
                
            }
            
        }
        
        
        
        return a;
        
    }
    
    
    
    //// <summary>
    
    /// 转换数组为Double
    
    /// </summary>
    
    /// <param name="data"></param>
    
    /// <returns></returns>
    
    public static double ToDouble(byte[] data)
    
    {
        
        double a=0;
        
        byte i; 
        
        
        
        byte[] x = data; 
        
        void *pf; 
        
        fixed(byte* px=x) 
        
        { 
            
            pf =&a; 
            
            for(i=0;i<data.Length;i++) 
                
            { 
                
                *((byte *)pf+i)=*(px+i); 
                
            } 
            
        } 
        
        return a; 
        
    } 
    
} 

}
*/
                     


@end
