#import <Foundation/Foundation.h>
#import "CSS.h"

@implementation CSS
@synthesize cssString,name,bottom,left,right,top,position,display,visibility,verticalAlign,sIndex,width,height,weight,textAlign,orientation,color,styles;
@synthesize font,border,margin,padding,alpha;

@synthesize backgroundImageURL,backgroundColor;

- (CSS *) initWithStyles:(NSString *)cssStr
{
    self.cssString=cssStr;
    self.display=YES;
    self.visibility=@"visible";
    self.styles=[NSMutableDictionary dictionaryWithCapacity:10];
    
    textAlign=@"";
    verticalAlign=@"";
    alpha=1;
    
    //if it is equals "-1", means that the value was not set
    width=-1;
    height=-1;
    
    [self parse:cssStr];
    return self;
    
}

- (void)  parse:(NSString *)css
{
    //should use Tokennizer to parse the CSS string
    if(css==nil || [css isEqualToString:@""])return;
    NSArray *items=[css componentsSeparatedByString:@";"];
    //for(int i=0;i < items.count;i++)
    int i=0;
    for(NSString *s in items)
    {
        if(s==nil || [s compare:@""] == NSOrderedSame)continue;
        //NSRange *range=[s rangeOfString:@":"];
        //int pos=;
        //if(pos<0)continue;
        
        NSArray *pair=[s componentsSeparatedByString:@":"];
        if([pair count]<=1)continue;
        NSString *attName=trim([pair objectAtIndex:0]);
        NSString *value=trim([pair objectAtIndex:1]);
        
        [self.styles setObject:value forKey:attName];
        //styles.put(s.substring(0,pos), s.substring(pos+1));
        //System.out.println("CSS:"+s.substring(0,pos)+"="+ s.substring(pos+1));
        //parse(s.substring(0,pos), s.substring(pos+1));
        [self parse:value forKey:attName];
    }
    
}
- (BOOL) compare:(NSString *)str1 withString:(NSString *)str2
{
    return [str1 compare:str2 options:NSCaseInsensitiveSearch | NSNumericSearch] == NSOrderedSame;
}
- (void)parse:(NSString *)value forKey:(NSString *)attName
{
    if([attName caseInsensitiveCompare:@"left"]==NSOrderedSame) self.left=[CSS parseInt:value];
    else if([attName caseInsensitiveCompare:@"right"]==NSOrderedSame) self.right=[CSS parseInt:value];
    else if([attName caseInsensitiveCompare:@"top"]==NSOrderedSame) self.top=[CSS parseInt:value];
    else if([attName caseInsensitiveCompare:@"bottom"]==NSOrderedSame) self.bottom=[CSS parseInt:value];
    
    else if([attName caseInsensitiveCompare:@"border"]==NSOrderedSame) [self setBorder:value];
    else if([attName caseInsensitiveCompare:@"margin"]==NSOrderedSame) [self setMargin:value];
    else if([attName caseInsensitiveCompare:@"padding"]==NSOrderedSame) [self setPadding:value];
    else if([attName caseInsensitiveCompare:@"font"]==NSOrderedSame) [self setFont:value];
    
    else if([attName caseInsensitiveCompare:@"vertical-Align"]==NSOrderedSame || [attName caseInsensitiveCompare:@"valign"]==NSOrderedSame) self.verticalAlign=value;
    else if([attName caseInsensitiveCompare:@"text-Align"]==NSOrderedSame || [attName caseInsensitiveCompare:@"align"]==NSOrderedSame) self.textAlign=value;
    else if([attName caseInsensitiveCompare:@"text-color"]==NSOrderedSame || [attName caseInsensitiveCompare:@"color"]==NSOrderedSame) self.color=value;
    
    else if([attName caseInsensitiveCompare:@"weight"]==NSOrderedSame) self.weight=[CSS parseInt:value];
    else if([attName caseInsensitiveCompare:@"orientation"]==NSOrderedSame) self.orientation=value;
    
    else if ([attName caseInsensitiveCompare:@"visibility"]==NSOrderedSame)
    {
        visibility=value;
    }
    else if ([attName caseInsensitiveCompare:@"alpha"]==NSOrderedSame)
        alpha = [CSS parseFloat:value];
    
}

