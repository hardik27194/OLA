#import "CPTAxis.h"

#import "CPTAxisLabel.h"
#import "CPTAxisLabelGroup.h"
#import "CPTAxisSet.h"
#import "CPTAxisTitle.h"
#import "CPTColor.h"
#import "CPTExceptions.h"
#import "CPTFill.h"
#import "CPTGradient.h"
#import "CPTGridLineGroup.h"
#import "CPTGridLines.h"
#import "CPTImage.h"
#import "CPTLimitBand.h"
#import "CPTLineCap.h"
#import "CPTLineStyle.h"
#import "CPTMutablePlotRange.h"
#import "CPTPlotArea.h"
#import "CPTPlotSpace.h"
#import "CPTShadow.h"
#import "CPTTextLayer.h"
#import "CPTUtilities.h"
#import "NSCoderExtensions.h"

/** @defgroup axisAnimation Axes
 *  @brief Axis properties that can be animated using Core Animation.
 *  @if MacOnly
 *  @since Custom layer property animation is supported on MacOS 10.6 and later.
 *  @endif
 *  @ingroup animation
 **/

/// @cond

@interface CPTAxis()

@property (nonatomic, readwrite, assign) BOOL needsRelabel;
@property (nonatomic, readwrite, cpt_weak_property) __cpt_weak CPTGridLines *minorGridLines;
@property (nonatomic, readwrite, cpt_weak_property) __cpt_weak CPTGridLines *majorGridLines;
@property (nonatomic, readwrite, assign) BOOL labelFormatterChanged;
@property (nonatomic, readwrite, assign) BOOL minorLabelFormatterChanged;
@property (nonatomic, readwrite, retain) NSMutableArray *mutableBackgroundLimitBands;
@property (nonatomic, readonly) CGFloat tickOffset;

-(void)generateFixedIntervalMajorTickLocations:(NSSet **)newMajorLocations minorTickLocations:(NSSet **)newMinorLocations;
-(void)autoGenerateMajorTickLocations:(NSSet **)newMajorLocations minorTickLocations:(NSSet **)newMinorLocations;
-(void)generateEqualMajorTickLocations:(NSSet **)newMajorLocations minorTickLocations:(NSSet **)newMinorLocations;
-(NSSet *)filteredTickLocations:(NSSet *)allLocations;
-(void)updateAxisLabelsAtLocations:(NSSet *)locations inRange:(CPTPlotRange *)labeledRange useMajorAxisLabels:(BOOL)useMajorAxisLabels;
-(void)updateCustomTickLabels;
-(void)updateMajorTickLabelOffsets;
-(void)updateMinorTickLabelOffsets;

NSDecimal niceNum(NSDecimal x);

@end

/// @endcond

#pragma mark -

/**
 *  @brief An abstract axis class.
 *
 *  The figure below illustrates the relationship between the three plot range properties. If all are
 *  @nil, the axis and grid lines will extend the full width of the plot area.
 *  @image html "axis ranges.png" "Axis Ranges"
 *  @see See @ref axisAnimation "Axes" for a list of animatable properties.
 **/
@implementation CPTAxis

// Axis

/** @property CPTLineStyle *axisLineStyle
 *  @brief The line style for the axis line.
 *  If @nil, the line is not drawn.
 **/
@synthesize axisLineStyle;

/** @property CPTCoordinate coordinate
 *  @brief The axis coordinate.
 **/
@synthesize coordinate;

/** @property NSDecimal labelingOrigin
 *  @brief The origin used for axis labels.
 *  The default value is 0. It is only used when the axis labeling
 *  policy is #CPTAxisLabelingPolicyFixedInterval. The origin is
 *  a reference point used to being labeling. Labels are added
 *  at the origin, as well as at fixed intervals above and below
 *  the origin.
 **/
@synthesize labelingOrigin;

/** @property CPTSign tickDirection
 *  @brief The tick direction.
 *  The direction is given as the sign that ticks extend along
 *  the axis (e.g., positive or negative).
 **/
@synthesize tickDirection;

/** @property CPTPlotRange *visibleRange
 *  @brief The plot range over which the axis and ticks are visible.
 *  Use this to restrict an axis and its grid lines to less than the full plot area width.
 *  Use the @ref visibleAxisRange to specify a separate range for the axis line, if needed.
 *  Set to @nil for no restriction.
 **/
@synthesize visibleRange;

/** @property CPTPlotRange *visibleAxisRange;
 *  @brief The plot range over which the axis itself is visible.
 *  Use this to restrict an axis line to less than the full plot area width. This range is independent
 *  of the @ref visibleRange and overrides it for the axis line and line cap.
 *  Set to @nil to use the @ref visibleRange instead.
 **/
@synthesize visibleAxisRange;

/** @property CPTLineCap *axisLineCapMin
 *  @brief The line cap for the end of the axis line with the minimum value.
 *  @see axisLineCapMax
 **/
@synthesize axisLineCapMin;

/** @property CPTLineCap *axisLineCapMax
 *  @brief The line cap for the end of the axis line with the maximum value.
 *  @see axisLineCapMin
 **/
@synthesize axisLineCapMax;

// Title

/** @property CPTTextStyle *titleTextStyle
 *  @brief The text style used to draw the axis title text.
 *
 *  Assigning a new value to this property also sets the value of the @ref attributedTitle property to @nil.
 **/
@synthesize titleTextStyle;

/** @property CPTAxisTitle *axisTitle
 *  @brief The axis title.
 *  If @nil, no title is drawn.
 **/
@dynamic axisTitle;

/** @property CGFloat titleOffset
 *  @brief The offset distance between the axis title and the axis line.
 *  @ingroup axisAnimation
 **/
@synthesize titleOffset;

/** @property NSString *title
 *  @brief A convenience property for setting the text title of the axis.
 *
 *  Assigning a new value to this property also sets the value of the @ref attributedTitle property to @nil.
 **/
@synthesize title;

/** @property NSAttributedString *attributedTitle
 *  @brief A convenience property for setting the styled text title of the axis.
 *
 *  Assigning a new value to this property also sets the value of the @ref title property to the
 *  same string without formatting information. It also replaces the @ref titleTextStyle with
 *  a style matching the first position (location @num{0}) of the styled title.
 *  Default is @nil.
 **/
@synthesize attributedTitle;

/** @property CGFloat titleRotation
 *  @brief The rotation angle of the axis title in radians.
 *  If @NAN (the default), the title will be parallel to the axis.
 *  @ingroup axisAnimation
 **/
@synthesize titleRotation;

/** @property NSDecimal titleLocation
 *  @brief The position along the axis where the axis title should be centered.
 *  If @NAN (the default), the @ref defaultTitleLocation will be used.
 **/
@dynamic titleLocation;

/** @property NSDecimal defaultTitleLocation
 *  @brief The position along the axis where the axis title should be centered
 *  if @ref titleLocation is @NAN.
 **/
@dynamic defaultTitleLocation;

// Plot space

/** @property CPTPlotSpace *plotSpace
 *  @brief The plot space for the axis.
 **/
@synthesize plotSpace;

// Labels

/** @property CPTAxisLabelingPolicy labelingPolicy
 *  @brief The axis labeling policy.
 **/
@synthesize labelingPolicy;

/** @property CGFloat labelOffset
 *  @brief The offset distance between the tick marks and labels.
 *  @ingroup axisAnimation
 **/
@synthesize labelOffset;

/** @property CGFloat minorTickLabelOffset
 *  @brief The offset distance between the minor tick marks and labels.
 *  @ingroup axisAnimation
 **/
@synthesize minorTickLabelOffset;

/** @property CGFloat labelRotation
 *  @brief The rotation of the axis labels in radians.
 *  Set this property to @num{π/2} to have labels read up the screen, for example.
 *  @ingroup axisAnimation
 **/
@synthesize labelRotation;

/** @property CGFloat minorTickLabelRotation
 *  @brief The rotation of the axis minor tick labels in radians.
 *  Set this property to @num{π/2} to have labels read up the screen, for example.
 *  @ingroup axisAnimation
 **/
@synthesize minorTickLabelRotation;

/** @property CPTAlignment labelAlignment
 *  @brief The alignment of the axis label with respect to the tick mark.
 **/
@synthesize labelAlignment;

/** @property CPTAlignment minorTickLabelAlignment
 *  @brief The alignment of the axis label with respect to the tick mark.
 **/
@synthesize minorTickLabelAlignment;

/** @property CPTTextStyle *labelTextStyle
 *  @brief The text style used to draw the label text.
 **/
@synthesize labelTextStyle;

/** @property CPTTextStyle *minorTickLabelTextStyle
 *  @brief The text style used to draw the label text of minor tick labels.
 **/
@synthesize minorTickLabelTextStyle;

/** @property CPTSign tickLabelDirection
 *  @brief The offset direction for major tick labels.
 *  The direction is given as the sign that ticks extend along
 *  the axis (e.g., positive or negative). If the label direction
 *  is #CPTSignNone (the default), the labels are offset in the
 *  direction indicated by the @ref tickDirection.
 **/
@synthesize tickLabelDirection;

/** @property CPTSign minorTickLabelDirection
 *  @brief The offset direction for minor tick labels.
 *  The direction is given as the sign that ticks extend along
 *  the axis (e.g., positive or negative). If the label direction
 *  is #CPTSignNone (the default), the labels are offset in the
 *  direction indicated by the @ref tickDirection.
 **/
@synthesize minorTickLabelDirection;

/** @property NSFormatter *labelFormatter
 *  @brief The number formatter used to format the label text.
 *  If you need a non-numerical label, such as a date, you can use a formatter than turns
 *  the numerical plot coordinate into a string (e.g., @quote{Jan 10, 2010}).
 *  The CPTCalendarFormatter and CPTTimeFormatter classes are useful for this purpose.
 **/
@synthesize labelFormatter;

/** @property NSFormatter *minorTickLabelFormatter
 *  @brief The number formatter used to format the label text of minor ticks.
 *  If you need a non-numerical label, such as a date, you can use a formatter than turns
 *  the numerical plot coordinate into a string (e.g., @quote{Jan 10, 2010}).
 *  The CPTCalendarFormatter and CPTTimeFormatter classes are useful for this purpose.
 **/
@synthesize minorTickLabelFormatter;

@synthesize labelFormatterChanged;
@synthesize minorLabelFormatterChanged;
@dynamic tickOffset;

/** @property NSSet *axisLabels
 *  @brief The set of axis labels.
 **/
@synthesize axisLabels;

/** @property NSSet *minorTickAxisLabels
 *  @brief The set of minor tick axis labels.
 **/
@synthesize minorTickAxisLabels;

/** @property BOOL needsRelabel
 *  @brief If @YES, the axis needs to be relabeled before the layer content is drawn.
 **/
@synthesize needsRelabel;

/** @property NSArray *labelExclusionRanges
 *  @brief An array of CPTPlotRange objects. Any tick marks and labels falling inside any of the ranges in the array will not be drawn.
 **/
@synthesize labelExclusionRanges;

/** @property CPTShadow *labelShadow
 *  @brief The shadow applied to each axis label.
 **/
@synthesize labelShadow;

/** @property CPTShadow *minorTickLabelShadow
 *  @brief The shadow applied to each minor tick axis label.
 **/
@synthesize minorTickLabelShadow;

// Major ticks

/** @property NSDecimal majorIntervalLength
 *  @brief The distance between major tick marks expressed in data coordinates.
 **/
@synthesize majorIntervalLength;

/** @property CPTLineStyle *majorTickLineStyle
 *  @brief The line style for the major tick marks.
 *  If @nil, the major ticks are not drawn.
 **/
@synthesize majorTickLineStyle;

/** @property CGFloat majorTickLength
 *  @brief The length of the major tick marks.
 **/
@synthesize majorTickLength;

/** @property NSSet *majorTickLocations
 *  @brief A set of axis coordinates for all major tick marks.
 **/
@synthesize majorTickLocations;

/** @property NSUInteger preferredNumberOfMajorTicks
 *  @brief The number of ticks that should be targeted when auto-generating positions.
 *  This property only applies when the #CPTAxisLabelingPolicyAutomatic or
 *  #CPTAxisLabelingPolicyEqualDivisions policies are in use.
 *  If zero (@num{0}) (the default), Core Plot will choose a reasonable number of ticks.
 **/
@synthesize preferredNumberOfMajorTicks;

// Minor ticks

/** @property NSUInteger minorTicksPerInterval
 *  @brief The number of minor tick marks drawn in each major tick interval.
 **/
@synthesize minorTicksPerInterval;

/** @property CPTLineStyle *minorTickLineStyle
 *  @brief The line style for the minor tick marks.
 *  If @nil, the minor ticks are not drawn.
 **/
@synthesize minorTickLineStyle;

/** @property CGFloat minorTickLength
 *  @brief The length of the minor tick marks.
 **/
@synthesize minorTickLength;

/** @property NSSet *minorTickLocations
 *  @brief A set of axis coordinates for all minor tick marks.
 **/
@synthesize minorTickLocations;

// Grid Lines

