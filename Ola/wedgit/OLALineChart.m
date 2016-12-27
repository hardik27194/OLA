//
//  OLALineChart.m
//  Ola
//
//  Created by lohool on 10/26/16.
//  Copyright (c) 2016 Terrence Xing. All rights reserved.
//

#import "OLALineChart.h"
#import "CorePlot-CocoaTouch.h"
#import "NSString+StringForJava.h"

#define num 20

@implementation OLALineChart
{
    //CPTXYGraph * graph;
    NSMutableArray *xValues;
    NSMutableDictionary *yValues;
    NSMutableArray *labels;
    
    double minXValue;
    double maxXValue;
    double minYValue;
    double maxYValue;
    int coordCount;
    //double x[num];
    //double y1[num];
    //double y2[num];
    CPTGraphHostingView* hostView;
}

- (id) init
{
    self=[super init];
    
    xValues=[[NSMutableArray alloc]init];
    yValues=[[NSMutableDictionary alloc]init];

    hostView = [[ CPTGraphHostingView alloc ]initWithFrame :CGRectMake(10, 10, 250, 250)];
    minYValue=DBL_MAX;
    maxYValue=0;
    
    super.v=hostView;

    
    [self configureHost];
    [self configureGraph];
    //[self configurePlots];
    //[self configureAxes];
    //[view addSubview:hostView];
    //[self draw];
    
    [self setXValue:@"A,B,C,D,E"];
    [self addYValue:@"2,2.5,4.4,5.1,7" withLabel:@"Test1"];
    [self addYValue:@"1,3.5,6,4,2" withLabel:@"Test2"];
    [self addYValue:@"5,6,7,8,9" withLabel:@"Test3"];
    [self show];
    return self;
    
}

- (id) initWithParent:(OLAView *)parentView withXMLElement:(XMLElement *) rootEle andUIFactory:(OLAUIFactory *)uiFactory
{
    self=[super initWithParent:parentView withXMLElement:rootEle andUIFactory:uiFactory];
    NSString* defaultStyle=@"background-color:#cccccc;";
    
    super.defaultCSSStyle=defaultStyle;
    
    xValues=[[NSMutableArray alloc]init];
    yValues=[[NSMutableDictionary alloc]init];
    
    //font = [UIFont fontWithName:@"Arial" size:12];

    //graph = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    

    UIView *view=[[UIView alloc]initWithFrame:CGRectZero];
    
    CPTTheme *theme = [CPTTheme themeNamed:kCPTPlainWhiteTheme];
    
    
    
     hostView = [[ CPTGraphHostingView alloc ]initWithFrame :view.frame];
    
    //[hostView setHostedGraph:graph];

    //graph.plotAreaFrame.borderLineStyle = nil;
    //graph.plotAreaFrame.cornerRadius = 0.0f;
    minYValue=DBL_MAX;
    maxYValue=0;
    
    super.v=hostView;
    
    [super initiate];
    
    [self configureHost];
    [self configureGraph];
    //[self configurePlots];
    //[self configureAxes];
    //[view addSubview:hostView];
    //[self draw];
    
    /*
    [self setXValue:@"A,B,C,D,E"];
    [self addYValue:@"2,2.5,4.4,5.1,7" withlabel:@"Test1"];
    [self addYValue:@"1,3.5,6,4,2" withlabel:@"Test2"];
    [self addYValue:@"Test3:5,6,7,8,9"];
    [self show];
     */
    return self;

}


- (void) setXValue:(NSString*) xValue
{
    NSArray *xv= [xValue split:@","];
    [xValues addObjectsFromArray:xv];
    coordCount=[xv count];
        /*
 
        CPTGraph *graph = hostView.hostedGraph;
        //CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
        
        CPTMutableLineStyle *lineStyle=[CPTMutableLineStyle lineStyle];
        CPTXYAxisSet *axisSet=(CPTXYAxisSet *)graph.axisSet;
        lineStyle.miterLimit=1.0f;
        lineStyle.lineWidth=0.5f;
        lineStyle.lineColor=[CPTColor blueColor];
    
        //NSMutableArray *labelArray=[NSMutableArray arrayWithCapacity:288];
    
    */

    
    
}

