#import <Foundation/Foundation.h>

#define  trim(str)  [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]

typedef struct _Bounds
{
    
}Bounds;

typedef struct  _Border
{
    CGFloat width;
    const char * color;
    CGFloat radius;
}Border;
typedef struct  _Font
{
    CGFloat size;
    const char * family;
    CGFloat style;
}Font;

typedef struct  _Margin
{
    CGFloat left, top, right, bottom;
    const char * marginLeft, *marginTop, *marginRight, *marginBottom;
    const char * margin;
}Margin;

typedef struct _Padding
{
    CGFloat left, top, right, bottom;
    const char * paddingLeft, *paddingTop, *paddingRight, *paddingBottom;
    const char * padding;
}Padding;

@interface CSS : NSObject {
    NSString *cssString;
	
	NSString *name;
	
	int bottom;
	int left;
	int right;
	int top;
    
    Border border;
    Margin margin;
    Padding padding;
    
	NSString *position;
	BOOL display;
	NSString * visibility;
	NSString *verticalAlign;
	int sIndex;
	
	
	int width;
	int height;
	int weight;
    
    float alpha;
	
	//text position
	NSString *textAlign;
	NSString *orientation;
	
	NSString * color;
	
	NSMutableDictionary * styles;
    
    NSString * backgroundImageURL;
    NSString * backgroundColor;

}


@property (nonatomic,retain)    NSString *cssString;
	
@property (nonatomic)	NSString *name;
	
@property (nonatomic)	int bottom;
@property (nonatomic)	int left;
@property (nonatomic)	int right;
@property (nonatomic)	int top;
@property (nonatomic,readonly)   Border border;
@property (nonatomic,readonly)   Margin margin;
@property (nonatomic,readonly)   Padding padding;
@property (nonatomic)	NSString *position;
@property (nonatomic)	BOOL display;
@property (nonatomic)	NSString *visibility;
@property (nonatomic)	NSString *verticalAlign;
@property (nonatomic)	int sIndex;
	
	
@property (nonatomic)	int width;
@property (nonatomic)	int height;
@property (nonatomic)	int weight;

@property (nonatomic)   float alpha;
	
	//text position
@property (nonatomic)	NSString *textAlign ;
@property (nonatomic)	NSString *orientation;
	
@property (nonatomic)	NSString * color;
	
@property (nonatomic)	NSMutableDictionary * styles;

@property (nonatomic)   NSString * backgroundImageURL;
@property (nonatomic)   NSString * backgroundColor;

- (CSS *)initWithStyles:(NSString *)cssString;
- (NSString *) getStyleValue:(NSString *)styleName;
- (void)setStyleValue:(NSString *)value forKey:(NSString*) name;
+ (UIColor *) parseColor:(NSString *)color;
+ (NSString *) colorToString:(UIColor *)color;
+ (NSString *)intToHex:(int)tmpid ;


+ (int) parseInt:(NSString *)number;
+ (NSString *)parseImageUrl:(NSString *)url;
-(void) setMargin:(NSString *) marginString;
-(Margin) getMargin;

-(void) setBorder:(NSString *) borderString;

@end