/** @property CPTLineStyle *majorGridLineStyle
 *  @brief The line style for the major grid lines.
 *  If @nil, the major grid lines are not drawn.
 **/
@synthesize majorGridLineStyle;

/** @property CPTLineStyle *minorGridLineStyle
 *  @brief The line style for the minor grid lines.
 *  If @nil, the minor grid lines are not drawn.
 **/
@synthesize minorGridLineStyle;

/** @property CPTPlotRange *CPTPlotRange *gridLinesRange
 *  @brief The plot range over which the grid lines are visible.
 *  Note that this range applies to the orthogonal coordinate, not
 *  the axis coordinate itself.
 *  Set to @nil for no restriction.
 **/
@synthesize gridLinesRange;

// Background Bands

/** @property NSArray *alternatingBandFills
 *  @brief An array of two or more fills to be drawn between successive major tick marks.
 *
 *  When initializing the fills, provide an NSArray containing any combination of CPTFill,
 *  CPTColor, CPTGradient, and/or CPTImage objects. Blank (transparent) bands can be created
 *  by using an NSNull object in place of some of the CPTFill objects.
 **/
@synthesize alternatingBandFills;

/** @property NSArray *backgroundLimitBands
 *  @brief An array of CPTLimitBand objects.
 *
 *  The limit bands are drawn on top of the alternating band fills.
 **/
@dynamic backgroundLimitBands;

@synthesize mutableBackgroundLimitBands;

// Layers

/** @property BOOL separateLayers
 *  @brief Use separate layers for drawing grid lines?
 *
 *  If @NO, the default, the major and minor grid lines are drawn in layers shared with other axes.
 *  If @YES, the grid lines are drawn in their own layers.
 **/
@synthesize separateLayers;

/** @property __cpt_weak CPTPlotArea *plotArea
 *  @brief The plot area that the axis belongs to.
 **/
@synthesize plotArea;

/** @property __cpt_weak CPTGridLines *minorGridLines
 *  @brief The layer that draws the minor grid lines.
 **/
@synthesize minorGridLines;

/** @property __cpt_weak CPTGridLines *majorGridLines
 *  @brief The layer that draws the major grid lines.
 **/
@synthesize majorGridLines;

/** @property CPTAxisSet *axisSet
 *  @brief The axis set that the axis belongs to.
 **/
@dynamic axisSet;

#pragma mark -
#pragma mark Init/Dealloc

/// @name Initialization
/// @{

/** @brief Initializes a newly allocated CPTAxis object with the provided frame rectangle.
 *
 *  This is the designated initializer. The initialized layer will have the following properties:
 *  - @ref plotSpace = @nil
 *  - @ref majorTickLocations = empty set
 *  - @ref minorTickLocations = empty set
 *  - @ref preferredNumberOfMajorTicks = @num{0}
 *  - @ref minorTickLength = @num{3.0}
 *  - @ref majorTickLength = @num{5.0}
 *  - @ref labelOffset = @num{2.0}
 *  - @ref minorTickLabelOffset = @num{2.0}
 *  - @ref labelRotation= @num{0.0}
 *  - @ref minorTickLabelRotation= @num{0.0}
 *  - @ref labelAlignment = #CPTAlignmentCenter
 *  - @ref minorTickLabelAlignment = #CPTAlignmentCenter
 *  - @ref title = @nil
 *  - @ref attributedTitle = @nil
 *  - @ref titleOffset = @num{30.0}
 *  - @ref axisLineStyle = default line style
 *  - @ref majorTickLineStyle = default line style
 *  - @ref minorTickLineStyle = default line style
 *  - @ref tickLabelDirection = #CPTSignNone
 *  - @ref minorTickLabelDirection = #CPTSignNone
 *  - @ref majorGridLineStyle = @nil
 *  - @ref minorGridLineStyle= @nil
 *  - @ref axisLineCapMin = @nil
 *  - @ref axisLineCapMax = @nil
 *  - @ref labelingOrigin = @num{0}
 *  - @ref majorIntervalLength = @num{1}
 *  - @ref minorTicksPerInterval = @num{1}
 *  - @ref coordinate = #CPTCoordinateX
 *  - @ref labelingPolicy = #CPTAxisLabelingPolicyFixedInterval
 *  - @ref labelTextStyle = default text style
 *  - @ref labelFormatter = number formatter that displays one fraction digit and at least one integer digit
 *  - @ref minorTickLabelTextStyle = default text style
 *  - @ref minorTickLabelFormatter = @nil
 *  - @ref axisLabels = empty set
 *  - @ref minorTickAxisLabels = empty set
 *  - @ref tickDirection = #CPTSignNone
 *  - @ref axisTitle = @nil
 *  - @ref titleTextStyle = default text style
 *  - @ref titleRotation = @NAN
 *  - @ref titleLocation = @NAN
 *  - @ref needsRelabel = @YES
 *  - @ref labelExclusionRanges = @nil
 *  - @ref plotArea = @nil
 *  - @ref separateLayers = @NO
 *  - @ref labelShadow = @nil
 *  - @ref minorTickLabelShadow = @nil
 *  - @ref alternatingBandFills = @nil
 *  - @ref minorGridLines = @nil
 *  - @ref majorGridLines = @nil
 *  - @ref needsDisplayOnBoundsChange = @YES
 *
 *  @param newFrame The frame rectangle.
 *  @return The initialized CPTAxis object.
 **/
-(id)initWithFrame:(CGRect)newFrame
{
    if ( (self = [super initWithFrame:newFrame]) ) {
        plotSpace                   = nil;
        majorTickLocations          = [NSSet set] ;
        minorTickLocations          = [NSSet set] ;
        preferredNumberOfMajorTicks = 0;
        minorTickLength             = CPTFloat(3.0);
        majorTickLength             = CPTFloat(5.0);
        labelOffset                 = CPTFloat(2.0);
        minorTickLabelOffset        = CPTFloat(2.0);
        labelRotation               = CPTFloat(0.0);
        minorTickLabelRotation      = CPTFloat(0.0);
        labelAlignment              = CPTAlignmentCenter;
        minorTickLabelAlignment     = CPTAlignmentCenter;
        title                       = nil;
        attributedTitle             = nil;
        titleOffset                 = CPTFloat(30.0);
        axisLineStyle               = [[CPTLineStyle alloc] init];
        majorTickLineStyle          = [[CPTLineStyle alloc] init];
        minorTickLineStyle          = [[CPTLineStyle alloc] init];
        tickLabelDirection          = CPTSignNone;
        minorTickLabelDirection     = CPTSignNone;
        majorGridLineStyle          = nil;
        minorGridLineStyle          = nil;
        axisLineCapMin              = nil;
        axisLineCapMax              = nil;
        labelingOrigin              = [[NSDecimalNumber zero] decimalValue];
        majorIntervalLength         = [[NSDecimalNumber one] decimalValue];
        minorTicksPerInterval       = 1;
        coordinate                  = CPTCoordinateX;
        labelingPolicy              = CPTAxisLabelingPolicyFixedInterval;
        labelTextStyle              = [[CPTTextStyle alloc] init];
        NSNumberFormatter *newFormatter = [[NSNumberFormatter alloc] init];
        newFormatter.minimumIntegerDigits  = 1;
        newFormatter.maximumFractionDigits = 1;
        newFormatter.minimumFractionDigits = 1;
        labelFormatter                     = newFormatter;
        minorTickLabelTextStyle            = [[CPTTextStyle alloc] init];
        minorTickLabelFormatter            = nil;
        labelFormatterChanged              = YES;
        minorLabelFormatterChanged         = NO;
        axisLabels                         = [NSSet set] ;
        minorTickAxisLabels                = [NSSet set] ;
        tickDirection                      = CPTSignNone;
        axisTitle                          = nil;
        titleTextStyle                     = [[CPTTextStyle alloc] init];
        titleRotation                      = NAN;
        titleLocation                      = CPTDecimalNaN();
        needsRelabel                       = YES;
        labelExclusionRanges               = nil;
        plotArea                           = nil;
        separateLayers                     = NO;
        labelShadow                        = nil;
        minorTickLabelShadow               = nil;
        visibleRange                       = nil;
        visibleAxisRange                   = nil;
        gridLinesRange                     = nil;
        alternatingBandFills               = nil;
        mutableBackgroundLimitBands        = nil;
        minorGridLines                     = nil;
        majorGridLines                     = nil;

        self.needsDisplayOnBoundsChange = YES;
    }
    return self;
}

/// @}

/// @cond

-(id)initWithLayer:(id)layer
{
    if ( (self = [super initWithLayer:layer]) ) {
        CPTAxis *theLayer = (CPTAxis *)layer;

        plotSpace                   = theLayer->plotSpace ;
        majorTickLocations          = theLayer->majorTickLocations ;
        minorTickLocations          = theLayer->minorTickLocations ;
        preferredNumberOfMajorTicks = theLayer->preferredNumberOfMajorTicks;
        minorTickLength             = theLayer->minorTickLength;
        majorTickLength             = theLayer->majorTickLength;
        labelOffset                 = theLayer->labelOffset;
        minorTickLabelOffset        = theLayer->labelOffset;
        labelRotation               = theLayer->labelRotation;
        minorTickLabelRotation      = theLayer->labelRotation;
        labelAlignment              = theLayer->labelAlignment;
        minorTickLabelAlignment     = theLayer->labelAlignment;
        title                       = theLayer->title ;
        attributedTitle             = theLayer->attributedTitle ;
        titleOffset                 = theLayer->titleOffset;
        axisLineStyle               = theLayer->axisLineStyle ;
        majorTickLineStyle          = theLayer->majorTickLineStyle ;
        minorTickLineStyle          = theLayer->minorTickLineStyle ;
        tickLabelDirection          = theLayer->tickLabelDirection;
        minorTickLabelDirection     = theLayer->minorTickLabelDirection;
        majorGridLineStyle          = theLayer->majorGridLineStyle ;
        minorGridLineStyle          = theLayer->minorGridLineStyle ;
        axisLineCapMin              = theLayer->axisLineCapMin ;
        axisLineCapMax              = theLayer->axisLineCapMax ;
        labelingOrigin              = theLayer->labelingOrigin;
        majorIntervalLength         = theLayer->majorIntervalLength;
        minorTicksPerInterval       = theLayer->minorTicksPerInterval;
        coordinate                  = theLayer->coordinate;
        labelingPolicy              = theLayer->labelingPolicy;
        labelFormatter              = theLayer->labelFormatter ;
        minorTickLabelFormatter     = theLayer->minorTickLabelFormatter ;
        axisLabels                  = theLayer->axisLabels ;
        minorTickAxisLabels         = theLayer->minorTickAxisLabels ;
        tickDirection               = theLayer->tickDirection;
        labelTextStyle              = theLayer->labelTextStyle ;
        minorTickLabelTextStyle     = theLayer->minorTickLabelTextStyle ;
        axisTitle                   = theLayer->axisTitle ;
        titleTextStyle              = theLayer->titleTextStyle ;
        titleRotation               = theLayer->titleRotation;
        titleLocation               = theLayer->titleLocation;
        needsRelabel                = theLayer->needsRelabel;
        labelExclusionRanges        = theLayer->labelExclusionRanges ;
        plotArea                    = theLayer->plotArea;
        separateLayers              = theLayer->separateLayers;
        labelShadow                 = theLayer->labelShadow ;
        minorTickLabelShadow        = theLayer->minorTickLabelShadow ;
        visibleRange                = theLayer->visibleRange ;
        visibleAxisRange            = theLayer->visibleAxisRange ;
        gridLinesRange              = theLayer->gridLinesRange ;
        alternatingBandFills        = theLayer->alternatingBandFills ;
        mutableBackgroundLimitBands = theLayer->mutableBackgroundLimitBands ;
        minorGridLines              = theLayer->minorGridLines;
        majorGridLines              = theLayer->majorGridLines;
    }
    return self;
}

-(void)dealloc
{
    plotArea       = nil;
    minorGridLines = nil;
    majorGridLines = nil;
    for ( CPTAxisLabel *label in axisLabels ) {
        [label.contentLayer removeFromSuperlayer];
    }
    [axisTitle.contentLayer removeFromSuperlayer];


}

/// @endcond

#pragma mark -
#pragma mark NSCoding Methods

/// @cond