-(void)clear
{

    [xValues removeAllObjects];
    coordCount=0;
    [yValues removeAllObjects];
}

-(void) show
{
    CPTGraph *graph = hostView.hostedGraph;
    double interval=(maxYValue-minYValue)/10;
    //CPTGraph *graph = hostView.hostedGraph;
    //CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
    
    CPTMutableLineStyle *lineStyle=[CPTMutableLineStyle lineStyle];
    CPTXYAxisSet *axisSet=(CPTXYAxisSet *)graph.axisSet;
    lineStyle.miterLimit=1.0f;
    lineStyle.lineWidth=0.5f;
    lineStyle.lineColor=[CPTColor blueColor];
    
    
    
    
    //X axis
    CPTXYAxis *x=axisSet.xAxis;
    x.title=@"X Axis";
    x.labelingPolicy=CPTAxisLabelingPolicyNone;// set x axis label mauanlly
    
    NSMutableArray *xlbls=[[NSMutableArray alloc]init];
    int i=0;
    for(NSString * s in xValues)
    {
        CPTAxisLabel *newLabel =[[CPTAxisLabel alloc] initWithText:s textStyle:x.labelTextStyle];
        newLabel.tickLocation=[[NSNumber numberWithInt:i++] decimalValue];
        newLabel.offset=x.labelOffset+x.majorTickLength;
        [xlbls addObject:newLabel];
    }
    
    x.axisLabels=[NSSet setWithArray:xlbls];
    
    x.orthogonalCoordinateDecimal=CPTDecimalFromDouble(minYValue);//x origional coord
    x.majorIntervalLength=CPTDecimalFromDouble(1.0f);
    
    x.minorTicksPerInterval=0;// x sub corrd betwen 2 major coords
    x.minorTickLineStyle=lineStyle;

    //fix X axis's position, range is from 0 to 1, 0 is bottom, 1 is top of the chart
    x.axisConstraints = [CPTConstraints constraintWithRelativeOffset:0.1];
    
    CPTXYAxis *y=axisSet.yAxis;
    //y.title=@"Y Axis";
    
    //y.labelingPolicy= CPTAxisLabelingPolicyNone;// set x axis label mauanlly
    /*
    NSMutableArray *ylbls=[[NSMutableArray alloc]init];
    i=1;
    for(NSString * s in labels)
    {
        CPTAxisLabel *newLabel =[[CPTAxisLabel alloc] initWithText:s textStyle:y.labelTextStyle];
        newLabel.tickLocation=[[NSNumber numberWithInt:i++] decimalValue];
        newLabel.offset=y.labelOffset+y.majorTickLength;
        [ylbls addObject:newLabel];
    }
    
    y.axisLabels=[NSSet setWithArray:ylbls];
    */
    y.orthogonalCoordinateDecimal=CPTDecimalFromDouble(0);//x origional coord
    y.majorIntervalLength=CPTDecimalFromDouble(interval);
    
    y.minorTicksPerInterval=0;// x sub corrd betwen 2 major coords
    y.minorTickLineStyle=lineStyle;
    y.axisConstraints = [CPTConstraints constraintWithRelativeOffset:-0.1];
    
    //CPTLineStyle * gridLineStyle=[CPTLineStyle lineStyle];
    //gridLineStyle.lineColor=[CPTColor grayColor];
    
    CPTMutableLineStyle *gridLLineStyle=[CPTMutableLineStyle lineStyle];

    gridLLineStyle.miterLimit=1.0f;
    gridLLineStyle.lineWidth=0.5f;
    gridLLineStyle.lineColor=[CPTColor lightGrayColor];
    gridLLineStyle.dashPattern=@[@5.0f, @5.0f];
    //y.tickDirection=CPTSignNegative;
    y.majorGridLineStyle=gridLLineStyle;
    
    
    
    //X,Y coord range
	CPTXYPlotSpace *plotSpace=(CPTXYPlotSpace *)graph.defaultPlotSpace;
    plotSpace.xRange=[CPTPlotRange plotRangeWithLocation:CPTDecimalFromCGFloat(-0.5)
                                                   length:CPTDecimalFromCGFloat(coordCount)];
	plotSpace.yRange=[CPTPlotRange plotRangeWithLocation:CPTDecimalFromCGFloat(minYValue-interval*4)
												  length:CPTDecimalFromCGFloat(maxYValue+interval*8)];
    

    
    
    
    
    //Y data legend lables
    
    CPTLegend *theLegend = [CPTLegend legendWithGraph:graph];
    //theLegend.fill = [CPTFill fillWithColor:[CPTColor whiteColor]];
    
    //theLegend.borderLineStyle = lineStyle;
    
   //theLegend.cornerRadius = 10.0;
    
    theLegend.swatchSize = CGSizeMake(16.0, 16.0);
    
    CPTMutableTextStyle *whiteTextStyle = [CPTMutableTextStyle textStyle];
    
    whiteTextStyle.color = [CPTColor blueColor];
    
    whiteTextStyle.fontSize = 12.0;
    
    theLegend.textStyle = whiteTextStyle;
    
    theLegend.rowMargin = 10.0;
    
    theLegend.numberOfRows = 1;
    //theLegend.numberOfColumns=1;
    
    theLegend.paddingLeft = 12.0;
    theLegend.paddingTop = 12.0;
    
    theLegend.paddingRight = 12.0;
    theLegend.paddingBottom = 12.0;
    
    graph.legend = theLegend;
    graph.legendAnchor =CPTRectAnchorTopRight;// CPTRectAnchorBottom;
    
    int right=hostView.frame.origin.x+hostView.frame.size.width;
    
    graph.legendDisplacement = CGPointMake(0, 5.0);
    
    
    
    
    [graph reloadData];
}

