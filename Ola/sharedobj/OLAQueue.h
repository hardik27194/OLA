//
//  OLAQueue.h
//  Ola
//
//  Created by Terrence Xing on 5/3/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OLAQueue : NSObject
{
    NSMutableArray* m_array;
}
- (void)push:(id)anObject;
- (id)pop;
- (void)clear;
@property (nonatomic, readonly) int count;
@end