-(void)encodeWithCoder:(NSCoder *)coder
{
    [super encodeWithCoder:coder];

    [coder encodeInt:self.coordinate forKey:@"CPTAxis.coordinate"];
    [coder encodeObject:self.plotSpace forKey:@"CPTAxis.plotSpace"];
    [coder encodeObject:self.majorTickLocations forKey:@"CPTAxis.majorTickLocations"];
    [coder encodeObject:self.minorTickLocations forKey:@"CPTAxis.minorTickLocations"];
    [coder encodeCGFloat:self.majorTickLength forKey:@"CPTAxis.majorTickLength"];
    [coder encodeCGFloat:self.minorTickLength forKey:@"CPTAxis.minorTickLength"];
    [coder encodeCGFloat:self.labelOffset forKey:@"CPTAxis.labelOffset"];
    [coder encodeCGFloat:self.minorTickLabelOffset forKey:@"CPTAxis.minorTickLabelOffset"];
    [coder encodeCGFloat:self.labelRotation forKey:@"CPTAxis.labelRotation"];
    [coder encodeCGFloat:self.minorTickLabelRotation forKey:@"CPTAxis.minorTickLabelRotation"];
    [coder encodeInt:self.labelAlignment forKey:@"CPTAxis.labelAlignment"];
    [coder encodeInt:self.minorTickLabelAlignment forKey:@"CPTAxis.minorTickLabelAlignment"];
    [coder encodeObject:self.axisLineStyle forKey:@"CPTAxis.axisLineStyle"];
    [coder encodeObject:self.majorTickLineStyle forKey:@"CPTAxis.majorTickLineStyle"];
    [coder encodeObject:self.minorTickLineStyle forKey:@"CPTAxis.minorTickLineStyle"];
    [coder encodeInteger:self.tickLabelDirection forKey:@"CPTAxis.tickLabelDirection"];
    [coder encodeInteger:self.minorTickLabelDirection forKey:@"CPTAxis.minorTickLabelDirection"];
    [coder encodeObject:self.majorGridLineStyle forKey:@"CPTAxis.majorGridLineStyle"];
    [coder encodeObject:self.minorGridLineStyle forKey:@"CPTAxis.minorGridLineStyle"];
    [coder encodeObject:self.axisLineCapMin forKey:@"CPTAxis.axisLineCapMin"];
    [coder encodeObject:self.axisLineCapMax forKey:@"CPTAxis.axisLineCapMax"];
    [coder encodeDecimal:self.labelingOrigin forKey:@"CPTAxis.labelingOrigin"];
    [coder encodeDecimal:self.majorIntervalLength forKey:@"CPTAxis.majorIntervalLength"];
    [coder encodeInteger:(NSInteger)self.minorTicksPerInterval forKey:@"CPTAxis.minorTicksPerInterval"];
    [coder encodeInteger:(NSInteger)self.preferredNumberOfMajorTicks forKey:@"CPTAxis.preferredNumberOfMajorTicks"];
    [coder encodeInt:self.labelingPolicy forKey:@"CPTAxis.labelingPolicy"];
    [coder encodeObject:self.labelTextStyle forKey:@"CPTAxis.labelTextStyle"];
    [coder encodeObject:self.minorTickLabelTextStyle forKey:@"CPTAxis.minorTickLabelTextStyle"];
    [coder encodeObject:self.titleTextStyle forKey:@"CPTAxis.titleTextStyle"];
    [coder encodeObject:self.labelFormatter forKey:@"CPTAxis.labelFormatter"];
    [coder encodeObject:self.minorTickLabelFormatter forKey:@"CPTAxis.minorTickLabelFormatter"];
    [coder encodeBool:self.labelFormatterChanged forKey:@"CPTAxis.labelFormatterChanged"];
    [coder encodeBool:self.minorLabelFormatterChanged forKey:@"CPTAxis.minorLabelFormatterChanged"];
    [coder encodeObject:self.axisLabels forKey:@"CPTAxis.axisLabels"];
    [coder encodeObject:self.minorTickAxisLabels forKey:@"CPTAxis.minorTickAxisLabels"];
    [coder encodeObject:self.axisTitle forKey:@"CPTAxis.axisTitle"];
    [coder encodeObject:self.title forKey:@"CPTAxis.title"];
    [coder encodeObject:self.attributedTitle forKey:@"CPTAxis.attributedTitle"];
    [coder encodeCGFloat:self.titleOffset forKey:@"CPTAxis.titleOffset"];
    [coder encodeCGFloat:self.titleRotation forKey:@"CPTAxis.titleRotation"];
    [coder encodeDecimal:self.titleLocation forKey:@"CPTAxis.titleLocation"];
    [coder encodeInt:self.tickDirection forKey:@"CPTAxis.tickDirection"];
    [coder encodeBool:self.needsRelabel forKey:@"CPTAxis.needsRelabel"];
    [coder encodeObject:self.labelExclusionRanges forKey:@"CPTAxis.labelExclusionRanges"];
    [coder encodeObject:self.visibleRange forKey:@"CPTAxis.visibleRange"];
    [coder encodeObject:self.visibleAxisRange forKey:@"CPTAxis.visibleAxisRange"];
    [coder encodeObject:self.gridLinesRange forKey:@"CPTAxis.gridLinesRange"];
    [coder encodeObject:self.alternatingBandFills forKey:@"CPTAxis.alternatingBandFills"];
    [coder encodeObject:self.mutableBackgroundLimitBands forKey:@"CPTAxis.mutableBackgroundLimitBands"];
    [coder encodeBool:self.separateLayers forKey:@"CPTAxis.separateLayers"];
    [coder encodeObject:self.labelShadow forKey:@"CPTAxis.labelShadow"];
    [coder encodeObject:self.minorTickLabelShadow forKey:@"CPTAxis.minorTickLabelShadow"];
    [coder encodeConditionalObject:self.plotArea forKey:@"CPTAxis.plotArea"];
    [coder encodeConditionalObject:self.minorGridLines forKey:@"CPTAxis.minorGridLines"];
    [coder encodeConditionalObject:self.majorGridLines forKey:@"CPTAxis.majorGridLines"];
}

-(id)initWithCoder:(NSCoder *)coder
{
    if ( (self = [super initWithCoder:coder]) ) {
        coordinate                  = (CPTCoordinate)[coder decodeIntForKey : @"CPTAxis.coordinate"];
        plotSpace                   = [coder decodeObjectForKey:@"CPTAxis.plotSpace"] ;
        majorTickLocations          = [coder decodeObjectForKey:@"CPTAxis.majorTickLocations"] ;
        minorTickLocations          = [coder decodeObjectForKey:@"CPTAxis.minorTickLocations"] ;
        majorTickLength             = [coder decodeCGFloatForKey:@"CPTAxis.majorTickLength"];
        minorTickLength             = [coder decodeCGFloatForKey:@"CPTAxis.minorTickLength"];
        labelOffset                 = [coder decodeCGFloatForKey:@"CPTAxis.labelOffset"];
        minorTickLabelOffset        = [coder decodeCGFloatForKey:@"CPTAxis.minorTickLabelOffset"];
        labelRotation               = [coder decodeCGFloatForKey:@"CPTAxis.labelRotation"];
        minorTickLabelRotation      = [coder decodeCGFloatForKey:@"CPTAxis.minorTickLabelRotation"];
        labelAlignment              = (CPTAlignment)[coder decodeIntForKey : @"CPTAxis.labelAlignment"];
        minorTickLabelAlignment     = (CPTAlignment)[coder decodeIntForKey : @"CPTAxis.minorTickLabelAlignment"];
        axisLineStyle               = [[coder decodeObjectForKey:@"CPTAxis.axisLineStyle"] copy];
        majorTickLineStyle          = [[coder decodeObjectForKey:@"CPTAxis.majorTickLineStyle"] copy];
        minorTickLineStyle          = [[coder decodeObjectForKey:@"CPTAxis.minorTickLineStyle"] copy];
        tickLabelDirection          = (CPTSign)[coder decodeIntegerForKey : @"CPTAxis.tickLabelDirection"];
        minorTickLabelDirection     = (CPTSign)[coder decodeIntegerForKey : @"CPTAxis.minorTickLabelDirection"];
        majorGridLineStyle          = [[coder decodeObjectForKey:@"CPTAxis.majorGridLineStyle"] copy];
        minorGridLineStyle          = [[coder decodeObjectForKey:@"CPTAxis.minorGridLineStyle"] copy];
        axisLineCapMin              = [[coder decodeObjectForKey:@"CPTAxis.axisLineCapMin"] copy];
        axisLineCapMax              = [[coder decodeObjectForKey:@"CPTAxis.axisLineCapMax"] copy];
        labelingOrigin              = [coder decodeDecimalForKey:@"CPTAxis.labelingOrigin"];
        majorIntervalLength         = [coder decodeDecimalForKey:@"CPTAxis.majorIntervalLength"];
        minorTicksPerInterval       = (NSUInteger)[coder decodeIntegerForKey : @"CPTAxis.minorTicksPerInterval"];
        preferredNumberOfMajorTicks = (NSUInteger)[coder decodeIntegerForKey : @"CPTAxis.preferredNumberOfMajorTicks"];
        labelingPolicy              = (CPTAxisLabelingPolicy)[coder decodeIntForKey : @"CPTAxis.labelingPolicy"];
        labelTextStyle              = [[coder decodeObjectForKey:@"CPTAxis.labelTextStyle"] copy];
        minorTickLabelTextStyle     = [[coder decodeObjectForKey:@"CPTAxis.minorTickLabelTextStyle"] copy];
        titleTextStyle              = [[coder decodeObjectForKey:@"CPTAxis.titleTextStyle"] copy];
        labelFormatter              = [coder decodeObjectForKey:@"CPTAxis.labelFormatter"] ;
        minorTickLabelFormatter     = [coder decodeObjectForKey:@"CPTAxis.minorTickLabelFormatter"];
        labelFormatterChanged       = [coder decodeBoolForKey:@"CPTAxis.labelFormatterChanged"];
        minorLabelFormatterChanged  = [coder decodeBoolForKey:@"CPTAxis.minorLabelFormatterChanged"];
        axisLabels                  = [coder decodeObjectForKey:@"CPTAxis.axisLabels"] ;
        minorTickAxisLabels         = [coder decodeObjectForKey:@"CPTAxis.minorTickAxisLabels"] ;
        axisTitle                   = [coder decodeObjectForKey:@"CPTAxis.axisTitle"] ;
        title                       = [[coder decodeObjectForKey:@"CPTAxis.title"] copy];
        attributedTitle             = [[coder decodeObjectForKey:@"CPTAxis.attributedTitle"] copy];
        titleOffset                 = [coder decodeCGFloatForKey:@"CPTAxis.titleOffset"];
        titleRotation               = [coder decodeCGFloatForKey:@"CPTAxis.titleRotation"];
        titleLocation               = [coder decodeDecimalForKey:@"CPTAxis.titleLocation"];
        tickDirection               = (CPTSign)[coder decodeIntForKey : @"CPTAxis.tickDirection"];
        needsRelabel                = [coder decodeBoolForKey:@"CPTAxis.needsRelabel"];
        labelExclusionRanges        = [coder decodeObjectForKey:@"CPTAxis.labelExclusionRanges"] ;
        visibleRange                = [[coder decodeObjectForKey:@"CPTAxis.visibleRange"] copy];
        visibleAxisRange            = [[coder decodeObjectForKey:@"CPTAxis.visibleAxisRange"] copy];
        gridLinesRange              = [[coder decodeObjectForKey:@"CPTAxis.gridLinesRange"] copy];
        alternatingBandFills        = [[coder decodeObjectForKey:@"CPTAxis.alternatingBandFills"] copy];
        mutableBackgroundLimitBands = [[coder decodeObjectForKey:@"CPTAxis.mutableBackgroundLimitBands"] mutableCopy];
        separateLayers              = [coder decodeBoolForKey:@"CPTAxis.separateLayers"];
        labelShadow                 = [coder decodeObjectForKey:@"CPTAxis.labelShadow"] ;
        minorTickLabelShadow        = [coder decodeObjectForKey:@"CPTAxis.minorTickLabelShadow"] ;
        plotArea                    = [coder decodeObjectForKey:@"CPTAxis.plotArea"];
        minorGridLines              = [coder decodeObjectForKey:@"CPTAxis.minorGridLines"];
        majorGridLines              = [coder decodeObjectForKey:@"CPTAxis.majorGridLines"];
    }
    return self;
}

/// @endcond

#pragma mark -
#pragma mark Animation

/// @cond

+(BOOL)needsDisplayForKey:(NSString *)aKey
{
    static NSArray *keys = nil;

    if ( !keys ) {
        keys = [[NSArray alloc] initWithObjects:
                @"titleOffset",
                @"titleRotation",
                @"labelOffset",
                @"minorTickLabelOffset",
                @"labelRotation",
                @"minorTickLabelRotation",
                nil];
    }

    if ( [keys containsObject:aKey] ) {
        return YES;
    }
    else {
        return [super needsDisplayForKey:aKey];
    }
}

/// @endcond

#pragma mark -
#pragma mark Ticks

/// @cond

/**
 *  @internal
 *  @brief Generate major and minor tick locations using the fixed interval labeling policy.
 *  @param newMajorLocations A new NSSet containing the major tick locations.
 *  @param newMinorLocations A new NSSet containing the minor tick locations.
 */