/**
 value format: @"Test3:5,6,7,8,9"
 first frag is the Y label
 the second frag is the value string, seprated by comma
 */
-(void) addYValue:(NSString*) yValue
{
    NSArray* strs =[yValue split:@":"];
    NSString* label=[strs objectAtIndex:0];
    NSString* values=[strs objectAtIndex:1];
    [self addYValue:values withLabel:label];
}

/**
 for lua, in lua, it is: add_yValue("Label","values")
 
-(void) add:(NSString*) label  yValue:(NSString*)  yValue
{
    [self addYValue:yValue withLabel:label];
    
}
-(void) addY:(NSString*) yValue  label:(NSString*) label
{
    [self addYValue:yValue withLabel:label];
    
}
*/
-(void) addYValue:(NSString*) yValue  withLabel:(NSString*)  label

{
    NSArray* yv =[yValue split:@","];
    //double yvd[[yv count]];
    NSMutableArray *yvd=[[NSMutableArray alloc]init];
    //int i=0;
    for(NSString* s in yv)
    {
        double nv=[s doubleValue];
        NSNumber *n= [NSNumber numberWithDouble:nv];

        {
            
            if(nv<minYValue)  minYValue=nv;
            if(nv>maxYValue)maxYValue=nv;
            
        }
        [yvd addObject:n];

    }
    
    
    
    [yValues setValue:yvd forKey:label];
    
    
    
    CPTGraph *graph = hostView.hostedGraph;
	CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
    
    CPTColor *lineColor=[CPTColor colorWithComponentRed:rand()*255 green:rand()*255 blue:rand()*255 alpha:1];
    
    CPTMutableLineStyle *lineStyle=[CPTMutableLineStyle lineStyle];
	//CPTXYAxisSet *axisSet=(CPTXYAxisSet *)graph.axisSet;
	lineStyle.miterLimit=1.0f;
	lineStyle.lineWidth=0.5f;
	lineStyle.lineColor=lineColor;
    
    //CPTXYAxis *y=axisSet.yAxis;
    //CPTAxisLabel *newLabel =[[CPTAxisLabel alloc] initWithText:label textStyle:y.labelTextStyle];
    //newLabel.tickLocation=[[NSNumber numberWithInt:i++] decimalValue];
    //newLabel.offset=y.labelOffset+y.majorTickLength;
    //[ylbls addObject:newLabel];
    
    [labels addObject:label];
    
    
    
    
    
    
    CPTScatterPlot * scatterPlot  = [[CPTScatterPlot alloc] init];
	scatterPlot.dataLineStyle = lineStyle;
	scatterPlot.identifier	= label;
	scatterPlot.dataSource	= self;   //…Ë÷√ ˝æ›‘¥
    scatterPlot.labelOffset = 15;
    
    CPTMutableTextStyle *labelTextStyle = [[CPTMutableTextStyle alloc] init];
    
    labelTextStyle.color = lineColor;
    
    scatterPlot.labelTextStyle = labelTextStyle;
    scatterPlot.labelOffset=2.0f;
    
    
    //peak point(plot) style---- a blue point
    CPTPlotSymbol *plotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    plotSymbol.fill          = [CPTFill fillWithColor:lineColor];
    plotSymbol.lineStyle     = lineStyle;
    plotSymbol.size          = CGSizeMake(5.0f, 5.0f);
    scatterPlot.plotSymbol=plotSymbol;
    
    
    
    
	[graph addPlot:scatterPlot toPlotSpace:plotSpace];
    
    
}

