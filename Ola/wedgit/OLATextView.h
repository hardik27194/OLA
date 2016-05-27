//
//  OLATextView.h
//  Ola
//
//  Created by Terrence Xing on 3/23/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#import "OLAContainer.h"

@interface OLATextView : OLAWedgit
-(void)setText:(NSString *) text;
-(NSString *)getText;
- (NSString *) getColor;
- (void) setColor:(NSString *) color;
-(void) setFont:(UIFont *)font;
@end
