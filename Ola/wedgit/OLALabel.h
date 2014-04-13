//
//  OLALabel.h
//  Ola
//
//  Created by Terrence Xing on 3/29/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#import "OLALayout.h"
#import "OLAView.h"
#import "OLATextView.h"
@interface OLALabel : OLATextView
- (id) initWithParent:(OLAView *)parent withXMLElement:(XMLElement *) root;
-(void)setText:(NSString *) text;
-(NSString *)getText;
-(void)adjustSize:(CGFloat) width;
@end
