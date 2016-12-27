//
//  OLAContainer.h
//  Ola
//
//  Created by Terrence Xing on 3/23/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#import "OLAWedgit.h"
#import "OLAUIFactory.h"

@interface OLAContainer:OLAWedgit
{
    
}

- (id) initWithParent:(OLAView *) viewParent  withXMLElement:(XMLElement *) xmlRoot andUIFactory:(OLAUIFactory *)uiFactory;

- (void) parseChildren:(OLAContainer *) rootView withXMLElement:(XMLElement *) root;
- (void) repaint;
- (void) setFrameMinSize;
- (void) removeAllViews;
@end