-(void)generateFixedIntervalMajorTickLocations:(NSSet **)newMajorLocations minorTickLocations:(NSSet **)newMinorLocations
{
    NSMutableSet *majorLocations = [NSMutableSet set];
    NSMutableSet *minorLocations = [NSMutableSet set];

    NSDecimal zero          = CPTDecimalFromInteger(0);
    NSDecimal majorInterval = self.majorIntervalLength;

    if ( CPTDecimalGreaterThan(majorInterval, zero) ) {
        CPTMutablePlotRange *range = [[self.plotSpace plotRangeForCoordinate:self.coordinate] mutableCopy];
        if ( range ) {
            CPTPlotRange *theVisibleRange = self.visibleRange;
            if ( theVisibleRange ) {
                [range intersectionPlotRange:theVisibleRange];
            }

            NSDecimal rangeMin = range.minLimit;
            NSDecimal rangeMax = range.maxLimit;

            NSDecimal minorInterval;
            NSUInteger minorTickCount = self.minorTicksPerInterval;
            if ( minorTickCount > 0 ) {
                minorInterval = CPTDecimalDivide( majorInterval, CPTDecimalFromUnsignedInteger(minorTickCount + 1) );
            }
            else {
                minorInterval = zero;
            }

            // Set starting coord--should be the smallest value >= rangeMin that is a whole multiple of majorInterval away from the labelingOrigin
            NSDecimal coord = CPTDecimalDivide(CPTDecimalSubtract(rangeMin, self.labelingOrigin), majorInterval);
            NSDecimalRound(&coord, &coord, 0, NSRoundUp);
            coord = CPTDecimalAdd(CPTDecimalMultiply(coord, majorInterval), self.labelingOrigin);

            // Set minor ticks between the starting point and rangeMin
            if ( minorTickCount > 0 ) {
                NSDecimal minorCoord = CPTDecimalSubtract(coord, minorInterval);

                for ( NSUInteger minorTickIndex = 0; minorTickIndex < minorTickCount; minorTickIndex++ ) {
                    if ( CPTDecimalLessThan(minorCoord, rangeMin) ) {
                        break;
                    }
                    [minorLocations addObject:[NSDecimalNumber decimalNumberWithDecimal:minorCoord]];
                    minorCoord = CPTDecimalSubtract(minorCoord, minorInterval);
                }
            }

            // Set tick locations
            while ( CPTDecimalLessThanOrEqualTo(coord, rangeMax) ) {
                // Major tick
                [majorLocations addObject:[NSDecimalNumber decimalNumberWithDecimal:coord]];

                // Minor ticks
                if ( minorTickCount > 0 ) {
                    NSDecimal minorCoord = CPTDecimalAdd(coord, minorInterval);

                    for ( NSUInteger minorTickIndex = 0; minorTickIndex < minorTickCount; minorTickIndex++ ) {
                        if ( CPTDecimalGreaterThan(minorCoord, rangeMax) ) {
                            break;
                        }
                        [minorLocations addObject:[NSDecimalNumber decimalNumberWithDecimal:minorCoord]];
                        minorCoord = CPTDecimalAdd(minorCoord, minorInterval);
                    }
                }

                coord = CPTDecimalAdd(coord, majorInterval);
            }
        }


    }

    *newMajorLocations = majorLocations;
    *newMinorLocations = minorLocations;
}

/**
 *  @internal
 *  @brief Generate major and minor tick locations using the automatic labeling policy.
 *  @param newMajorLocations A new NSSet containing the major tick locations.
 *  @param newMinorLocations A new NSSet containing the minor tick locations.
 */
-(void)autoGenerateMajorTickLocations:(NSSet **)newMajorLocations minorTickLocations:(NSSet **)newMinorLocations
{
    // Get plot range
    CPTMutablePlotRange *range    = [[self.plotSpace plotRangeForCoordinate:self.coordinate] mutableCopy];
    CPTPlotRange *theVisibleRange = self.visibleRange;

    if ( theVisibleRange ) {
        [range intersectionPlotRange:theVisibleRange];
    }

    // Validate scale type
    CPTScaleType scaleType = [self.plotSpace scaleTypeForCoordinate:self.coordinate];

    switch ( scaleType ) {
        case CPTScaleTypeLinear:
            // supported scale type
            break;

        case CPTScaleTypeLog:
            // supported scale type--check range
            if ( (range.minLimitDouble <= 0.0) || (range.maxLimitDouble <= 0.0) ) {
                *newMajorLocations = [NSMutableSet set];
                *newMinorLocations = [NSMutableSet set];
               
                return;
            }
            break;

        default:
            // unsupported scale type--bail out
            *newMajorLocations = [NSMutableSet set];
            *newMinorLocations = [NSMutableSet set];
           
            return;

            break;
    }

    // Cache some values
    NSUInteger numTicks   = self.preferredNumberOfMajorTicks;
    NSUInteger minorTicks = self.minorTicksPerInterval + 1;
    double length         = fabs(range.lengthDouble);

    // Create sets for locations
    NSMutableSet *majorLocations = [NSMutableSet set];
    NSMutableSet *minorLocations = [NSMutableSet set];

    // Filter troublesome values and return empty sets
    if ( length != 0.0 ) {
        switch ( scaleType ) {
            case CPTScaleTypeLinear:
            {
                // Determine interval value
                switch ( numTicks ) {
                    case 0:
                        numTicks = 5;
                        break;

                    case 1:
                        numTicks = 2;
                        break;

                    default:
                        // ok
                        break;
                }

                NSDecimal zero = CPTDecimalFromInteger(0);

                NSDecimal majorInterval = CPTDecimalDivide( range.length, CPTDecimalFromUnsignedInteger(numTicks - 1) );
                majorInterval = niceNum(majorInterval);
                if ( CPTDecimalLessThan(majorInterval, zero) ) {
                    majorInterval = CPTDecimalMultiply( majorInterval, CPTDecimalFromInteger(-1) );
                }

                NSDecimal minorInterval;
                if ( minorTicks > 1 ) {
                    minorInterval = CPTDecimalDivide( majorInterval, CPTDecimalFromUnsignedInteger(minorTicks) );
                }
                else {
                    minorInterval = zero;
                }

                // Calculate actual range limits
                NSDecimal minLimit = range.minLimit;
                NSDecimal maxLimit = range.maxLimit;

                // Determine the initial and final major indexes for the actual visible range
                NSDecimal idx = CPTDecimalDivide(minLimit, majorInterval);
                NSDecimalRound(&idx, &idx, 0, NSRoundDown);
                NSInteger initialIndex = CPTDecimalIntegerValue(idx); // can be negative

                idx = CPTDecimalDivide(maxLimit, majorInterval);
                NSDecimalRound(&idx, &idx, 0, NSRoundUp);
                NSInteger finalIndex = CPTDecimalIntegerValue(idx); // can be negative

                // Iterate through the indexes with visible ticks and build the locations sets
                for ( NSInteger i = initialIndex; i <= finalIndex; i++ ) {
                    NSDecimal pointLocation      = CPTDecimalMultiply( majorInterval, CPTDecimalFromInteger(i) );
                    NSDecimal minorPointLocation = pointLocation;
                    for ( NSUInteger j = 1; j < minorTicks; j++ ) {
                        minorPointLocation = CPTDecimalAdd(minorPointLocation, minorInterval);

                        if ( CPTDecimalLessThan(minorPointLocation, minLimit) ) {
                            continue;
                        }
                        if ( CPTDecimalGreaterThan(minorPointLocation, maxLimit) ) {
                            continue;
                        }
                        [minorLocations addObject:[NSDecimalNumber decimalNumberWithDecimal:minorPointLocation]];
                    }

                    if ( CPTDecimalLessThan(pointLocation, minLimit) ) {
                        continue;
                    }
                    if ( CPTDecimalGreaterThan(pointLocation, maxLimit) ) {
                        continue;
                    }
                    [majorLocations addObject:[NSDecimalNumber decimalNumberWithDecimal:pointLocation]];
                }
            }
            break;

            case CPTScaleTypeLog:
            {
                double minLimit = range.minLimitDouble;
                double maxLimit = range.maxLimitDouble;

                if ( (minLimit > 0.0) && (maxLimit > 0.0) ) {
                    // Determine interval value
                    if ( numTicks == 0 ) {
                        numTicks = 5;
                    }

                    double interval;

                    length = log10(maxLimit / minLimit);

                    if ( fabs(length) >= numTicks ) {
                        interval = CPTDecimalDoubleValue( niceNum( CPTDecimalFromDouble( length / (numTicks - 1) ) ) );
                    }
                    else {
                        interval = signbit(length) ? -1.0 : 1.0;
                    }
                    double intervalStep = pow( 10.0, fabs(interval) );

                    // Determine minor interval
                    double minorInterval = intervalStep * pow( 10.0, floor( log10(minLimit) ) ) / minorTicks;

                    // Determine the initial and final major indexes for the actual visible range
                    NSInteger initialIndex = (NSInteger)floor( log10( minLimit / fabs(interval) ) ); // can be negative
                    NSInteger finalIndex   = (NSInteger)ceil( log10( maxLimit / fabs(interval) ) );  // can be negative

                    // Iterate through the indexes with visible ticks and build the locations sets
                    for ( NSInteger i = initialIndex; i <= finalIndex; i++ ) {
                        double pointLocation = pow(10.0, i * interval);
                        for ( NSUInteger j = 1; j < minorTicks; j++ ) {
                            double minorPointLocation = pointLocation + minorInterval * j;
                            if ( minorPointLocation < minLimit ) {
                                continue;
                            }
                            if ( minorPointLocation > maxLimit ) {
                                continue;
                            }
                            [minorLocations addObject:[NSDecimalNumber numberWithDouble:minorPointLocation]];
                        }
                        minorInterval *= intervalStep;

                        if ( pointLocation < minLimit ) {
                            continue;
                        }
                        if ( pointLocation > maxLimit ) {
                            continue;
                        }
                        [majorLocations addObject:[NSDecimalNumber numberWithDouble:pointLocation]];
                    }
                }
            }
            break;

            default:
                break;
        }
    }



    // Return tick locations sets
    *newMajorLocations = majorLocations;
    *newMinorLocations = minorLocations;
}

/**
 *  @internal
 *  @brief Generate major and minor tick locations using the equal divisions labeling policy.
 *  @param newMajorLocations A new NSSet containing the major tick locations.
 *  @param newMinorLocations A new NSSet containing the minor tick locations.
 */
-(void)generateEqualMajorTickLocations:(NSSet **)newMajorLocations minorTickLocations:(NSSet **)newMinorLocations
{
    NSMutableSet *majorLocations = [NSMutableSet set];
    NSMutableSet *minorLocations = [NSMutableSet set];

    CPTMutablePlotRange *range = [[self.plotSpace plotRangeForCoordinate:self.coordinate] mutableCopy];

    if ( range ) {
        CPTPlotRange *theVisibleRange = self.visibleRange;
        if ( theVisibleRange ) {
            [range intersectionPlotRange:theVisibleRange];
        }

        if ( range.lengthDouble != 0.0 ) {
            NSDecimal zero     = CPTDecimalFromInteger(0);
            NSDecimal rangeMin = range.minLimit;
            NSDecimal rangeMax = range.maxLimit;

            NSUInteger majorTickCount = self.preferredNumberOfMajorTicks;

            if ( majorTickCount < 2 ) {
                majorTickCount = 2;
            }
            NSDecimal majorInterval = CPTDecimalDivide( range.length, CPTDecimalFromUnsignedInteger(majorTickCount - 1) );
            if ( CPTDecimalLessThan(majorInterval, zero) ) {
                majorInterval = CPTDecimalMultiply( majorInterval, CPTDecimalFromInteger(-1) );
            }

            NSDecimal minorInterval;
            NSUInteger minorTickCount = self.minorTicksPerInterval;
            if ( minorTickCount > 0 ) {
                minorInterval = CPTDecimalDivide( majorInterval, CPTDecimalFromUnsignedInteger(minorTickCount + 1) );
            }
            else {
                minorInterval = zero;
            }

            NSDecimal coord = rangeMin;

            // Set tick locations
            while ( CPTDecimalLessThanOrEqualTo(coord, rangeMax) ) {
                // Major tick
                [majorLocations addObject:[NSDecimalNumber decimalNumberWithDecimal:coord]];

                // Minor ticks
                if ( minorTickCount > 0 ) {
                    NSDecimal minorCoord = CPTDecimalAdd(coord, minorInterval);

                    for ( NSUInteger minorTickIndex = 0; minorTickIndex < minorTickCount; minorTickIndex++ ) {
                        if ( CPTDecimalGreaterThan(minorCoord, rangeMax) ) {
                            break;
                        }
                        [minorLocations addObject:[NSDecimalNumber decimalNumberWithDecimal:minorCoord]];
                        minorCoord = CPTDecimalAdd(minorCoord, minorInterval);
                    }
                }

                coord = CPTDecimalAdd(coord, majorInterval);
            }
        }
    }



    *newMajorLocations = majorLocations;
    *newMinorLocations = minorLocations;
}

/**
 *  @internal
 *  @brief Determines a @quote{nice} number (a multiple of @num{2}, @num{5}, or @num{10}) near the given number.
 *  @param x The number to round.
 */
