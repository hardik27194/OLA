//
//  UIView+WhenTappedBlocks.h
//  Ola
//
//  Created by Terrence Xing on 3/30/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#if NS_BLOCKS_AVAILABLE

#import <UIKit/UIKit.h>

typedef void (^JMWhenTappedBlock)();

@interface UIView (JMWhenTappedBlocks) <UIGestureRecognizerDelegate>

- (void)whenTapped:(JMWhenTappedBlock)block;
- (void)whenDoubleTapped:(JMWhenTappedBlock)block;
- (void)whenTwoFingerTapped:(JMWhenTappedBlock)block;
- (void)whenTouchedDown:(JMWhenTappedBlock)block;
- (void)whenTouchedUp:(JMWhenTappedBlock)block;

@end

#endif