-(void)configureHost
{
    //self.hostView=[(CPTGraphHostingView *)[CPTGraphHostingViewalloc]initWithFrame:CGRectMake(0,10,self.view.bounds.size.width-10,self.view.bounds.size.height/2)];
    hostView.allowPinchScaling=YES;
    //[self.viewaddSubview:self.hostView];
}
-(void)configureGraph
{
    
    //create an CPXYGraph and host it inside the view
	CPTTheme *theme=[CPTTheme themeNamed:kCPTPlainWhiteTheme];
	CPTXYGraph *graph;//=(CPTXYGraph *)[theme newGraph];
    graph = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
	graph.paddingLeft=15.0;
	graph.paddingTop=15.0;
	graph.paddingRight=15.0;
	graph.paddingBottom=0.0;
	[hostView setHostedGraph:graph];
    
	CPTXYPlotSpace *plotSpace2=(CPTXYPlotSpace *)graph.defaultPlotSpace;
	//“ª∆¡ƒ⁄ø…œ‘ æµƒx£¨y∑ΩœÚµƒ¡ø∂»∑∂Œß
	//plotSpace2.xRange=[CPTPlotRange plotRangeWithLocation:CPTDecimalFromCGFloat(0)length:CPTDecimalFromCGFloat(6.0)];
	//plotSpace2.yRange=[CPTPlotRange plotRangeWithLocation:CPTDecimalFromCGFloat(0)length:CPTDecimalFromCGFloat(10.0)];
    
	plotSpace2.allowsUserInteraction=YES;
    
}

-(void)configurePlots

