#import "XMLAttribute.h"
#import <Foundation/Foundation.h>

@implementation XMLAttribute
@synthesize name,value;
- (void)dealloc {
   [name release];
   [value release];
    [super dealloc];
}
@end
