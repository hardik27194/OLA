//
//  OLADatabase.h
//  Ola
//
//  Created by Terrence Xing on 4/8/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OLADatabase : NSObject

- (id) init;
+(id)create;
- (BOOL) isExist:(NSString *) dbName;
- (void) open:(NSString *)databse;
//- (int) openLocal:(NSString *) dbName;
- (int) execSQL:(NSString *)sql;
- (NSString *)query:(NSString *)sql;
- (void) close;
@end
