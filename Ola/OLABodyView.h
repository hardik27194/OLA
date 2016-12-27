//
//  OLABodyView.h
//  Ola
//
//  Created by Terrence Xing on 3/25/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#import "OLAWedgit.h"
@class OLALayout;

@interface OLABodyView : NSObject
{
    NSString * viewUrl;
    NSString * parameters;
    OLAView * ctx;
    NSString * LuaCode;
    OLALayout * bodyLayout;
}
@property (nonatomic,retain)NSString * viewUrl;
@property (nonatomic,retain)NSString * parameters;
@property (nonatomic,retain)OLAView * ctx;
@property (nonatomic,retain)NSString * LuaCode;
@property (nonatomic)OLALayout * bodyLayout;

- (id) initWithViewController:(OLAView *)bodyView andViewXMLUrl:(NSString * )viewUrl;
- (void) show;
- (void) execCallBack:(NSString *) callback;
- (void) executeLua;
@end