NSDecimal niceNum(NSDecimal x)
{
    NSDecimal zero = CPTDecimalFromInteger(0);
    NSDecimal minusOne;

    if ( CPTDecimalEquals(x, zero) ) {
        return zero;
    }

    BOOL xIsNegative = CPTDecimalLessThan(x, zero);
    if ( xIsNegative ) {
        minusOne = CPTDecimalFromInteger(-1);
        x        = CPTDecimalMultiply(x, minusOne);
    }

    short exponent = (short)floor( log10( CPTDecimalDoubleValue(x) ) );

    NSDecimal fractionPart;
    NSDecimalMultiplyByPowerOf10(&fractionPart, &x, -exponent, NSRoundPlain);

    NSDecimal roundedFraction;

    if ( CPTDecimalLessThan( fractionPart, CPTDecimalFromDouble(1.5) ) ) {
        roundedFraction = CPTDecimalFromInteger(1);
    }
    else if ( CPTDecimalLessThan( fractionPart, CPTDecimalFromInteger(3) ) ) {
        roundedFraction = CPTDecimalFromInteger(2);
    }
    else if ( CPTDecimalLessThan( fractionPart, CPTDecimalFromInteger(7) ) ) {
        roundedFraction = CPTDecimalFromInteger(5);
    }
    else {
        roundedFraction = CPTDecimalFromInteger(10);
    }

    if ( xIsNegative ) {
        roundedFraction = CPTDecimalMultiply(roundedFraction, minusOne);
    }

    NSDecimal roundedNumber;
    NSDecimalMultiplyByPowerOf10(&roundedNumber, &roundedFraction, exponent, NSRoundPlain);

    return roundedNumber;
}

/**
 *  @internal
 *  @brief Removes any tick locations falling inside the label exclusion ranges from a set of tick locations.
 *  @param allLocations A set of tick locations.
 *  @return The filtered set of tick locations.
 */
-(NSSet *)filteredTickLocations:(NSSet *)allLocations
{
    NSArray *exclusionRanges = self.labelExclusionRanges;

    if ( exclusionRanges ) {
        NSMutableSet *filteredLocations = [allLocations mutableCopy];
        for ( CPTPlotRange *range in exclusionRanges ) {
            for ( NSDecimalNumber *location in allLocations ) {
                if ( [range contains:[location decimalValue]] ) {
                    [filteredLocations removeObject:location];
                }
            }
        }
        return filteredLocations ;
    }
    else {
        return allLocations;
    }
}

/// @endcond

/** @brief Removes any major ticks falling inside the label exclusion ranges from the set of tick locations.
 *  @param allLocations A set of major tick locations.
 *  @return The filtered set.
 **/
-(NSSet *)filteredMajorTickLocations:(NSSet *)allLocations
{
    return [self filteredTickLocations:allLocations];
}

/** @brief Removes any minor ticks falling inside the label exclusion ranges from the set of tick locations.
 *  @param allLocations A set of minor tick locations.
 *  @return The filtered set.
 **/
-(NSSet *)filteredMinorTickLocations:(NSSet *)allLocations
{
    return [self filteredTickLocations:allLocations];
}

#pragma mark -
#pragma mark Labels

/// @cond

-(CGFloat)tickOffset
{
    CGFloat offset = CPTFloat(0.0);

    switch ( self.tickDirection ) {
        case CPTSignNone:
            offset += self.majorTickLength * CPTFloat(0.5);
            break;

        case CPTSignPositive:
        case CPTSignNegative:
            offset += self.majorTickLength;
            break;
    }

    return offset;
}

/**
 *  @internal
 *  @brief Updates the set of axis labels using the given locations.
 *  Existing axis label objects and content layers are reused where possible.
 *  @param locations A set of NSDecimalNumber label locations.
 *  @param labeledRange A plot range used to filter the generated labels. If @nil, no filtering is done.
 *  @param useMajorAxisLabels If @YES, label the major ticks, otherwise label the minor ticks.
 **/
-(void)updateAxisLabelsAtLocations:(NSSet *)locations inRange:(CPTPlotRange *)labeledRange useMajorAxisLabels:(BOOL)useMajorAxisLabels
{
    CPTAlignment theLabelAlignment;
    CPTSign theLabelDirection;
    CGFloat theLabelOffset;
    CGFloat theLabelRotation;
    CPTTextStyle *theLabelTextStyle;
    NSFormatter *theLabelFormatter;
    BOOL theLabelFormatterChanged;
    CPTShadow *theShadow;

    if ( useMajorAxisLabels ) {
        if ( [self.delegate respondsToSelector:@selector(axis:shouldUpdateAxisLabelsAtLocations:)] ) {
            BOOL shouldContinue = [self.delegate axis:self shouldUpdateAxisLabelsAtLocations:locations];
            if ( !shouldContinue ) {
                return;
            }
        }
        theLabelAlignment        = self.labelAlignment;
        theLabelDirection        = self.tickLabelDirection;
        theLabelOffset           = self.labelOffset;
        theLabelRotation         = self.labelRotation;
        theLabelTextStyle        = self.labelTextStyle;
        theLabelFormatter        = self.labelFormatter;
        theLabelFormatterChanged = self.labelFormatterChanged;
        theShadow                = self.labelShadow;
    }
    else {
        if ( [self.delegate respondsToSelector:@selector(axis:shouldUpdateMinorAxisLabelsAtLocations:)] ) {
            BOOL shouldContinue = [self.delegate axis:self shouldUpdateMinorAxisLabelsAtLocations:locations];
            if ( !shouldContinue ) {
                return;
            }
        }
        theLabelAlignment        = self.minorTickLabelAlignment;
        theLabelDirection        = self.minorTickLabelDirection;
        theLabelOffset           = self.minorTickLabelOffset;
        theLabelRotation         = self.minorTickLabelRotation;
        theLabelTextStyle        = self.minorTickLabelTextStyle;
        theLabelFormatter        = self.minorTickLabelFormatter;
        theLabelFormatterChanged = self.minorLabelFormatterChanged;
        theShadow                = self.minorTickLabelShadow;
    }

    if ( (locations.count == 0) || !theLabelTextStyle || !theLabelFormatter ) {
        if ( useMajorAxisLabels ) {
            self.axisLabels = nil;
        }
        else {
            self.minorTickAxisLabels = nil;
        }
        return;
    }

    NSDictionary *textAttributes = [theLabelTextStyle attributes];
    BOOL hasAttributedFormatter  = ([theLabelFormatter attributedStringForObjectValue:[NSDecimalNumber zero]
                                                                withDefaultAttributes:textAttributes] != nil);

    CPTSign direction = self.tickDirection;

    if ( theLabelDirection == CPTSignNone ) {
        theLabelDirection = direction;
    }

    if ( (direction == CPTSignNone) || (theLabelDirection == direction) ) {
        theLabelOffset += self.tickOffset;
    }

    [self.plotArea setAxisSetLayersForType:CPTGraphLayerTypeAxisLabels];

    NSMutableSet *oldAxisLabels;
    if ( useMajorAxisLabels ) {
        oldAxisLabels = [self.axisLabels mutableCopy];
    }
    else {
        oldAxisLabels = [self.minorTickAxisLabels mutableCopy];
    }

    NSMutableSet *newAxisLabels       = [[NSMutableSet alloc] initWithCapacity:locations.count];
    CPTAxisLabel *blankLabel          = [[CPTAxisLabel alloc] initWithText:nil textStyle:nil];
    CPTAxisLabelGroup *axisLabelGroup = self.plotArea.axisLabelGroup;
    CPTLayer *lastLayer               = nil;
    CPTPlotArea *thePlotArea          = self.plotArea;

    for ( NSDecimalNumber *tickLocation in locations ) {
        NSDecimal locationDecimal = tickLocation.decimalValue;

        if ( labeledRange && ![labeledRange contains:locationDecimal] ) {
            continue;
        }

        CPTAxisLabel *newAxisLabel;
        BOOL needsNewContentLayer = NO;

        // reuse axis labels where possible--will prevent flicker when updating layers
        blankLabel.tickLocation = locationDecimal;
        CPTAxisLabel *oldAxisLabel = [oldAxisLabels member:blankLabel];

        if ( oldAxisLabel ) {
            newAxisLabel = oldAxisLabel ;
        }
        else {
            newAxisLabel              = [[CPTAxisLabel alloc] initWithText:nil textStyle:nil];
            newAxisLabel.tickLocation = locationDecimal;
            needsNewContentLayer      = YES;
        }

        newAxisLabel.rotation  = theLabelRotation;
        newAxisLabel.offset    = theLabelOffset;
        newAxisLabel.alignment = theLabelAlignment;

        if ( needsNewContentLayer || theLabelFormatterChanged ) {
            CPTTextLayer *newLabelLayer;
            if ( hasAttributedFormatter ) {
                NSAttributedString *labelString = [theLabelFormatter attributedStringForObjectValue:tickLocation withDefaultAttributes:textAttributes];
                newLabelLayer = [[CPTTextLayer alloc] initWithAttributedText:labelString];
            }
            else {
                NSString *labelString = [theLabelFormatter stringForObjectValue:tickLocation];
                newLabelLayer = [[CPTTextLayer alloc] initWithText:labelString style:theLabelTextStyle];
            }
            [oldAxisLabel.contentLayer removeFromSuperlayer];
            newAxisLabel.contentLayer = newLabelLayer;

            if ( lastLayer ) {
                [axisLabelGroup insertSublayer:newLabelLayer below:lastLayer];
            }
            else {
                [axisLabelGroup insertSublayer:newLabelLayer atIndex:[thePlotArea sublayerIndexForAxis:self layerType:CPTGraphLayerTypeAxisLabels]];
            }

           
        }

        lastLayer        = newAxisLabel.contentLayer;
        lastLayer.shadow = theShadow;

        [newAxisLabels addObject:newAxisLabel];
    
    }


    // remove old labels that are not needed any more from the layer hierarchy
    [oldAxisLabels minusSet:newAxisLabels];
    for ( CPTAxisLabel *label in oldAxisLabels ) {
        [label.contentLayer removeFromSuperlayer];
    }
   

    // do not use accessor because we've already updated the layer hierarchy
    if ( useMajorAxisLabels ) {
     
        axisLabels                 = newAxisLabels;
        self.labelFormatterChanged = NO;
    }
    else {
    
        minorTickAxisLabels             = newAxisLabels;
        self.minorLabelFormatterChanged = NO;
    }

    if ( useMajorAxisLabels ) {
        [self updateMajorTickLabels];
    }
    else {
        [self updateMinorTickLabels];
    }
}

/// @endcond

/**
 *  @brief Marks the receiver as needing to update the labels before the content is next drawn.
 **/
-(void)setNeedsRelabel
{
    self.needsRelabel = YES;
}

/**
 *  @brief Updates the axis labels.
 **/
-(void)relabel
{
    if ( !self.needsRelabel ) {
        return;
    }
    if ( !self.plotSpace ) {
        return;
    }
    if ( [self.delegate respondsToSelector:@selector(axisShouldRelabel:)] && ![self.delegate axisShouldRelabel:self] ) {
        self.needsRelabel = NO;
        return;
    }

    NSSet *newMajorLocations = nil;
    NSSet *newMinorLocations = nil;

    switch ( self.labelingPolicy ) {
        case CPTAxisLabelingPolicyNone:
        case CPTAxisLabelingPolicyLocationsProvided:
            // Locations are set by user
            break;

        case CPTAxisLabelingPolicyFixedInterval:
            [self generateFixedIntervalMajorTickLocations:&newMajorLocations minorTickLocations:&newMinorLocations];
            break;

        case CPTAxisLabelingPolicyAutomatic:
            [self autoGenerateMajorTickLocations:&newMajorLocations minorTickLocations:&newMinorLocations];
            break;

        case CPTAxisLabelingPolicyEqualDivisions:
            [self generateEqualMajorTickLocations:&newMajorLocations minorTickLocations:&newMinorLocations];
            break;
    }

    switch ( self.labelingPolicy ) {
        case CPTAxisLabelingPolicyNone:
        case CPTAxisLabelingPolicyLocationsProvided:
            // Locations are set by user--no filtering required
            break;

        default:
            // Filter and set tick locations
            self.majorTickLocations = [self filteredMajorTickLocations:newMajorLocations];
            self.minorTickLocations = [self filteredMinorTickLocations:newMinorLocations];
    }

    // Label ticks
    switch ( self.labelingPolicy ) {
        case CPTAxisLabelingPolicyNone:
            [self updateCustomTickLabels];
            break;

        case CPTAxisLabelingPolicyLocationsProvided:
        {
            CPTMutablePlotRange *labeledRange = [[self.plotSpace plotRangeForCoordinate:self.coordinate] mutableCopy];
            CPTPlotRange *theVisibleRange     = self.visibleRange;
            if ( theVisibleRange ) {
                [labeledRange intersectionPlotRange:theVisibleRange];
            }

            [self updateAxisLabelsAtLocations:self.majorTickLocations
                                      inRange:labeledRange
                           useMajorAxisLabels:YES];

            [self updateAxisLabelsAtLocations:self.minorTickLocations
                                      inRange:labeledRange
                           useMajorAxisLabels:NO];
      
        }
        break;

        default:
            [self updateAxisLabelsAtLocations:self.majorTickLocations
                                      inRange:nil
                           useMajorAxisLabels:YES];

            [self updateAxisLabelsAtLocations:self.minorTickLocations
                                      inRange:nil
                           useMajorAxisLabels:NO];
            break;
    }

    self.needsRelabel = NO;
    if ( self.alternatingBandFills.count > 0 ) {
        [self.plotArea setNeedsDisplay];
    }

    if ( [self.delegate respondsToSelector:@selector(axisDidRelabel:)] ) {
        [self.delegate axisDidRelabel:self];
    }
}

