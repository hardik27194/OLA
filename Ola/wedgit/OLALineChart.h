//
//  OLALineChart.h
//  Ola
//
//  Created by lohool on 10/26/16.
//  Copyright (c) 2016 Terrence Xing. All rights reserved.
//

#import "OLAWedgit.h"
#import "CorePlot-CocoaTouch.h"

@interface OLALineChart : OLAWedgit<CPTPlotDataSource>


-(void) addYValue:(NSString*) yValue  withLabel:(NSString*)  label;
-(void) show;
-(void)clear;
- (void) setXValue:(NSString*) xValue;

@end
