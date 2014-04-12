//
//  OLARelativeLayout.h
//  Ola
//
//  Created by Terrence Xing on 3/20/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#import "Layout.h"
#import "OLAView.h"

@interface RelativeLayout : Layout
{
    NSMutableArray * children;
    LayoutParams layoutParams;
    NSString * objId;

}
@property (nonatomic,retain)NSMutableArray * children;
@property (nonatomic) LayoutParams  layoutParams;
@property (nonatomic) NSString * objId;

-(id) initWithFrame:(CGRect) frame;
-(void)addSubview:(OLAView *) view;
-(void)repaint;

@end
