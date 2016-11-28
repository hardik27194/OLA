//
//  ImgRotationView.h
//  Ola
//
//  Created by lohool on 10/21/16.
//  Copyright (c) 2016 Terrence Xing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImgRotationView : UIView
{
    //NSString *imgUrl;
    UIImage *img;
    

    @private NSString * lock;
    
}

@property (nonatomic) UIImage *img;


-(void) setImage:(UIImage *)img;
-(void)start;
-(void)stop;
@end
