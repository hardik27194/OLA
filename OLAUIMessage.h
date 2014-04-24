//
//  OLAUIMessage.h
//  Ola
//
//  Created by Terrence Xing on 4/25/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OLAUIMessage : NSObject
+ (id) create;
-(void) updateMessage:(NSString *) msg;
@end
