//
//  OLAQueue.m
//  Ola
//
//  Created by Terrence Xing on 5/3/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#import "OLAQueue.h"

@implementation OLAQueue
@synthesize count;
- (id)init
{
    if( self=[super init] )
    {
        m_array = [[NSMutableArray alloc] init];
        count = 0;
    }
    return self;
}

- (void)push:(id)anObject
{
    [m_array addObject:anObject];
    count = m_array.count;
}
- (id)pop
{
    id obj = nil;
    if(m_array.count > 0)
    {
        obj = [m_array objectAtIndex:0];
        [m_array removeObjectAtIndex:0];
        count = m_array.count;
    }
    return obj;
}
- (void)clear
{
    [m_array removeAllObjects];
    count = 0;
}

@end
