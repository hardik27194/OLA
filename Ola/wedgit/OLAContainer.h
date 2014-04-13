//
//  OLAContainer.h
//  Ola
//
//  Created by Terrence Xing on 3/23/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#import "OLAWedgit.h"

@interface OLAContainer : OLAWedgit
- (void) parseChildren:(OLAContainer *) rootView withXMLElement:(XMLElement *) root;
- (void) repaint;
@end