-(void) setBorder:(NSString *) borderString
{
    borderString=[borderString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    //remove reduandent space in the string
    NSCharacterSet *whitespaces = [NSCharacterSet whitespaceCharacterSet];
    NSPredicate *noEmptyStrings = [NSPredicate predicateWithFormat:@"SELF != ''"];
    
    NSArray *parts = [borderString componentsSeparatedByCharactersInSet:whitespaces];
    NSArray *filteredArray = [parts filteredArrayUsingPredicate:noEmptyStrings];
    borderString = [filteredArray componentsJoinedByString:@" "];
    
    
    NSArray *items=[borderString componentsSeparatedByString:@" "];
    border.width=[CSS parseInt:[items objectAtIndex:1]];
    border.color=[[items objectAtIndex:2] UTF8String];
    border.radius=[CSS parseInt:[items objectAtIndex:3]];
}

-(void) setFont:(NSString *) fontString
{
    fontString=[fontString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    //remove reduandent space in the string
    NSCharacterSet *whitespaces = [NSCharacterSet whitespaceCharacterSet];
    NSPredicate *noEmptyStrings = [NSPredicate predicateWithFormat:@"SELF != ''"];
    
    NSArray *parts = [fontString componentsSeparatedByCharactersInSet:whitespaces];
    NSArray *filteredArray = [parts filteredArrayUsingPredicate:noEmptyStrings];
    fontString = [filteredArray componentsJoinedByString:@" "];
    
    
    NSArray *items=[fontString componentsSeparatedByString:@" "];
    
    BOOL isBold=false;
    BOOL isItalic=false;
    NSString *family=@"Courier";
    for(NSString *s in items)
    {
        if(s==nil || [s compare:@""] == NSOrderedSame)continue;
        else if ([s caseInsensitiveCompare:@"bold"]==NSOrderedSame) isBold=true;
        else if ([s caseInsensitiveCompare:@"italic"]==NSOrderedSame) isItalic=true;
        else{
            NSError *error = NULL;
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[0-9]{1,3}.*" options:NSRegularExpressionCaseInsensitive error:&error];
            NSTextCheckingResult *result = [regex firstMatchInString:s options:0 range:NSMakeRange(0, [s length])];
            if(result)
            {
                font.size=[CSS parseInt:s];
            }
            else{
                family=s;
            }
        }
        
    }

    if(isBold)
    {
        family=[family stringByAppendingString:@"-Bold"];
        font.family=family;
    }

    if (isItalic)
    {
        // for chinese chars
        CGAffineTransform matrix =  CGAffineTransformMake(1, 0, tanf(15 * (CGFloat)M_PI / 180), 1, 0, 0);
        UIFontDescriptor *desc = [UIFontDescriptor  fontDescriptorWithName :font.family matrix: matrix];
        UIFont *f = [UIFont  fontWithDescriptor:desc size: font.size];
        
        font.font=f;
    }
    else{
        font.font=[UIFont fontWithName:font.family size:font.size];
        
    }
    
}


-(void) setMargin:(NSString *) marginString
{
    margin.margin = [marginString UTF8String];
    margin.left=margin.top=margin.right=margin.bottom=[CSS parseInt:marginString];
}

-(Margin) getMargin
{
    return margin;
}

-(void) setPadding:(NSString *) paddingString
{
    
    padding.padding = [paddingString UTF8String];
    padding.left=padding.top=padding.right=padding.bottom=[CSS parseInt:paddingString];
}

- (NSString *)getStyleValue:(NSString *)styleName
{
    //NSLog(@"name=%@",styleName);
    return [self.styles objectForKey:styleName];
}
- (void)setStyleValue:(NSString *)value forKey:(NSString*) name
{
    [self.styles setObject:value forKey:name];
}
+ (UIColor *) parseColor:(NSString *)color
{
    return [CSS hexStringToColor:color];
    
    //return [CSS  hexStringToColor:color];
}
+ (int) parseInt:(NSString *)number
{
    
    @try
    {
		
		if([number hasSuffix:@"px"])number=[number substringToIndex:(number.length-2)];
		if([number hasSuffix:@"dp"])number=[number substringToIndex:(number.length-2)];
        
		//NSMutableString *string = [NSMutableString stringWithString:number];
		//[string replaceCharactersInRange:[string rangeOfString:@"px"] withString:@""];
		//number = [NSString stringWithString:string];
        
		//string = [NSMutableString stringWithString:number];
		//[string replaceCharactersInRange:[string rangeOfString:@"dp"] withString:@""];
		//number = [NSString stringWithString:string];
		//number=number.replaceAll("[pP][xX]", "");
		//number=number.replaceAll("[dD][pP]", "");
		return [number intValue];
		
    }
    @catch (NSException  *e)
    {
        return 0;
    }
    
}
+ (float) parseFloat:(NSString *)number
{
    @try {
        return [number floatValue];
    }
    @catch (NSException *exception) {
        return 1;
    }
    
    
}
+ (NSString *) parseImageUrl:(NSString *)url
{
    if([url hasPrefix:@"url"])
    {
        NSRange r = {4, url.length-4-1};
        url=[url substringWithRange:r];
    }
    
    return url;
}


+(UIColor *) hexStringToColor: (NSString *) stringToConvert
{
	
	NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
	// String should be 6 or 8 characters
	if ([cString length] < 6) return [UIColor blackColor];
	// strip 0X if it appears
	if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
	if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    
    // Separate into a, r, g, b substrings
	NSRange range;
    
    int location=0;
    range.location = 0;
	range.length = 2;
    
    NSString *aStr=@"FF";
	if ([cString length] > 6)
    {
        aStr=[cString substringWithRange:range];
        range.location+=2;
    }
	NSString *rString = [cString substringWithRange:range];
	range.location += 2;
	NSString *gString = [cString substringWithRange:range];
	range.location += 2;
	NSString *bString = [cString substringWithRange:range];
    
    
	// Scan values
	unsigned int a,r, g, b;
    [[NSScanner scannerWithString:aStr] scanHexInt:&a];
	[[NSScanner scannerWithString:rString] scanHexInt:&r];
	[[NSScanner scannerWithString:gString] scanHexInt:&g];
	[[NSScanner scannerWithString:bString] scanHexInt:&b];
	return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f*a/255];
    
	//return [CSS colorStringToInt:stringToConvert];
    
}

+ (int)colorStringToInt:(NSString *)colorStrig

{
	colorStrig=[colorStrig substringFromIndex:1];
    return [NSString stringWithFormat:@"%d",strtoul([colorStrig UTF8String],0,16)];
    
}

+ (NSString *) colorToString:(UIColor *)color
{
    const CGFloat *cs = CGColorGetComponents(color.CGColor);
    
    NSString *r = [NSString stringWithFormat:@"%@", [CSS intToHex:cs[0] * 255]];
    NSString *g = [NSString stringWithFormat:@"%@", [CSS intToHex:cs[1] * 255]];
    NSString *b = [NSString stringWithFormat:@"%@", [CSS intToHex:cs[2] * 255]];
    return [NSString stringWithFormat:@"#%@%@%@", r, g, b];
}

//十进制转十六进制
+ (NSString *)intToHex:(int)tmpid {
    NSString *endtmp = @"";
    NSString *nLetterValue;
    NSString *nStrat;
    int ttmpig = tmpid % 16;
    int tmp = tmpid / 16;
    switch (ttmpig) {
        case 10:
            nLetterValue = @"A"; break;
        case 11:
            nLetterValue = @"B"; break;
        case 12:
            nLetterValue = @"C"; break;
        case 13:
            nLetterValue = @"D"; break;
        case 14:
            nLetterValue = @"E"; break;
        case 15:
            nLetterValue = @"F"; break;
        default:nLetterValue = [[NSString alloc] initWithFormat:@"%i", ttmpig];
    }
    switch (tmp) {
        case 10:
            nStrat = @"A"; break;
        case 11:
            nStrat = @"B"; break;
        case 12:
            nStrat = @"C"; break;
        case 13:
            nStrat = @"D"; break;
        case 14:
            nStrat = @"E"; break;
        case 15:
            nStrat = @"F"; break;
        default:nStrat = [[NSString alloc] initWithFormat:@"%i", tmp];
    }
    endtmp = [[NSString alloc] initWithFormat:@"%@%@", nStrat, nLetterValue];
    return endtmp;
}



/*
 
 int main (int argc, const char *argv[])
 {
 NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
 
 CSS *parser = [[CSS alloc] init:@"left:10PX;right:20Dp;color:#FFCC00"];
 if(parser==nil)
 {
 NSLog(@"cs is nil");
 }
 int l=parser.left;
 NSLog(@"left=%d",[CSS colorStringToInt:@"#CCCCCC"]);
 NSString *lefts=[parser getStyleValue:@"left"];
 NSLog(@"left=%d",parser.left);
 NSLog(@"right=%d",parser.right);
 NSLog(@"color=%d",parser.color);
 
 NSLog(@"No Errors");
 [pool drain];  
 
 return 0;  
 }
 */
@end