/// @cond

/**
 *  @internal
 *  @brief Updates the position of all custom labels, hiding the ones that are outside the visible range.
 */
-(void)updateCustomTickLabels
{
    CPTMutablePlotRange *range = [[self.plotSpace plotRangeForCoordinate:self.coordinate] mutableCopy];

    if ( range ) {
        CPTPlotRange *theVisibleRange = self.visibleRange;
        if ( theVisibleRange ) {
            [range intersectionPlotRange:theVisibleRange];
        }

        if ( range.lengthDouble != 0.0 ) {
            CPTCoordinate orthogonalCoordinate = CPTOrthogonalCoordinate(self.coordinate);
            CPTSign direction                  = self.tickDirection;

            for ( CPTAxisLabel *label in self.axisLabels ) {
                BOOL visible = [range contains:label.tickLocation];
                label.contentLayer.hidden = !visible;
                if ( visible ) {
                    CGPoint tickBasePoint = [self viewPointForCoordinateDecimalNumber:label.tickLocation];
                    [label positionRelativeToViewPoint:tickBasePoint forCoordinate:orthogonalCoordinate inDirection:direction];
                }
            }

            for ( CPTAxisLabel *label in self.minorTickAxisLabels ) {
                BOOL visible = [range contains:label.tickLocation];
                label.contentLayer.hidden = !visible;
                if ( visible ) {
                    CGPoint tickBasePoint = [self viewPointForCoordinateDecimalNumber:label.tickLocation];
                    [label positionRelativeToViewPoint:tickBasePoint forCoordinate:orthogonalCoordinate inDirection:direction];
                }
            }
        }

    }
}

-(void)updateMajorTickLabelOffsets
{
    CPTSign direction      = self.tickDirection;
    CPTSign labelDirection = self.tickLabelDirection;

    if ( labelDirection == CPTSignNone ) {
        labelDirection = direction;
    }

    CGFloat majorOffset = self.labelOffset;

    if ( (direction == CPTSignNone) || (labelDirection == direction) ) {
        majorOffset += self.tickOffset;
    }

    for ( CPTAxisLabel *label in self.axisLabels ) {
        label.offset = majorOffset;
    }
}

-(void)updateMinorTickLabelOffsets
{
    CPTSign direction      = self.tickDirection;
    CPTSign labelDirection = self.minorTickLabelDirection;

    if ( labelDirection == CPTSignNone ) {
        labelDirection = direction;
    }

    CGFloat minorOffset = self.minorTickLabelOffset;

    if ( (direction == CPTSignNone) || (labelDirection == direction) ) {
        minorOffset += self.tickOffset;
    }

    for ( CPTAxisLabel *label in self.minorTickAxisLabels ) {
        label.offset = minorOffset;
    }
}

/// @endcond

/**
 *  @brief Update the major tick mark labels.
 **/
-(void)updateMajorTickLabels
{
    CPTCoordinate orthogonalCoordinate = CPTOrthogonalCoordinate(self.coordinate);

    CPTSign direction = self.tickLabelDirection;

    if ( direction == CPTSignNone ) {
        direction = self.tickDirection;
    }

    for ( CPTAxisLabel *label in self.axisLabels ) {
        CGPoint tickBasePoint = [self viewPointForCoordinateDecimalNumber:label.tickLocation];
        [label positionRelativeToViewPoint:tickBasePoint forCoordinate:orthogonalCoordinate inDirection:direction];
    }
}

/**
 *  @brief Update the minor tick mark labels.
 **/
-(void)updateMinorTickLabels
{
    CPTCoordinate orthogonalCoordinate = CPTOrthogonalCoordinate(self.coordinate);

    CPTSign direction = self.minorTickLabelDirection;

    if ( direction == CPTSignNone ) {
        direction = self.tickDirection;
    }

    for ( CPTAxisLabel *label in self.minorTickAxisLabels ) {
        CGPoint tickBasePoint = [self viewPointForCoordinateDecimalNumber:label.tickLocation];
        [label positionRelativeToViewPoint:tickBasePoint forCoordinate:orthogonalCoordinate inDirection:direction];
    }
}

#pragma mark -
#pragma mark Titles

-(NSDecimal)defaultTitleLocation
{
    return CPTDecimalNaN();
}

/**
 *  @brief Update the axis title position.
 **/
-(void)updateAxisTitle
{
    [self.axisTitle positionRelativeToViewPoint:[self viewPointForCoordinateDecimalNumber:self.titleLocation]
                                  forCoordinate:CPTOrthogonalCoordinate(self.coordinate)
                                    inDirection:self.tickDirection];
}

#pragma mark -
#pragma mark Layout

/// @name Layout
/// @{

/**
 *  @brief Updates the layout of all sublayers. The axes are relabeled if needed and all axis labels are repositioned.
 *
 *  This is where we do our custom replacement for the Mac-only layout manager and autoresizing mask.
 *  Subclasses should override this method to provide a different layout of their own sublayers.
 **/
-(void)layoutSublayers
{
    if ( self.needsRelabel ) {
        [self relabel];
    }
    else {
        [self updateMajorTickLabels];
        [self updateMinorTickLabels];
    }
    [self updateAxisTitle];
}

/// @}

#pragma mark -
#pragma mark Background Bands

/** @brief Add a background limit band.
 *  @param limitBand The new limit band.
 **/
-(void)addBackgroundLimitBand:(CPTLimitBand *)limitBand
{
    if ( limitBand ) {
        if ( !self.mutableBackgroundLimitBands ) {
            self.mutableBackgroundLimitBands = [NSMutableArray array];
        }

        [self.mutableBackgroundLimitBands addObject:limitBand];
        [self.plotArea setNeedsDisplay];
    }
}

/** @brief Remove a background limit band.
 *  @param limitBand The limit band to be removed.
 **/
-(void)removeBackgroundLimitBand:(CPTLimitBand *)limitBand
{
    if ( limitBand ) {
        [self.mutableBackgroundLimitBands removeObject:limitBand];
        [self.plotArea setNeedsDisplay];
    }
}

#pragma mark -
#pragma mark Responder Chain and User interaction

/// @name User Interaction
/// @{

/**
 *  @brief Informs the receiver that the user has
 *  @if MacOnly pressed the mouse button. @endif
 *  @if iOSOnly touched the screen. @endif
 *
 *
 *  If this axis has a delegate that responds to the
 *  @link CPTAxisDelegate::axis:labelWasSelected: -axis:labelWasSelected: @endlink and/or
 *  @link CPTAxisDelegate::axis:labelWasSelected:withEvent: -axis:labelWasSelected:withEvent: @endlink
 *  methods, the axis labels are searched to find the one containing the @par{interactionPoint}.
 *  The delegate method will be called and this method returns @YES if the @par{interactionPoint} is within a label.
 *
 *  If this axis has a delegate that responds to the
 *  @link CPTAxisDelegate::axis:minorTickLabelWasSelected: -axis:minorTickLabelWasSelected: @endlink and/or
 *  @link CPTAxisDelegate::axis:minorTickLabelWasSelected:withEvent: -axis:minorTickLabelWasSelected:withEvent: @endlink
 *  methods, the minor tick axis labels are searched to find the one containing the @par{interactionPoint}.
 *  The delegate method will be called and this method returns @YES if the @par{interactionPoint} is within a label.
 *
 *  This method returns @NO if the @par{interactionPoint} is outside all of the labels.
 *
 *  @param event The OS event.
 *  @param interactionPoint The coordinates of the interaction.
 *  @return Whether the event was handled or not.
 **/
-(BOOL)pointingDeviceDownEvent:(CPTNativeEvent *)event atPoint:(CGPoint)interactionPoint
{
    CPTGraph *theGraph = self.graph;

    if ( !theGraph || self.hidden ) {
        return NO;
    }

    id<CPTAxisDelegate> theDelegate = self.delegate;

    // Tick labels
    if ( [theDelegate respondsToSelector:@selector(axis:labelWasSelected:)] ||
         [theDelegate respondsToSelector:@selector(axis:labelWasSelected:withEvent:)] ) {
        for ( CPTAxisLabel *label in self.axisLabels ) {
            CPTLayer *contentLayer = label.contentLayer;
            if ( contentLayer && !contentLayer.hidden ) {
                CGPoint labelPoint = [theGraph convertPoint:interactionPoint toLayer:contentLayer];

                if ( CGRectContainsPoint(contentLayer.bounds, labelPoint) ) {
                    if ( [theDelegate respondsToSelector:@selector(axis:labelWasSelected:)] ) {
                        [theDelegate axis:self labelWasSelected:label];
                    }
                    if ( [theDelegate respondsToSelector:@selector(axis:labelWasSelected:withEvent:)] ) {
                        [theDelegate axis:self labelWasSelected:label withEvent:event];
                    }
                    return YES;
                }
            }
        }
    }

    // Minor tick labels
    if ( [theDelegate respondsToSelector:@selector(axis:minorTickLabelWasSelected:)] ||
         [theDelegate respondsToSelector:@selector(axis:minorTickLabelWasSelected:withEvent:)] ) {
        for ( CPTAxisLabel *label in self.minorTickAxisLabels ) {
            CPTLayer *contentLayer = label.contentLayer;
            if ( contentLayer && !contentLayer.hidden ) {
                CGPoint labelPoint = [theGraph convertPoint:interactionPoint toLayer:contentLayer];

                if ( CGRectContainsPoint(contentLayer.bounds, labelPoint) ) {
                    if ( [theDelegate respondsToSelector:@selector(axis:minorTickLabelWasSelected:)] ) {
                        [theDelegate axis:self minorTickLabelWasSelected:label];
                    }
                    if ( [theDelegate respondsToSelector:@selector(axis:minorTickLabelWasSelected:withEvent:)] ) {
                        [theDelegate axis:self minorTickLabelWasSelected:label withEvent:event];
                    }
                    return YES;
                }
            }
        }
    }

    return [super pointingDeviceDownEvent:event atPoint:interactionPoint];
}

/// @}

#pragma mark -
#pragma mark Accessors

/// @cond

-(void)setAxisLabels:(NSSet *)newLabels
{
    if ( newLabels != axisLabels ) {
        for ( CPTAxisLabel *label in axisLabels ) {
            [label.contentLayer removeFromSuperlayer];
        }


        axisLabels = newLabels;

        [self.plotArea updateAxisSetLayersForType:CPTGraphLayerTypeAxisLabels];

        if ( axisLabels ) {
            CPTAxisLabelGroup *axisLabelGroup = self.plotArea.axisLabelGroup;
            CALayer *lastLayer                = nil;

            for ( CPTAxisLabel *label in axisLabels ) {
                CPTLayer *contentLayer = label.contentLayer;
                if ( contentLayer ) {
                    if ( lastLayer ) {
                        [axisLabelGroup insertSublayer:contentLayer below:lastLayer];
                    }
                    else {
                        [axisLabelGroup insertSublayer:contentLayer atIndex:[self.plotArea sublayerIndexForAxis:self layerType:CPTGraphLayerTypeAxisLabels]];
                    }

                    lastLayer = contentLayer;
                }
            }
        }

        [self updateMajorTickLabels];
    }
}

-(void)setMinorTickAxisLabels:(NSSet *)newLabels
{
    if ( newLabels != minorTickAxisLabels ) {
        for ( CPTAxisLabel *label in minorTickAxisLabels ) {
            [label.contentLayer removeFromSuperlayer];
        }


        minorTickAxisLabels = newLabels;

        [self.plotArea updateAxisSetLayersForType:CPTGraphLayerTypeAxisLabels];

        if ( minorTickAxisLabels ) {
            CPTAxisLabelGroup *axisLabelGroup = self.plotArea.axisLabelGroup;
            CALayer *lastLayer                = nil;

            for ( CPTAxisLabel *label in minorTickAxisLabels ) {
                CPTLayer *contentLayer = label.contentLayer;
                if ( contentLayer ) {
                    if ( lastLayer ) {
                        [axisLabelGroup insertSublayer:contentLayer below:lastLayer];
                    }
                    else {
                        [axisLabelGroup insertSublayer:contentLayer atIndex:[self.plotArea sublayerIndexForAxis:self layerType:CPTGraphLayerTypeAxisLabels]];
                    }

                    lastLayer = contentLayer;
                }
            }
        }

        [self updateMinorTickLabels];
    }
}

