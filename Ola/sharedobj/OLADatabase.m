//
//  OLADatabase.m
//  Ola
//
//  Created by Terrence Xing on 4/8/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#import "OLADatabase.h"
#import "OLAProperties.h"
#import "sqlite3.h"
@implementation OLADatabase


sqlite3 *db;
//private HashMap values;
- (id) init
{
    self=[super init];
    return self;
}
//	public Database getInstance()
//	{
//		return new Database(MainActivity);
//	}
- (BOOL) isExist:(NSString *) dbName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:dbName])
    {
        return YES;
    }
    else return NO;
}

- (void) open:(NSString *)databse
{
    //NSString *path=[[[OLAProperties getInstance] getRootPath] stringByAppendingString:databse];
    NSString *path=[NSHomeDirectory() stringByAppendingFormat:@"/Library/%@",databse];
    [self openLocal:[path UTF8String]];
}


- (int) openLocal:(const char *) dbPath
{
    int result = sqlite3_open(dbPath, &db);
    NSLog(@"database path=%s",dbPath);
    return result;
}
- (int) execSQL:(const char *)sql
{
    char * errorMsg;
    return sqlite3_exec(db, sql, NULL, NULL, &errorMsg);

}
/*
- (long) insert:(NSString *)table withColumns:(NSArray *)columns andValues:(NSArray) values
{
    ContentValues initialValues = new ContentValues();
    for(int i=0;i<columns.length;i++)
    {
        initialValues.put(columns[i], values[i]);
    }
    return db.insert(table, null, initialValues);
}
*/
//	public ArrayList query(String table, String[] columns)
//	{
//		//db.query(distinct, table, columns, selection, selectionArgs, groupBy, having, orderBy, limit, cancellationSignal);
//		Cursor cursor=db.query( table, columns, null, null, null, null, null, null);
//		ArrayList results=new ArrayList();
//		while(cursor.moveToLast())
//		{
//			int size=cursor.getCount();
//			HashMap values=new HashMap();
//			for(int i=0;i<size;i++)
//			{
//				String name=cursor.getColumnName(i);
//				String value=cursor.getString(i);
//				values.put(name, value);
//			}
//			results.add(values);
//		}
//		return results;
//	}
- (NSString *)query:(NSString *)sql //withParameters:(NSObject *) selectionArgs
{
    NSMutableString *buf= [[NSMutableString alloc] initWithCapacity:2];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            [buf appendString:@"{"];
            for(int i=0;i<sqlite3_column_count(statement);i++)
            {
                char *value = (char *)sqlite3_column_text(statement, i);
                char *name = (char *)sqlite3_column_name(statement, i);
                if(i!=0)[buf appendString:@","];
                [buf appendString:[NSString stringWithUTF8String:name]];
                [buf appendString:@"=\""];
                [buf appendString:[NSString stringWithUTF8String:value]];
                [buf appendString:@"\""];
            }
            [buf appendString:@"}"];
            [buf appendString:@","];
        }
    }
    NSString *result=[ buf  substringToIndex:[buf length]-1];

    return result;
}

- (void) close
{
    sqlite3_close(db);
}


@end