{
    // 1 - Get graph and plot space
	CPTGraph *graph = hostView.hostedGraph;
	CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
    
	//2:¥¥Ω®œﬂ–‘
	CPTMutableLineStyle *lineStyle=[CPTMutableLineStyle lineStyle];
	lineStyle.miterLimit		= 1.0f;
	lineStyle.lineWidth		 = 3.0f;
	lineStyle.lineColor		 = [CPTColor blueColor];
    
	//3.…Ë÷√ ˝æ›µ„
    
    
	CPTScatterPlot * lowScatterPlot  = [[CPTScatterPlot alloc] init];
	lowScatterPlot.dataLineStyle = lineStyle;
	lowScatterPlot.identifier	= @"LOWER";
	lowScatterPlot.dataSource	= self;   //…Ë÷√ ˝æ›‘¥
	[graph addPlot:lowScatterPlot toPlotSpace:plotSpace];
    
    //....
	CPTScatterPlot * highScatterPlot  = [[CPTScatterPlot alloc] init];
	highScatterPlot.dataLineStyle = lineStyle;
	highScatterPlot.identifier	= @"HIGH";
	highScatterPlot.dataSource	= self;
	[graph addPlot:highScatterPlot toPlotSpace:plotSpace];
    
    
	//4.…Ë÷√œ‘ æ«¯”Ú£¨ª¨∂ØµΩ ˝æ›µ„¥¶
    
	//[plotSpace scaleToFitPlots:[NSArray arrayWithObjects:lowScatterPlot,highScatterPlot, nil]];
	CPTMutablePlotRange *xRange = [plotSpace.xRange mutableCopy];
	[xRange expandRangeByFactor:CPTDecimalFromCGFloat(1.1f)];
	plotSpace.xRange = xRange;
	CPTMutablePlotRange *yRange = [plotSpace.yRange mutableCopy];
	[yRange expandRangeByFactor:CPTDecimalFromCGFloat(1.2f)];
	plotSpace.yRange = yRange;
    
    
	//5.…Ë÷√’€œﬂ
	CPTMutableLineStyle *lowLineStyle = [lowScatterPlot.dataLineStyle mutableCopy];
	lowLineStyle.lineWidth = 2.0f;  //’€œﬂøÌ∂»
	lowLineStyle.lineColor = [CPTColor blueColor]; //’€œﬂ—’…´
	lowScatterPlot.dataLineStyle = lowLineStyle; //…Ë÷√ ˝æ›œﬂ—˘ Ω
	CPTMutableLineStyle *lowSymbolLineStyle = [CPTMutableLineStyle lineStyle];
	lowSymbolLineStyle.lineColor = [CPTColor blueColor];
	//...
	CPTMutableLineStyle *highLineStyle = [lowScatterPlot.dataLineStyle mutableCopy];
	highLineStyle.lineWidth = 2.0f;  //’€œﬂøÌ∂»
	highLineStyle.lineColor = [CPTColor redColor]; //’€œﬂ—’…´
	highScatterPlot.dataLineStyle = highLineStyle; //…Ë÷√ ˝æ›œﬂ—˘ Ω
	CPTMutableLineStyle *highSymbolLineStyle = [CPTMutableLineStyle lineStyle];
	highSymbolLineStyle.lineColor = [CPTColor redColor];
    
	//6.…Ë÷√π’µ„
	CPTPlotSymbol *lowSymbol = [CPTPlotSymbol ellipsePlotSymbol];
	lowSymbol.fill = [CPTFill fillWithColor:[CPTColor blueColor]];
	lowSymbol.lineStyle = lowSymbolLineStyle;
	lowSymbol.size = CGSizeMake(6.0f, 6.0f); //π’µ„¥Û–°
	lowScatterPlot.plotSymbol = lowSymbol;
    
	CPTPlotSymbol *highSymbol = [CPTPlotSymbol ellipsePlotSymbol];
	highSymbol.fill = [CPTFill fillWithColor:[CPTColor redColor]];
	highSymbol.lineStyle = highSymbolLineStyle;
	highSymbol.size = CGSizeMake(6.0f, 6.0f); //π’µ„¥Û–°
	highScatterPlot.plotSymbol = highSymbol;
    
}


-(void)configureAxes
{
    CPTGraph *graph=hostView.hostedGraph;
    
	//1:¥¥Ω®œﬂ–‘
	CPTMutableLineStyle *lineStyle=[CPTMutableLineStyle lineStyle];
	//axes …Ë÷√x,y÷· Ù–‘£¨»Á‘≠µ„°£
	//µ√µΩx£¨y÷·µƒºØ∫œ
	CPTXYAxisSet *axisSet=(CPTXYAxisSet *)graph.axisSet;
	lineStyle.miterLimit=1.0f;
	lineStyle.lineWidth=0.5f;
	lineStyle.lineColor=[CPTColor blueColor];
    
	//X axis
	CPTXYAxis *x=axisSet.xAxis;
	x.orthogonalCoordinateDecimal=CPTDecimalFromString(@"0");//‘≠µ„Œ™0.(y=0£©
	x.majorIntervalLength=CPTDecimalFromString(@"1");// x÷·÷˜øÃ∂»£∫œ‘ æ ˝◊÷±Í«©µƒ¡ø∂»º‰∏Ù
    
	x.minorTicksPerInterval=0;// x÷·œ∏∑÷øÃ∂»£∫√ø“ª∏ˆ÷˜øÃ∂»∑∂Œßƒ⁄œ‘ æœ∏∑÷øÃ∂»µƒ∏ˆ ˝
	x.minorTickLineStyle=lineStyle;
    
	//Y axis
	CPTXYAxis *y=axisSet.yAxis;
    
	y.orthogonalCoordinateDecimal=CPTDecimalFromString(@"0");
	y.majorIntervalLength=CPTDecimalFromString(@"1");
	y.minorTicksPerInterval=0;
	y.minorTickLineStyle=lineStyle;
    
    
}

