//
//  OLAThreeDotsView.h
//  Ola
//
//  Created by lohool on 10/23/16.
//  Copyright (c) 2016 Terrence Xing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OLAThreeDotsView : UIView

@property (assign, nonatomic, readonly) BOOL isShowing;

-(id) initWithView:(UIView *) view blur:(BOOL) blur;

-(void) show;

-(void) showWhileExecutingBlock:(dispatch_block_t) block;

-(void) showWhileExecutingBlock:(dispatch_block_t)block completion:(dispatch_block_t) completion;

-(void) showWhileExecutingSelector:(SEL) selector onTarget:(id) target withObject:(id) object;

-(void) showWhileExecutingSelector:(SEL)selector onTarget:(id)target withObject:(id)object completion:(dispatch_block_t) completion;

-(void) dismiss;

@end