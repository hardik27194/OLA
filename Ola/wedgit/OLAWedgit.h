//
//  OLAWedgit.h
//  Ola
//
//  Created by Terrence Xing on 3/21/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OLAView.h"
#import "XMLElement.h"
#import "CSS.h"

#import "IViewEvent.h"


@interface OLAWedgit : OLAView<UIGestureRecognizerDelegate,IViewEvent>

- (id) initWithParent:(OLAView *) viewParent  withXMLElement:(XMLElement *) xmlRoot;
- (void) initiate;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;  //手指触摸屏幕时报告UITouchPhaseBegan事件
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event ;  //在手指在屏幕上移动时报告UITouchPhaseMoved事件
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event ;  //在手指离开屏幕时报告UITouchPhaseEnded事件
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;    //在因接听电话或其他因素导致取消触摸时报告UITouchPhaseCancelled事件

-(void) setAlpha:(float) alpha;
-(void) setVisibility:(NSString *)value;

-(void) setBackgroundImageUrl:(NSString *) imageUrl;

+ (UIImage *)imageScale:( UIImage *)sourceImage toSize:(CGSize)targetSize;
- (void) setHeight:(int) height;
- (void) setWidth:(int) width;

- (NSString *)getId;

@end
