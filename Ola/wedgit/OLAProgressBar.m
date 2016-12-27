//
//  OLAProgressBar.m
//  Ola
//
//  Created by Terrence Xing on 4/24/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#import "OLAProgressBar.h"
#import "ProgressBar.h"
#import "ImgRotationView.h"
#import "OLAThreeDotsView.h"

@implementation OLAProgressBar




- (id) initWithParent:(OLAView *)parentView withXMLElement:(XMLElement *) rootEle andUIFactory:(OLAUIFactory *)uiFactory
{
    self=[super initWithParent:parentView withXMLElement:rootEle andUIFactory:uiFactory];
    
    [super parseAttribute];
    [super parseCSS];

    UIView *view= NULL;
    NSString *attr=[css getStyleValue:@"type"];
    NSLog(@"draw progrssbar:type=%@",attr);
     if (attr!=NULL && [attr caseInsensitiveCompare:@"rotate"]==NSOrderedSame)
     {
         NSLog(@"draw progrssbar:%@",@"rotate");
         
         ImgRotationView *iview=[[ImgRotationView alloc]init];
         
         //[iview start];
         
         /*
        OLAThreeDotsView * iview = [[OLAThreeDotsView alloc] initWithView:parentView.v blur:NO];
         // Start
         [iview showWhileExecutingBlock:^{
             sleep(6);
         } completion:^{
             //[self.navigationController popToRootViewControllerAnimated:YES];
         }];
         */
         
         view=iview;
     }
    else
    {
        NSLog(@"draw progrssbar:%@",@"bar");
        view=[[ProgressBar alloc]init];
    }

    //bar.progressTintColor = [UIColor blueColor];
    //bar.trackTintColor=[UIColor grayColor];
    
    //bar.progress=10;
    //CGAffineTransform transform =CGAffineTransformMakeScale(10.0f,15.0f);
    
    //bar.transform = transform;
    
    super.v=view;
    //
    //[super initiate];
    [super parseCSS];
    [super addListner];
    
    [self parseMyAttribute];
    return self;
}
-(void)start
{
    ImgRotationView *view=(ImgRotationView *)v;
    [view start];
}
-(void)stop
{
    ImgRotationView *view=(ImgRotationView *)v;
    [view stop];
}

- (void) parseMyAttribute
{
    //ProgressBar progressBar=(ProgressBar)v;
    //		System.out.println("indeterminate="+css.getStyleValue("indeterminate"));
    //		System.out.println("indeterminateOnly="+css.getStyleValue("indeterminateOnly"));
    //		System.out.println("style="+css.getStyleValue("style"));
    //		System.out.println("value="+css.getStyleValue("value"));
    
    NSString *attr;

    if ((attr=[css getStyleValue:@"indeterminate"])!=nil)
    {
        //setIndeterminate(Boolean.parseBoolean(attr));
    }
    if ((attr=[css getStyleValue:@"indeterminateOnly"])!=nil)
    {
        //setIndeterminate(Boolean.parseBoolean(attr));
    }
    if ((attr=[css getStyleValue:@"style"])!=nil)
    {
        //setStyle(attr);
    }
    if ((attr=[css getStyleValue:@"value"])!=nil)
    {
        [self setValue:[attr floatValue]];
    }
}
- (void) setValue:(float) value
{
    //NSLog(@"progress value=%f",value);
    ProgressBar *progressBar=(ProgressBar *)v;
    [progressBar setProgress:value];
    
}

@end
