//
//  OLAScrollView.h
//  Ola
//
//  Created by Terrence Xing on 3/29/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#import "OLALayout.h"

@interface OLAScrollView : OLALayout<UIScrollViewDelegate>

{
    UIScrollView * layout;
    NSMutableArray * children;
}
@property (nonatomic) UIScrollView * layout;
@property (nonatomic) NSMutableArray * children;

- (id) initWithParent:(OLAView *)parentView withXMLElement:(XMLElement *) root;
-(void) resetContentSizeToFitChildren;
- (void) repaint;
@end
