#import <Foundation/Foundation.h>
#import "LuaTestClass.h"
@implementation LuaTestClass

@synthesize name,value;

+(void) d:(NSString *)message
{
	NSLog(message);
}
- (void)dealloc {
   [name release];
   [value release];
    [super dealloc];
}
@end
