//
//  OLAProgressBar.h
//  Ola
//
//  Created by Terrence Xing on 4/24/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OLAWedgit.h"
@interface OLAProgressBar : OLAWedgit
{

}
@property (nonatomic) float progressPercent;
- (id) initWithParent:(OLAView *)parent withXMLElement:(XMLElement *) root andUIFactory:(OLAUIFactory *)uiFactory;
- (void) setValue:(float) value;
@end
