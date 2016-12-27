//
//  OLAFrameLayout.h
//  Ola
//
//  Created by Terrence Xing on 3/26/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#import "OLALayout.h"
#import "FrameLayout.h"
@interface OLAFrameLayout : OLALayout
{
    FrameLayout * layout;
}
@property (nonatomic) FrameLayout * layout;
- (id) initWithParent:(OLAView *)parentView andUIRoot:(XMLElement *) root andUIFactory:(OLAUIFactory *)uiFactory;
@end
