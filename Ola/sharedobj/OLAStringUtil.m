//
//  OLAStringUtil.m
//  Ola
//
//  Created by Terrence Xing on 4/1/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#import "OLAStringUtil.h"

@implementation OLAStringUtil

+(NSString*)fun_test:(NSString*)a
{
    NSLog(@"lua ios fun test:a=%@, b=",a);
    return  @"AAAA";
}
    
	+ (NSString *) UTF6LE:(int) uc lc:(int) lc
	{
		if(lc<0)lc=lc&0xFF;
        int  c[]={lc,(uc << 8)};
        NSString * str= [[NSString alloc] initWithBytes:c length:2 encoding:NSUTF16LittleEndianStringEncoding];
		return  str;
	}
	
+ (NSString *) toUTF6LE:(NSString *) byteArray
	{
		//NSMutableString * buf= [[NSMutableString alloc] initWithCapacity:1];
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
        NSLog(@"bs count=%lu",bs.count);

        NSString * str= [[NSString alloc]  initWithBytes:chars length:bs.count encoding:NSUTF16LittleEndianStringEncoding];
        return str;

	}

/**
 * add a new parameter to the callback method
 * @param callback
 * @param param
 * @return
 */
+ (NSString *) addParameter:(NSString *)callback param:(NSString *)params
{
    
    callback=[callback stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    //NSRange pos= [callback rangeOfString:@")" options:NSBackwardsSearch];
    NSString *s;
    if( [callback  characterAtIndex:[callback length]-1] ==')' )
    {
        NSString *pre=[callback substringToIndex:[callback length]-1];
        pre=[pre stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if([pre characterAtIndex:pre.length-1]!='(')
        {
            s=[pre stringByAppendingFormat:@",%@)",params];
        }
        else
        {
            s=[pre stringByAppendingFormat:@"%@)",params];

        }
    }
    else
    {
        s=callback;
    }
    return s;
}


@end
