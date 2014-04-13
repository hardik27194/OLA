//
//  OLATable.h
//  Ola
//
//  Created by Terrence Xing on 3/29/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#import "OLALayout.h"
#import "LinearLayout.h"
@interface OLATable : OLALayout
{
    LinearLayout * layout;
}
@property (nonatomic) LinearLayout * layout;
- (id) initWithParent:(OLAView *)parentView andUIRoot:(XMLElement *) root;
@end
