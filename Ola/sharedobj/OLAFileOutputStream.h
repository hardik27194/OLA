//
//  OLAFileOutputStream.h
//  Ola
//
//  Created by Terrence Xing on 3/31/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OLAFileStream.h"

@interface OLAFileOutputStream : NSObject
{
    bool isExisted;
    NSMutableData *writer ;
    NSFileHandle  *outFile;
}
@property (nonatomic) bool isExisted;
@property (nonatomic,retain) NSMutableData *writer;
@property (nonatomic,retain) NSFileHandle  *outFile;


+(id) open:(NSString *) fileName;
- (void) writeInt:(int) val;
- (void) writeShort:(short) val;
- (void) writeLong:(long long) val;
- (void) writeDouble:(double) d;
- (void) writeBoolean:(bool) val;
- (void) writeByte:(Byte) val;
- (void) writeString:(NSString *)val;
- (void) writeStringWithLength:(NSString *)val;
- (void) seek:(long long) pos;
- (void) skipBytes:(long long) count;
-(long long) getFilePointer;
- (void) close;
@end
