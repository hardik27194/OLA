//
//  OLAFrameLayout.h
//  Ola
//
//  Created by Terrence Xing on 3/26/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Layout.h"
#import "OLAView.h"

@interface FrameLayout : Layout
{
    NSMutableArray * children;
    LayoutParams layoutParams;
    NSString * objId;
    Margin margin;
    Padding padding;
    
}
@property (nonatomic,retain)NSMutableArray * children;
@property (nonatomic) LayoutParams  layoutParams;
@property (nonatomic) NSString * objId;
@property (nonatomic) Margin margin;
@property (nonatomic) Padding padding;
-(id) initWithFrame:(CGRect) frame;
-(void)addSubview:(OLAView *) view;
-(void)repaint;

@end
