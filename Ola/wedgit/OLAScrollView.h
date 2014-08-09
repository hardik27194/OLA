//
//  OLAScrollView.h
//  Ola
//
//  Created by Terrence Xing on 3/29/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#import "OLALayout.h"
#import "ScrollerView.h"

@interface OLAScrollView : OLALayout<UIScrollViewDelegate>

{
    ScrollerView * layout;
    NSMutableArray * children;
}
@property (nonatomic) ScrollerView * layout;
@property (nonatomic) NSMutableArray * children;

- (id) initWithParent:(OLAView *)parentView withXMLElement:(XMLElement *) root;
-(void) resetContentSizeToFitChildren;
- (void) repaint;
-(void)setFrameMinSize;
@end
