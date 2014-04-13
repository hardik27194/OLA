//
//  OLAStringUtil.m
//  Ola
//
//  Created by Terrence Xing on 4/1/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#import "OLAStringUtil.h"

@implementation OLAStringUtil

    
	+ (NSString *) UTF6LE:(int) uc lc:(int) lc
	{
		if(lc<0)lc=lc&0xFF;
        int  c[]={lc,(uc << 8)};
        NSString * str= [[NSString alloc] initWithBytes:c length:2 encoding:NSUTF16LittleEndianStringEncoding];
		return  str;
	}
	
+ (NSString *) toUTF6LE:(NSString *) byteArray
	{
		NSMutableString * buf= [[NSMutableString alloc] initWithCapacity:1];
        //		buf.deleteCharAt(buf.length()-1);
        //		buf.deleteCharAt(0);
        NSArray *bs=[byteArray  componentsSeparatedByString:@","];
        
        
        Byte * chars =(Byte *)malloc(bs.count*sizeof(Byte));
        int i=0;
        for(NSString * s in bs)
        {
            int c=[s intValue];
            //*chars++=c;
            chars[i]=c;
            i++;
        }
        NSLog(@"bs count=%d",bs.count);

        NSString * str= [[NSString alloc]  initWithBytes:chars length:bs.count encoding:NSUTF16LittleEndianStringEncoding];
        return str;
        /*
		int i=0;
		for(i=0;i<bs.count;i++)
		{
			if(i>=bs.count || bs[i].equals("") || i+1>=bs.length || bs[i+1].equals(""))
			{
				i++;
				
			}
			else
			{
				int l=Integer.parseInt(bs[i]);
				i++;
				int h=Integer.parseInt(bs[i]);
				buf.append(UTF6LE(h,l));
			}
		}
		return buf.toString();
         */
	}

@end