#pragma mark - CPTPlotDataSource methods
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
	return coordCount; // ˝æ›µ„∏ˆ ˝
}
static int a=0;
-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
	
	switch (fieldEnum) {
		case CPTScatterPlotFieldX:
			if (a>=coordCount) {
				a=0;
			}
            return [NSNumber numberWithInt:a++];
			break;
			
		case CPTScatterPlotFieldY:
        {
           // yValues objectForKey:plot.
            
            NSString * ylbl=(NSString *)(plot.identifier);
            NSMutableArray* yvs=(NSMutableArray*)[yValues  objectForKey:ylbl];
            
            return [yvs objectAtIndex:index];
             
            //return [NSNumber numberWithInt:arc4random()%8];
            /*
			if ([plot.identifier isEqual:@"LOWER"] == YES) {
				return [NSNumber numberWithInt:arc4random()%8+10];
			}else if([plot.identifier isEqual:@"HIGH"] == YES){
				return [NSNumber numberWithInt:arc4random()%8+13];
			}
             */
            break;
        }
			
	}
	return [NSDecimalNumber zero];
}

#pragma mark 

- (CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)idx

{
    
    NSString * ylbl=(NSString *)(plot.identifier);
    NSMutableArray* yvs=(NSMutableArray*)[yValues  objectForKey:ylbl];
    
    NSNumber* value=(NSNumber*)[yvs objectAtIndex:idx];
    CPTMutableTextStyle *labelTextStyle = [[CPTMutableTextStyle alloc] init];
    
    labelTextStyle.color = [CPTColor magentaColor];
    
    CPTTextLayer *newLayer = [[CPTTextLayer alloc] initWithText:[NSString stringWithFormat:@"%.2f",value.doubleValue] style:labelTextStyle];
    
    
    
    return newLayer;
}

/*

-(NSUInteger)numberOfLegendEntries
{
    return 3;
}
-(NSString *)titleForLegendEntryAtIndex:(NSUInteger)idx
{
    return @"AAA";
}
*/

/*
-(CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)idx
{
    NSString* lbl=(NSString*)[labels  objectAtIndex:idx];
    
    
    CPTTextLayer *label = [[CPTTextLayer alloc] initWithText:lbl];
    
    CPTMutableTextStyle *textStyle=[label.textStyle mutableCopy];
    
    textStyle.color = [CPTColor lightGrayColor];
    
    label.textStyle = textStyle;
    
    
    return label ;
}

*/







//------------------------------------

