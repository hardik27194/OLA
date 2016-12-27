//
//  OLALayout.m
//  Ola
//
//  Created by Terrence Xing on 3/19/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#import "OLALayout.h"
#import "XMLElement.h"
#import "OLALinearLayout.h"
#import "XMLDocument.h"
#import "OLAFrameLayout.h"
#import "OLARelativeLayout.h"
#import "OLALongPressGestureRecognizer.h"
#import "OLAWebView.h"

@implementation OLALayout

/*
-  (OLALayout *) createLayout:(OLAView *)parentView  withXMLText:(NSString * ) xml
{
    NSData * xmlData= [xml dataUsingEncoding:NSUTF8StringEncoding];
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:xmlData];
    XMLDocument *parser = [[XMLDocument alloc] initXMLParser];
    [xmlParser setDelegate:parser];
    [xmlParser parse];
    
    XMLElement * root= parser.root;
    
    NSString * name=root.tagName;
    NSString * layoutName=[root.attributes objectForKey:@"layout"];
    OLALayout * v=nil;
    
    if([layoutName caseInsensitiveCompare:@"FrameLayout"]==NSOrderedSame)
    {
        v=[[OLAFrameLayout alloc] initWithParent:parentView andUIRoot:root];
    }
    else if([layoutName caseInsensitiveCompare:@"LinearLayout"]==NSOrderedSame)
    {
        v=[[OLALinearLayout alloc] initWithParent:parentView andUIRoot:root];
    }
    else if([layoutName caseInsensitiveCompare:@"RelativeLayout"]==NSOrderedSame)
    {
        v=[[OLARelativeLayout alloc] initWithParent:parentView andUIRoot:root];
        
    }

    
    return v;
}
*/
- (void) _clicked:(UITapGestureRecognizer*)recognizer
{
    NSLog(@"layout.view=%@,clicked=%@",[v class],onclick);

}

- (void) _pressed:(UILongPressGestureRecognizer *)recognizer
{
    if (recognizer.state ==
        UIGestureRecognizerStateBegan) {
        NSLog(@"layout.UIGestureRecognizerStateBegan,view class=%@",[v class]);
    }
    if (recognizer.state ==
        UIGestureRecognizerStateChanged) {
        NSLog(@"layout.UIGestureRecognizerStateChanged");
        //draged
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"layout.UIGestureRecognizerStateEnded");
        [self released];
    }

}

- (void) _released:(UITapGestureRecognizer*)recognizer
{
    NSLog(@"layout.released=%@",released);

}
- (void) _addListner
{

        UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clicked:)];
        tapGesture.delegate = self;
        
        
        //[v addGestureRecognizer:tapGesture];

    

        UILongPressGestureRecognizer *longPressReger1 = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(pressed:)];
        longPressReger1.minimumPressDuration = 1;
        longPressReger1.delegate =  self;
        //[longPressReger1 requireGestureRecognizerToFail:tapGesture];
        [v addGestureRecognizer:longPressReger1];

    
    /*
     // 双击的 Recognizer
     UITapGestureRecognizer* double;
     doubleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:selfaction:@selector(DoubleTap：)];
     doubleTapRecognizer.numberOfTapsRequired = 2; // 双击
     //关键语句，给self.view添加一个手势监测；
     [self.view addGestureRecognizer:doubleRecognizer];
     
     // 关键在这一行，双击手势确定监测失败才会触发单击手势的相应操作
     [singleRecognizer requireGestureRecognizerToFail:doubleRecognizer];
     
    
    UISwipeGestureRecognizer *recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    
    [v addGestureRecognizer:recognizer];
     */
    
    
}

@end
