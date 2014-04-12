//
//  OLALinearLayout.h
//  Ola
//
//  Created by Terrence Xing on 3/19/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#import "Layout.h"
#import "OLAView.h"

typedef enum
{
    horizontal,
    vertical
}Orientation;


@interface LinearLayout : Layout
{
    NSMutableArray * children;
    Orientation orientation;
    LayoutParams layoutParams;
    NSString * objId;
    Margin margin;
    Padding padding;
    
}
@property (nonatomic,retain)NSMutableArray * children;
@property (nonatomic) Orientation orientation;
@property (nonatomic) LayoutParams  layoutParams;
@property (nonatomic) NSString * objId;
@property (nonatomic) Margin margin;
@property (nonatomic) Padding padding;

-(id) initWithFrame:(CGRect) frame;
-(void)initSize;
-(void)addSubview:(OLAView *) view;
-(CGSize)minSize;
-(void)repaint;
-(void) requestLayout;
-(void)resizeToFitMaxChild;
- (void) reSetChildrenFrame;
-(CGSize)sumMargin;
@end
