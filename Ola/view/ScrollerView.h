//
//  ScrollerView.h
//  Ola
//
//  Created by Terrence Xing on 4/11/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScrollerView : UIScrollView
{
    id wrapper;
}
@property (nonatomic)id wrapper;

-(void)setFrameMinSize;

- (void) repaint;
@end
