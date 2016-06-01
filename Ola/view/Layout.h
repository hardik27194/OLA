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
    int left;
    int top;
    int right;
    int bottom;
    int weight;
    int width;
    int height;
}*LayoutParams;



@interface Layout : IView
{
     NSString * backgroundImageUrl;
    //UIColor *backgroundColor;
    //float bgAlpha;
}

@property (nonatomic,retain) NSString * backgroundImageUrl;

//@property (nonatomic) float bgAlpha;
-(void)repaint;
-(void)setFrameMinSize;
-(CGSize)minSize;
 
@end
