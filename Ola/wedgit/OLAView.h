//
//  OLAView.h
//  Ola
//
//  Created by Terrence Xing on 3/21/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OLAView.h"
#import "XMLElement.h"
#import "CSS.h"


#define  trim(str)  [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]

@interface OLAView : NSObject
{
    NSString * objId;
    NSString * onclick ;
    NSString * threadClick;
    NSString * pressed ;
    NSString * released ;
    OLAView * parent;
    
    NSString * clickFun;
    
    UIView * v;
    
    XMLElement * root;
    CSS * css;
}
@property (nonatomic)NSString * objId;
@property (nonatomic)NSString * threadClick ;
@property (nonatomic)NSString * onclick ;
@property (nonatomic)NSString * pressed ;
@property (nonatomic)NSString * released ;
@property (nonatomic)OLAView * parent;

@property (nonatomic)NSString * clickFun;

@property (nonatomic)UIView * v;

@property (nonatomic)XMLElement * root;
@property (nonatomic)CSS * css;



@end
