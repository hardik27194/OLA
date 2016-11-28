#import "CPTShadow.h"

#import "CPTColor.h"
#import "CPTDefinitions.h"
#import "CPTMutableShadow.h"
#import "NSCoderExtensions.h"

/// @cond
@interface CPTShadow()

@property (nonatomic, readwrite, assign) CGSize shadowOffset;
@property (nonatomic, readwrite, assign) CGFloat shadowBlurRadius;
@property (nonatomic, readwrite, retain) CPTColor *shadowColor;

@end

/// @endcond

/** @brief Immutable wrapper for various shadow drawing properties.
 *
 *  @see See Apple&rsquo;s <a href="http://developer.apple.com/library/mac/#documentation/GraphicsImaging/Conceptual/drawingwithquartz2d/dq_shadows/dq_shadows.html">Quartz 2D</a>
 *  and <a href="http://developer.apple.com/documentation/GraphicsImaging/Reference/CGContext/Reference/reference.html">CGContext</a>
 *  documentation for more information about each of these properties.
 *
 *  In general, you will want to create a CPTMutableShadow if you want to customize properties.
 **/

@implementation CPTShadow

/** @property CGSize shadowOffset
 *  @brief The horizontal and vertical offset values, specified using the width and height fields
 *  of the @ref CGSize data type. The offsets are not affected by custom transformations. Positive values extend
 *  up and to the right. Default is (@num{0.0}, @num{0.0}).
 **/
@synthesize shadowOffset;

/** @property CGFloat shadowBlurRadius
 *  @brief The blur radius, measured in the default user coordinate space. A value of @num{0.0} (the default) indicates no blur,
 *  while larger values produce correspondingly larger blurring. This value must not be negative.
 **/
@synthesize shadowBlurRadius;

/** @property CPTColor *shadowColor
 *  @brief The shadow color. If @nil (the default), the shadow will not be drawn.
 **/
@synthesize shadowColor;

#pragma mark -
#pragma mark Init/Dealloc

/** @brief Creates and returns a new CPTShadow instance.
 *  @return A new CPTShadow instance.
 **/
+(id)shadow
{
    return [[self alloc] init] ;
}

/// @name Initialization
/// @{

/** @brief Initializes a newly allocated CPTShadow object.
 *
 *  The initialized object will have the following properties:
 *  - @ref shadowOffset = (@num{0.0}, @num{0.0})
 *  - @ref shadowBlurRadius = @num{0.0}
 *  - @ref shadowColor = @nil
 *
 *  @return The initialized object.
 **/
-(id)init
{
    if ( (self = [super init]) ) {
        shadowOffset     = CGSizeZero;
        shadowBlurRadius = CPTFloat(0.0);
        shadowColor      = nil;
    }
    return self;
}

/// @}

/// @cond

-(void)dealloc
{

}

/// @endcond

#pragma mark -
#pragma mark NSCoding Methods

/// @cond

-(void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeCPTSize:self.shadowOffset forKey:@"CPTShadow.shadowOffset"];
    [coder encodeCGFloat:self.shadowBlurRadius forKey:@"CPTShadow.shadowBlurRadius"];
    [coder encodeObject:self.shadowColor forKey:@"CPTShadow.shadowColor"];
}

-(id)initWithCoder:(NSCoder *)coder
{
    if ( (self = [super init]) ) {
        shadowOffset     = [coder decodeCPTSizeForKey:@"CPTShadow.shadowOffset"];
        shadowBlurRadius = [coder decodeCGFloatForKey:@"CPTShadow.shadowBlurRadius"];
        shadowColor      = [coder decodeObjectForKey:@"CPTShadow.shadowColor"] ;
    }
    return self;
}

/// @endcond

#pragma mark -
#pragma mark Drawing

/** @brief Sets the shadow properties in the given graphics context.
 *  @param context The graphics context.
 **/
-(void)setShadowInContext:(CGContextRef)context
{
    CGContextSetShadowWithColor(context,
                                self.shadowOffset,
                                self.shadowBlurRadius,
                                self.shadowColor.cgColor);
}

#pragma mark -
#pragma mark NSCopying Methods

/// @cond

-(id)copyWithZone:(NSZone *)zone
{
    CPTShadow *shadowCopy = [[CPTShadow allocWithZone:zone] init];

    shadowCopy->shadowOffset     = self->shadowOffset;
    shadowCopy->shadowBlurRadius = self->shadowBlurRadius;
    shadowCopy->shadowColor      = [self->shadowColor copy];

    return shadowCopy;
}

/// @endcond

#pragma mark -
#pragma mark NSMutableCopying Methods

/// @cond

-(id)mutableCopyWithZone:(NSZone *)zone
{
    CPTShadow *shadowCopy = [[CPTMutableShadow allocWithZone:zone] init];

    shadowCopy->shadowOffset     = self->shadowOffset;
    shadowCopy->shadowBlurRadius = self->shadowBlurRadius;
    shadowCopy->shadowColor      = [self->shadowColor copy];

    return shadowCopy;
}

/// @endcond

#pragma mark -
#pragma mark Accessors

/// @cond

-(void)setShadowBlurRadius:(CGFloat)newShadowBlurRadius
{
    NSParameterAssert(newShadowBlurRadius >= 0.0);

    if ( newShadowBlurRadius != shadowBlurRadius ) {
        shadowBlurRadius = newShadowBlurRadius;
    }
}

/// @endcond

@end
