//
//  Layout.h
//  Ola
//
//  Created by Terrence Xing on 3/26/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IView.h"

typedef struct _LayoutParams
{
    const char * align;
    const char * valign;
    int weight;
    int width;
    int height;
}*LayoutParams;



@interface Layout : IView<UIGestureRecognizerDelegate>

-(void)repaint;
-(void)setFrameMinSize;
-(CGSize)minSize;
@end
