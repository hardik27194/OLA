//
//  NSString+StringForJava.h
//  Ola
//
//  Created by lohool on 10/23/16.
//  Copyright (c) 2016 Terrence Xing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NSStringForJava)

//对比两个字符串内容是否一致
- (BOOL) equals:(NSString*) string;

//判断字符串是否以指定的前缀开头
- (BOOL) startsWith:(NSString*)prefix;

//判断字符串是否以指定的后缀结束
- (BOOL) endsWith:(NSString*)suffix;

//转换成大写
- (NSString *) toLowerCase;

//转换成小写
- (NSString *) toUpperCase;

//截取字符串前后空格
- (NSString *) trim;

//用指定分隔符将字符串分割成数组
- (NSArray *) split:(NSString*) separator;

//用指定字符串替换原字符串
- (NSString *) replaceAll:(NSString*)oldStr with:(NSString*)newStr;

//从指定的开始位置和结束位置开始截取字符串
- (NSString *) substringFromIndex:(int)begin toIndex:(int)end;

@end