-(void)setLabelTextStyle:(CPTTextStyle *)newStyle
{
    if ( newStyle != labelTextStyle ) {
      
        labelTextStyle = [newStyle copy];

        Class textLayerClass = [CPTTextLayer class];
        for ( CPTAxisLabel *axisLabel in self.axisLabels ) {
            CPTLayer *contentLayer = axisLabel.contentLayer;
            if ( [contentLayer isKindOfClass:textLayerClass] ) {
                [(CPTTextLayer *)contentLayer setTextStyle : labelTextStyle];
            }
        }

        [self updateMajorTickLabels];
    }
}

-(void)setMinorTickLabelTextStyle:(CPTTextStyle *)newStyle
{
    if ( newStyle != minorTickLabelTextStyle ) {
  
        minorTickLabelTextStyle = [newStyle copy];

        Class textLayerClass = [CPTTextLayer class];
        for ( CPTAxisLabel *axisLabel in self.minorTickAxisLabels ) {
            CPTLayer *contentLayer = axisLabel.contentLayer;
            if ( [contentLayer isKindOfClass:textLayerClass] ) {
                [(CPTTextLayer *)contentLayer setTextStyle : minorTickLabelTextStyle];
            }
        }

        [self updateMinorTickLabels];
    }
}

-(void)setAxisTitle:(CPTAxisTitle *)newTitle
{
    if ( newTitle != axisTitle ) {
        [axisTitle.contentLayer removeFromSuperlayer];
  
        axisTitle = newTitle ;

        [self.plotArea updateAxisSetLayersForType:CPTGraphLayerTypeAxisTitles];

        if ( axisTitle ) {
            axisTitle.offset = self.titleOffset;
            CPTLayer *contentLayer = axisTitle.contentLayer;
            if ( contentLayer ) {
                [self.plotArea.axisTitleGroup insertSublayer:contentLayer atIndex:[self.plotArea sublayerIndexForAxis:self layerType:CPTGraphLayerTypeAxisTitles]];
                [self updateAxisTitle];
            }
        }
    }
}

-(CPTAxisTitle *)axisTitle
{
    if ( !axisTitle ) {
        CPTAxisTitle *newTitle = nil;

        if ( attributedTitle ) {
            CPTTextLayer *textLayer = [[CPTTextLayer alloc] initWithAttributedText:attributedTitle];
            newTitle = [[CPTAxisTitle alloc] initWithContentLayer:textLayer];
       
        }
        else if ( title ) {
            newTitle = [[CPTAxisTitle alloc] initWithText:title textStyle:self.titleTextStyle];
        }

        if ( newTitle ) {
            newTitle.rotation = self.titleRotation;
            self.axisTitle    = newTitle;
       
        }
    }
    return axisTitle;
}

-(void)setTitleTextStyle:(CPTTextStyle *)newStyle
{
    if ( newStyle != titleTextStyle ) {
      
        titleTextStyle = [newStyle copy];

      
        attributedTitle = nil;

        CPTLayer *contentLayer = self.axisTitle.contentLayer;
        if ( [contentLayer isKindOfClass:[CPTTextLayer class]] ) {
            ( (CPTTextLayer *)contentLayer ).textStyle = titleTextStyle;
            [self updateAxisTitle];
        }
    }
}

-(void)setTitleOffset:(CGFloat)newOffset
{
    if ( newOffset != titleOffset ) {
        titleOffset           = newOffset;
        self.axisTitle.offset = titleOffset;
        [self updateAxisTitle];
    }
}

-(void)setTitleRotation:(CGFloat)newRotation
{
    if ( newRotation != titleRotation ) {
        titleRotation           = newRotation;
        self.axisTitle.rotation = titleRotation;
        [self updateAxisTitle];
    }
}

-(void)setTitle:(NSString *)newTitle
{
    if ( newTitle != title ) {

        title = [newTitle copy];
        if ( title == nil ) {
            self.axisTitle = nil;
        }

     
        attributedTitle = nil;

        CPTLayer *contentLayer = self.axisTitle.contentLayer;
        if ( [contentLayer isKindOfClass:[CPTTextLayer class]] ) {
            ( (CPTTextLayer *)contentLayer ).text = title;
            [self updateAxisTitle];
        }
    }
}

-(void)setAttributedTitle:(NSAttributedString *)newTitle
{
    if ( newTitle != attributedTitle ) {
      
        attributedTitle = [newTitle copy];

  

        if ( attributedTitle ) {
            titleTextStyle = [CPTTextStyle textStyleWithAttributes:[attributedTitle attributesAtIndex:0
                                                                                        effectiveRange:NULL]] ;
            title = [attributedTitle.string copy];
        }
        else {
            titleTextStyle = nil;
            title          = nil;

            self.axisTitle = nil;
        }

        CPTLayer *contentLayer = self.axisTitle.contentLayer;
        if ( [contentLayer isKindOfClass:[CPTTextLayer class]] ) {
            ( (CPTTextLayer *)contentLayer ).attributedText = attributedTitle;
            [self updateAxisTitle];
        }
    }
}

-(void)setTitleLocation:(NSDecimal)newLocation
{
    if ( NSDecimalCompare(&newLocation, &titleLocation) != NSOrderedSame ) {
        titleLocation = newLocation;
        [self updateAxisTitle];
    }
}

-(NSDecimal)titleLocation
{
    if ( NSDecimalIsNotANumber(&titleLocation) ) {
        return self.defaultTitleLocation;
    }
    else {
        return titleLocation;
    }
}

-(void)setLabelExclusionRanges:(NSArray *)ranges
{
    if ( ranges != labelExclusionRanges ) {
    
        labelExclusionRanges = ranges ;
        self.needsRelabel    = YES;
    }
}

-(void)setNeedsRelabel:(BOOL)newNeedsRelabel
{
    if ( newNeedsRelabel != needsRelabel ) {
        needsRelabel = newNeedsRelabel;
        if ( needsRelabel ) {
            [self setNeedsDisplay];
            if ( self.separateLayers ) {
                [self.majorGridLines setNeedsDisplay];
                [self.minorGridLines setNeedsDisplay];
            }
            else {
                CPTPlotArea *thePlotArea = self.plotArea;
                [thePlotArea.majorGridLineGroup setNeedsDisplay];
                [thePlotArea.minorGridLineGroup setNeedsDisplay];
            }
        }
    }
}

-(void)setMajorTickLocations:(NSSet *)newLocations
{
    if ( newLocations != majorTickLocations ) {
 
        majorTickLocations = newLocations ;
        if ( self.separateLayers ) {
            [self.majorGridLines setNeedsDisplay];
        }
        else {
            [self.plotArea.majorGridLineGroup setNeedsDisplay];
        }

        self.needsRelabel = YES;
    }
}

-(void)setMinorTickLocations:(NSSet *)newLocations
{
    if ( newLocations != minorTickLocations ) {
   
        minorTickLocations = newLocations ;
        if ( self.separateLayers ) {
            [self.minorGridLines setNeedsDisplay];
        }
        else {
            [self.plotArea.minorGridLineGroup setNeedsDisplay];
        }

        self.needsRelabel = YES;
    }
}

-(void)setMajorTickLength:(CGFloat)newLength
{
    if ( newLength != majorTickLength ) {
        majorTickLength = newLength;

        [self updateMajorTickLabelOffsets];
        [self updateMinorTickLabelOffsets];

        [self setNeedsDisplay];
        [self updateMajorTickLabels];
        [self updateMinorTickLabels];
    }
}

-(void)setMinorTickLength:(CGFloat)newLength
{
    if ( newLength != minorTickLength ) {
        minorTickLength = newLength;
        [self setNeedsDisplay];
    }
}

-(void)setLabelOffset:(CGFloat)newOffset
{
    if ( newOffset != labelOffset ) {
        labelOffset = newOffset;

        [self updateMajorTickLabelOffsets];
        [self updateMajorTickLabels];
    }
}

-(void)setMinorTickLabelOffset:(CGFloat)newOffset
{
    if ( newOffset != minorTickLabelOffset ) {
        minorTickLabelOffset = newOffset;

        [self updateMinorTickLabelOffsets];
        [self updateMinorTickLabels];
    }
}

-(void)setLabelRotation:(CGFloat)newRotation
{
    if ( newRotation != labelRotation ) {
        labelRotation = newRotation;
        for ( CPTAxisLabel *label in self.axisLabels ) {
            label.rotation = labelRotation;
        }
        [self updateMajorTickLabels];
    }
}

-(void)setMinorTickLabelRotation:(CGFloat)newRotation
{
    if ( newRotation != minorTickLabelRotation ) {
        minorTickLabelRotation = newRotation;
        for ( CPTAxisLabel *label in self.minorTickAxisLabels ) {
            label.rotation = minorTickLabelRotation;
        }
        [self updateMinorTickLabels];
    }
}

-(void)setLabelAlignment:(CPTAlignment)newAlignment
{
    if ( newAlignment != labelAlignment ) {
        labelAlignment = newAlignment;
        [self updateMajorTickLabels];
    }
}

-(void)setMinorTickLabelAlignment:(CPTAlignment)newAlignment
{
    if ( newAlignment != minorTickLabelAlignment ) {
        minorTickLabelAlignment = newAlignment;
        [self updateMinorTickLabels];
    }
}

-(void)setLabelShadow:(CPTShadow *)newLabelShadow
{
    if ( newLabelShadow != labelShadow ) {
     
        labelShadow = newLabelShadow ;
        for ( CPTAxisLabel *label in self.axisLabels ) {
            label.contentLayer.shadow = labelShadow;
        }
        [self updateMajorTickLabels];
    }
}

-(void)setMinorTickLabelShadow:(CPTShadow *)newLabelShadow
{
    if ( newLabelShadow != minorTickLabelShadow ) {
     
        minorTickLabelShadow = newLabelShadow ;
        for ( CPTAxisLabel *label in self.minorTickAxisLabels ) {
            label.contentLayer.shadow = minorTickLabelShadow;
        }
        [self updateMinorTickLabels];
    }
}

-(void)setPlotSpace:(CPTPlotSpace *)newSpace
{
    if ( newSpace != plotSpace ) {
    
        plotSpace         = newSpace ;
        self.needsRelabel = YES;
    }
}

-(void)setCoordinate:(CPTCoordinate)newCoordinate
{
    if ( newCoordinate != coordinate ) {
        coordinate        = newCoordinate;
        self.needsRelabel = YES;
    }
}

-(void)setAxisLineStyle:(CPTLineStyle *)newLineStyle
{
    if ( newLineStyle != axisLineStyle ) {
     
        axisLineStyle = [newLineStyle copy];
        [self setNeedsDisplay];
    }
}

-(void)setMajorTickLineStyle:(CPTLineStyle *)newLineStyle
{
    if ( newLineStyle != majorTickLineStyle ) {
       
        majorTickLineStyle = [newLineStyle copy];
        [self setNeedsDisplay];
    }
}

-(void)setMinorTickLineStyle:(CPTLineStyle *)newLineStyle
{
    if ( newLineStyle != minorTickLineStyle ) {
    
        minorTickLineStyle = [newLineStyle copy];
        [self setNeedsDisplay];
    }
}

-(void)setMajorGridLineStyle:(CPTLineStyle *)newLineStyle
{
    if ( newLineStyle != majorGridLineStyle ) {
     
        majorGridLineStyle = [newLineStyle copy];

        [self.plotArea updateAxisSetLayersForType:CPTGraphLayerTypeMajorGridLines];

        if ( majorGridLineStyle ) {
            if ( self.separateLayers ) {
                if ( !self.majorGridLines ) {
                    CPTGridLines *gridLines = [[CPTGridLines alloc] init];
                    self.majorGridLines = gridLines;
                  
                }
                else {
                    [self.majorGridLines setNeedsDisplay];
                }
            }
            else {
                [self.plotArea.majorGridLineGroup setNeedsDisplay];
            }
        }
        else {
            self.majorGridLines = nil;
        }
    }
}

-(void)setMinorGridLineStyle:(CPTLineStyle *)newLineStyle
{
    if ( newLineStyle != minorGridLineStyle ) {
   
        minorGridLineStyle = [newLineStyle copy];

        [self.plotArea updateAxisSetLayersForType:CPTGraphLayerTypeMinorGridLines];

        if ( minorGridLineStyle ) {
            if ( self.separateLayers ) {
                if ( !self.minorGridLines ) {
                    CPTGridLines *gridLines = [[CPTGridLines alloc] init];
                    self.minorGridLines = gridLines;
                 
                }
                else {
                    [self.minorGridLines setNeedsDisplay];
                }
            }
            else {
                [self.plotArea.minorGridLineGroup setNeedsDisplay];
            }
        }
        else {
            self.minorGridLines = nil;
        }
    }
}

-(void)setAxisLineCapMin:(CPTLineCap *)newAxisLineCapMin
{
    if ( newAxisLineCapMin != axisLineCapMin ) {
    
        axisLineCapMin = [newAxisLineCapMin copy];
        [self setNeedsDisplay];
    }
}

-(void)setAxisLineCapMax:(CPTLineCap *)newAxisLineCapMax
{
    if ( newAxisLineCapMax != axisLineCapMax ) {
   
        axisLineCapMax = [newAxisLineCapMax copy];
        [self setNeedsDisplay];
    }
}

