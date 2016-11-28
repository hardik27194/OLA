//
//  OLAViewController.h
//  Ola
//
//  Created by Terrence Xing on 3/19/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OLAView.h"
#import "CorePlot-CocoaTouch.h"

@interface OLAViewController : UIViewController<UIScrollViewDelegate,CPTPlotDataSource>
{
    OLAViewController * viewController;
    OLAView * bodyView;
}

@property (nonatomic, retain)OLAViewController * viewController;
@property (nonatomic)OLAView * bodyView;

- (OLAViewController * ) getViewController;

@end
