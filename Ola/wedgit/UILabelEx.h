//
//  UILabelEx.h
//  Ola
//
//  Created by Terrence Xing on 3/29/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//


#import <UIKit/UIKit.h>
typedef enum VerticalAlignment {
    VerticalAlignmentTop,
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
} VerticalAlignment;

@interface UILabelEx : UILabel {
        BOOL isResponsedTouchEvent;
        id delegate;
    NSString * backgroundImageUrl;
    NSString *backgroundColorString;
    float backgroundAlpha;

@private
    VerticalAlignment verticalAlignment_;
}

@property (nonatomic, assign) VerticalAlignment verticalAlignment;
@property (nonatomic)id delegate;
@property (nonatomic)BOOL isResponsedTouchEvent;
@property (nonatomic) NSString * backgroundImageUrl;
@property (nonatomic)NSString *backgroundColorString;
@property (nonatomic) float backgroundAlpha;


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;  //手指触摸屏幕时报告UITouchPhaseBegan事件
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event ;  //在手指在屏幕上移动时报告UITouchPhaseMoved事件
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event ;  //在手指离开屏幕时报告UITouchPhaseEnded事件
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;    //在因接听电话或其他因素导致取消触摸时报告UITouchPhaseCancelled事件
 
@end

