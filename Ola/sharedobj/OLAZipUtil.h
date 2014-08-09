//
//  OLAZipUtil.h
//  Ola
//
//  Created by Terrence Xing on 6/18/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OLAZipUtil : NSObject

@property (nonatomic,retain,readonly) NSString * zipFileName;

- (id) initWithZipFileName:(NSString *) fileName;
+  (id) open:(NSString *)zipFileName;
-  (void) unzipTo:(NSString *)folderPath;

@end
