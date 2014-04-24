//
//  ProgressBar.h
//  Ola
//
//  Created by Terrence Xing on 4/24/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#import "IView.h"

@interface ProgressBar : IView
{
    float max;
    float progress ;
	UIColor *progressColor ;
	UIColor *trackColor ;
    UIColor *borderColor;
@private
    float progressPercent;
}
@property (nonatomic) float max;
@property (nonatomic, assign) float progress;
@property (nonatomic)float progressPercent;
@end