/*
-(void) draw
{
    
    
    
    CPTXYPlotSpace *plotSpace= (CPTXYPlotSpace *)graph.defaultPlotSpace;
    
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(200.0f)];
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromInt(num)];
    graph.paddingLeft = 0.0f;
    graph.paddingRight = 0.0f;
    graph.paddingTop = 0.0f;
    graph.paddingBottom = 0.0f;
    
    graph.plotAreaFrame.paddingLeft = 45.0;
    graph.plotAreaFrame.paddingTop = 40.0;
    graph.plotAreaFrame.paddingRight = 5.0;
    graph.plotAreaFrame.paddingBottom = 80.0;
    
    CPTXYAxisSet *axisSet =(CPTXYAxisSet *)graph.axisSet;
    CPTXYAxis *X =axisSet.xAxis;
    X.labelingPolicy =CPTAxisLabelingPolicyNone;
    NSMutableArray*customLabels = [NSMutableArray arrayWithCapacity:num];
    
    static CPTTextStyle*labelTextStyle=nil;
    labelTextStyle=[[CPTTextStyle alloc]init];
    //labelTextStyle.color=[CPTColor whiteColor];
    //labelTextStyle.fontSize=10.0f;
    
    for (int i=0;i<num;i++) {
        CPTAxisLabel *newLabel =[[CPTAxisLabel alloc] initWithText: [NSString stringWithFormat:@"point %d",(i+1)] textStyle:labelTextStyle];
        newLabel.tickLocation = CPTDecimalFromInt(i);
        newLabel.offset = X.labelOffset + X.majorTickLength;
        newLabel.rotation = M_PI/2;
        //[customLabelsaddObject:newLabel];
        //[newLabelrelease];
    }
    X.axisLabels =  [NSSet setWithArray:customLabels];
    
    CPTXYAxis *y =axisSet.yAxis;
    
    y.minorTickLineStyle = nil;
    
    y.majorIntervalLength = CPTDecimalFromString(@"50");
    y.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0");
    y.titleOffset = 45.0f;
    y.titleLocation = CPTDecimalFromFloat(150.0f);
    
    
    CPTScatterPlot*boundLinePlot = [[CPTScatterPlot alloc] init] ;
    
    boundLinePlot.identifier = @"BluePlot";
    
    CPTLineStyle* lineStyle= [[CPTLineStyle alloc]init] ;

    //lineStyle.lineWidth = 1.0f;
    //lineStyle.lineColor = [CPTColor blueColor];
    boundLinePlot.dataLineStyle =lineStyle;
    
    boundLinePlot.dataSource = self;
    [graph addPlot:boundLinePlot];
    
    
    CPTLineStyle*symbolLineStyle = [[CPTLineStyle alloc ]init];
    
    //symbolLineStyle.lineColor = [CPTColor blackColor];
    
    CPTPlotSymbol *plotSymbol= [CPTPlotSymbol ellipsePlotSymbol];
    
    plotSymbol.fill = [CPTFill fillWithColor:[CPTColor blueColor]];
    
    plotSymbol.lineStyle =symbolLineStyle;
    
    plotSymbol.size = CGSizeMake(6.0, 6.0);
    
    boundLinePlot.plotSymbol =plotSymbol;
    
    
    
    CPTColor *areaColor= [CPTColor colorWithComponentRed:0.0 green:0.0 blue:1.0 alpha:1.0];
    
    CPTGradient*areaGradient = [CPTGradient gradientWithBeginningColor:areaColor endingColor:[CPTColor clearColor]];
    
    areaGradient.angle = -90.0f;
    
    CPTFill*areaGradientFill = [CPTFill fillWithGradient:areaGradient];
    
    boundLinePlot.areaFill =areaGradientFill;
    
    boundLinePlot.areaBaseValue = CPTDecimalFromString(@"0.0");
    
    
    
    
    
    
    boundLinePlot.interpolation = CPTScatterPlotInterpolationHistogram;
    
    
    
    CPTScatterPlot*dataSourceLinePlot = [[CPTScatterPlot alloc] init] ;
    dataSourceLinePlot.identifier = @"GreenPlot";
    
    lineStyle = [[CPTLineStyle alloc]init] ;
    //lineStyle.lineWidth = 1.0f;
    //lineStyle.lineColor = [CPTColor greenColor];
    dataSourceLinePlot.dataLineStyle =lineStyle;
    
    dataSourceLinePlot.dataSource = self;
    [graph addPlot:dataSourceLinePlot];
    
    NSUInteger i;
    for ( i = 0; i < num; i++ ) {
        x[i] = i ;
        y1[i] = (num*10)*(rand()/(float)RAND_MAX);
        y2[i] = (num*10)*(rand()/(float)RAND_MAX);
    }    

    }



-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return num ;
}

- (double*)doublesForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndexRange:(NSRange)indexRange
{
    double *values;
    NSString*identifier=(NSString*)[plot identifier];
    
    switch (fieldEnum){
            
        case CPTScatterPlotFieldX:
            values=x;
            break;
        case CPTScatterPlotFieldY:
            
            if([identifier isEqualToString:@"BluePlot"]) {
                values=y1;
            }else
                values=y2;
            break;
    }
    return values +indexRange.location ;
}
-(CPTLayer*)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)index
{
    static CPTTextStyle *whiteText= nil;
    if (!whiteText ) {
        whiteText= [[CPTTextStyle alloc] init];
        //whiteText.color = [CPTColor whiteColor];
    }
    CPTTextLayer *newLayer =nil;
    NSString*identifier=(NSString*)[plot identifier];
    if([identifier isEqualToString:@"BluePlot"]) {
        newLayer= [[CPTTextLayer alloc] initWithText:[NSString stringWithFormat:@"%.0f", y1[index]] style:whiteText] ;
    }
    return newLayer;
}
*/
@end
