//
//  OLAButton.h
//  Ola
//
//  Created by Terrence Xing on 3/22/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OLAView.h"
#import "OLATextView.h"

@interface OLAButton : OLATextView
- (id) initWithParent:(OLAView *)parent withXMLElement:(XMLElement *) root andUIFactory:(OLAUIFactory *)uiFactory;
-(void)setText:(NSString *) text;
-(NSString *)getText;
@end
