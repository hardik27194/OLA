//
//  OLARoundImage.m
//  Ola
//
//  Created by Terrence Xing on 3/1/16.
//  Copyright (c) 2016 Terrence Xing. All rights reserved.
//

#import "OLARoundImage.h"

@implementation OLARoundImage

- (id) initWithParent:(OLAView *)parentView withXMLElement:(XMLElement *) rootEle
{
    self=[super initWithParent:parentView withXMLElement:rootEle];
    
    int imgW=60;
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, imgW, imgW)];
    
    super.v=img;
    [super initiate];
    //[self parseAlignment];
    return self;
}
- (void) setImageUrl:(NSString *) backgroundImageUrl
{

    UIImageView *img0 = (UIImageView *)(self.v);
    
    //UIImageView *imgMian = [[UIImageView alloc] initWithFrame:CGRectMake(95, 95, imgW+10, imgW+10)];
    //[imgMian setImage:[UIImage imageNamed:@"bg_circle.png"]]; //圆形的背景图
    //[self.view addSubview:imgMian];
    
    UIImage *main = [UIImage imageNamed:backgroundImageUrl];  //被圆环化的图片
    //UIImageView *img0 = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, imgW, imgW)];
    img0.image = main;
    img0.layer.masksToBounds = YES;
    img0.layer.cornerRadius = img0.frame.size.height/2;

}
@end
