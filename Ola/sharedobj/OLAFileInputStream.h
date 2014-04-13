//
//  OLAFileInputStream.h
//  Ola
//
//  Created by Terrence Xing on 4/1/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OLAFileStream.h"


@interface OLAFileInputStream : NSObject
{
    bool isExisted;
    NSString * filePath;
    
    NSInputStream *reader ;
}
@property (nonatomic) bool isExisted;
@property (nonatomic,retain) NSString * filePath;
@property (nonatomic,retain)NSInputStream *reader ;

+ (id) open:(NSString *) filePath;
- (NSString *) exists;
- (int) available;
- (int) readInt;
- (NSString *) readIntArray:(int )len;
- (long long) readLong ;
- (int) readShort;
- (NSString *)readBoolean ;
- (double) readDouble;
- (NSString *) readStringWithLength;
- (NSString *)readString:(int) len;
- (Byte) readByte;
- (NSString *) readBytes:(int) len;
- (void) skipBytes:(int) len;
- (void) close ;

@end