-(void)setLabelingOrigin:(NSDecimal)newLabelingOrigin
{
    if ( CPTDecimalEquals(labelingOrigin, newLabelingOrigin) ) {
        return;
    }
    labelingOrigin    = newLabelingOrigin;
    self.needsRelabel = YES;
}

-(void)setMajorIntervalLength:(NSDecimal)newIntervalLength
{
    if ( CPTDecimalEquals(majorIntervalLength, newIntervalLength) ) {
        return;
    }
    majorIntervalLength = newIntervalLength;
    self.needsRelabel   = YES;
}

-(void)setMinorTicksPerInterval:(NSUInteger)newMinorTicksPerInterval
{
    if ( newMinorTicksPerInterval != minorTicksPerInterval ) {
        minorTicksPerInterval = newMinorTicksPerInterval;
        self.needsRelabel     = YES;
    }
}

-(void)setLabelingPolicy:(CPTAxisLabelingPolicy)newPolicy
{
    if ( newPolicy != labelingPolicy ) {
        labelingPolicy    = newPolicy;
        self.needsRelabel = YES;
    }
}

-(void)setPreferredNumberOfMajorTicks:(NSUInteger)newPreferredNumberOfMajorTicks
{
    if ( newPreferredNumberOfMajorTicks != preferredNumberOfMajorTicks ) {
        preferredNumberOfMajorTicks = newPreferredNumberOfMajorTicks;
        if ( self.labelingPolicy == CPTAxisLabelingPolicyAutomatic ) {
            self.needsRelabel = YES;
        }
    }
}

-(void)setLabelFormatter:(NSFormatter *)newTickLabelFormatter
{
    if ( newTickLabelFormatter != labelFormatter ) {
 
        labelFormatter             = newTickLabelFormatter ;
        self.labelFormatterChanged = YES;
        self.needsRelabel          = YES;
    }
}

-(void)setMinorTickLabelFormatter:(NSFormatter *)newMinorTickLabelFormatter
{
    if ( newMinorTickLabelFormatter != minorTickLabelFormatter ) {
       
        minorTickLabelFormatter = newMinorTickLabelFormatter ;
        if ( !newMinorTickLabelFormatter ) {
            for ( CPTAxisLabel *label in self.minorTickAxisLabels ) {
                [label.contentLayer removeFromSuperlayer];
            }
          
            minorTickAxisLabels = [NSSet set] ;
        }
        self.minorLabelFormatterChanged = YES;
        self.needsRelabel               = YES;
    }
}

-(void)setTickDirection:(CPTSign)newDirection
{
    if ( newDirection != tickDirection ) {
        tickDirection = newDirection;

        [self updateMajorTickLabelOffsets];
        [self updateMinorTickLabelOffsets];

        [self setNeedsDisplay];
        [self updateMajorTickLabels];
        [self updateMinorTickLabels];
    }
}

-(void)setTickLabelDirection:(CPTSign)newDirection
{
    if ( newDirection != tickLabelDirection ) {
        tickLabelDirection = newDirection;

        [self updateMajorTickLabelOffsets];
        [self updateMajorTickLabels];
    }
}

-(void)setMinorTickLabelDirection:(CPTSign)newDirection
{
    if ( newDirection != minorTickLabelDirection ) {
        minorTickLabelDirection = newDirection;

        [self updateMinorTickLabelOffsets];
        [self updateMinorTickLabels];
    }
}

-(void)setGridLinesRange:(CPTPlotRange *)newRange
{
    if ( newRange != gridLinesRange ) {
   
        gridLinesRange = [newRange copy];
        if ( self.separateLayers ) {
            [self.minorGridLines setNeedsDisplay];
            [self.majorGridLines setNeedsDisplay];
        }
        else {
            [self.plotArea.minorGridLineGroup setNeedsDisplay];
            [self.plotArea.majorGridLineGroup setNeedsDisplay];
        }
    }
}

-(void)setPlotArea:(CPTPlotArea *)newPlotArea
{
    if ( newPlotArea != plotArea ) {
        plotArea = newPlotArea;

        if ( plotArea ) {
            [plotArea updateAxisSetLayersForType:CPTGraphLayerTypeMinorGridLines];
            CPTGridLines *gridLines = self.minorGridLines;
            if ( gridLines ) {
                [gridLines removeFromSuperlayer];
                [plotArea.minorGridLineGroup insertSublayer:gridLines atIndex:[plotArea sublayerIndexForAxis:self layerType:CPTGraphLayerTypeMinorGridLines]];
            }

            [plotArea updateAxisSetLayersForType:CPTGraphLayerTypeMajorGridLines];
            gridLines = self.majorGridLines;
            if ( gridLines ) {
                [gridLines removeFromSuperlayer];
                [plotArea.majorGridLineGroup insertSublayer:gridLines atIndex:[plotArea sublayerIndexForAxis:self layerType:CPTGraphLayerTypeMajorGridLines]];
            }

            [plotArea updateAxisSetLayersForType:CPTGraphLayerTypeAxisLabels];
            if ( self.axisLabels.count > 0 ) {
                CPTAxisLabelGroup *axisLabelGroup = self.plotArea.axisLabelGroup;
                CALayer *lastLayer                = nil;

                for ( CPTAxisLabel *label in self.axisLabels ) {
                    CPTLayer *contentLayer = label.contentLayer;
                    if ( contentLayer ) {
                        [contentLayer removeFromSuperlayer];

                        if ( lastLayer ) {
                            [axisLabelGroup insertSublayer:contentLayer below:lastLayer];
                        }
                        else {
                            [axisLabelGroup insertSublayer:contentLayer atIndex:[self.plotArea sublayerIndexForAxis:self layerType:CPTGraphLayerTypeAxisLabels]];
                        }

                        lastLayer = contentLayer;
                    }
                }
            }

            if ( self.minorTickAxisLabels.count > 0 ) {
                CPTAxisLabelGroup *axisLabelGroup = self.plotArea.axisLabelGroup;
                CALayer *lastLayer                = nil;

                for ( CPTAxisLabel *label in self.minorTickAxisLabels ) {
                    CPTLayer *contentLayer = label.contentLayer;
                    if ( contentLayer ) {
                        [contentLayer removeFromSuperlayer];

                        if ( lastLayer ) {
                            [axisLabelGroup insertSublayer:contentLayer below:lastLayer];
                        }
                        else {
                            [axisLabelGroup insertSublayer:contentLayer atIndex:[self.plotArea sublayerIndexForAxis:self layerType:CPTGraphLayerTypeAxisLabels]];
                        }

                        lastLayer = contentLayer;
                    }
                }
            }

            [plotArea updateAxisSetLayersForType:CPTGraphLayerTypeAxisTitles];
            CPTLayer *content = self.axisTitle.contentLayer;
            if ( content ) {
                [content removeFromSuperlayer];
                [plotArea.axisTitleGroup insertSublayer:content atIndex:[plotArea sublayerIndexForAxis:self layerType:CPTGraphLayerTypeAxisTitles]];
            }
        }
        else {
            [self.minorGridLines removeFromSuperlayer];
            [self.majorGridLines removeFromSuperlayer];
            for ( CPTAxisLabel *label in self.axisLabels ) {
                [label.contentLayer removeFromSuperlayer];
            }
            [self.axisTitle.contentLayer removeFromSuperlayer];
        }
    }
}

-(void)setVisibleRange:(CPTPlotRange *)newRange
{
    if ( newRange != visibleRange ) {
    
        visibleRange      = [newRange copy];
        self.needsRelabel = YES;
    }
}

-(void)setVisibleAxisRange:(CPTPlotRange *)newRange
{
    if ( newRange != visibleAxisRange ) {
    
        visibleAxisRange  = [newRange copy];
        self.needsRelabel = YES;
    }
}

-(void)setSeparateLayers:(BOOL)newSeparateLayers
{
    if ( newSeparateLayers != separateLayers ) {
        separateLayers = newSeparateLayers;
        if ( separateLayers ) {
            if ( self.minorGridLineStyle ) {
                CPTGridLines *gridLines = [[CPTGridLines alloc] init];
                self.minorGridLines = gridLines;
               
            }
            if ( self.majorGridLineStyle ) {
                CPTGridLines *gridLines = [[CPTGridLines alloc] init];
                self.majorGridLines = gridLines;
               
            }
        }
        else {
            self.minorGridLines = nil;
            if ( self.minorGridLineStyle ) {
                [self.plotArea.minorGridLineGroup setNeedsDisplay];
            }
            self.majorGridLines = nil;
            if ( self.majorGridLineStyle ) {
                [self.plotArea.majorGridLineGroup setNeedsDisplay];
            }
        }
    }
}

-(void)setMinorGridLines:(CPTGridLines *)newGridLines
{
    if ( newGridLines != minorGridLines ) {
        [minorGridLines removeFromSuperlayer];
        minorGridLines = newGridLines;
        if ( minorGridLines ) {
            minorGridLines.major = NO;
            minorGridLines.axis  = self;
            [self.plotArea.minorGridLineGroup insertSublayer:minorGridLines atIndex:[self.plotArea sublayerIndexForAxis:self layerType:CPTGraphLayerTypeMinorGridLines]];
        }
    }
}

-(void)setMajorGridLines:(CPTGridLines *)newGridLines
{
    if ( newGridLines != majorGridLines ) {
        [majorGridLines removeFromSuperlayer];
        majorGridLines = newGridLines;
        if ( majorGridLines ) {
            majorGridLines.major = YES;
            majorGridLines.axis  = self;
            [self.plotArea.majorGridLineGroup insertSublayer:majorGridLines atIndex:[self.plotArea sublayerIndexForAxis:self layerType:CPTGraphLayerTypeMajorGridLines]];
        }
    }
}

-(void)setAlternatingBandFills:(NSArray *)newFills
{
    if ( newFills != alternatingBandFills ) {
      

        Class nullClass = [NSNull class];
        Class fillClass = [CPTFill class];

        BOOL convertFills = NO;
        for ( id obj in newFills ) {
            if ( [obj isKindOfClass:nullClass] || [obj isKindOfClass:fillClass] ) {
                continue;
            }
            else {
                convertFills = YES;
                break;
            }
        }

        if ( convertFills ) {
            Class colorClass    = [CPTColor class];
            Class gradientClass = [CPTGradient class];
            Class imageClass    = [CPTImage class];

            NSMutableArray *fillArray = [newFills mutableCopy];
            NSUInteger i              = 0;
            CPTFill *newFill          = nil;

            for ( id obj in newFills ) {
                if ( [obj isKindOfClass:nullClass] || [obj isKindOfClass:fillClass] ) {
                    i++;
                    continue;
                }
                else if ( [obj isKindOfClass:colorClass] ) {
                    newFill = [[CPTFill alloc] initWithColor:obj];
                }
                else if ( [obj isKindOfClass:gradientClass] ) {
                    newFill = [[CPTFill alloc] initWithGradient:obj];
                }
                else if ( [obj isKindOfClass:imageClass] ) {
                    newFill = [[CPTFill alloc] initWithImage:obj];
                }
                else {
                    [NSException raise:CPTException format:@"Alternating band fills must be one or more of the following: CPTFill, CPTColor, CPTGradient, CPTImage, or [NSNull null]."];
                }

                [fillArray replaceObjectAtIndex:i withObject:newFill];
                

                i++;
            }

            alternatingBandFills = fillArray;
        }
        else {
            alternatingBandFills = [newFills copy];
        }
        [self.plotArea setNeedsDisplay];
    }
}

-(NSArray *)backgroundLimitBands
{
    return [self.mutableBackgroundLimitBands copy] ;
}

-(CPTAxisSet *)axisSet
{
    return self.plotArea.axisSet;
}

-(void)setHidden:(BOOL)newHidden
{
    if ( newHidden != self.hidden ) {
        [super setHidden:newHidden];
        [self setNeedsRelabel];
    }
}

/// @endcond

@end

#pragma mark -

@implementation CPTAxis(AbstractMethods)

/** @brief Converts a position on the axis to drawing coordinates.
 *  @param coordinateDecimalNumber The axis value in data coordinate space.
 *  @return The drawing coordinates of the point.
 **/
-(CGPoint)viewPointForCoordinateDecimalNumber:(NSDecimal)coordinateDecimalNumber
{
    return CGPointZero;
}

/** @brief Draws grid lines into the provided graphics context.
 *  @param context The graphics context to draw into.
 *  @param major Draw the major grid lines If @YES, minor grid lines otherwise.
 **/
-(void)drawGridLinesInContext:(CGContextRef)context isMajor:(BOOL)major
{
    // do nothing--subclasses must override to do their drawing
}

/** @brief Draws alternating background bands into the provided graphics context.
 *  @param context The graphics context to draw into.
 **/
-(void)drawBackgroundBandsInContext:(CGContextRef)context
{
    // do nothing--subclasses must override to do their drawing
}

/** @brief Draws background limit ranges into the provided graphics context.
 *  @param context The graphics context to draw into.
 **/
-(void)drawBackgroundLimitsInContext:(CGContextRef)context
{
    // do nothing--subclasses must override to do their drawing
}

@end
