//
//  OLAProgressBar.m
//  Ola
//
//  Created by Terrence Xing on 4/24/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#import "OLAProgressBar.h"
#import "ProgressBar.h"

@implementation OLAProgressBar




- (id) initWithParent:(OLAView *)parentView withXMLElement:(XMLElement *) rootEle
{
    self=[super initWithParent:parentView withXMLElement:rootEle];
    
    ProgressBar *bar= [[ProgressBar alloc]init];

    //bar.progressTintColor = [UIColor blueColor];
    //bar.trackTintColor=[UIColor grayColor];
    
    //bar.progress=10;
    //CGAffineTransform transform =CGAffineTransformMakeScale(10.0f,15.0f);
    
    //bar.transform = transform;
    
    super.v=bar;
    
    [super initiate];
    [self parseMyAttribute];
    return self;
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
    NSLog(@"progress value=%f",value);
    ProgressBar *progressBar=(ProgressBar *)v;
    [progressBar setProgress:value];
    
}

@end
