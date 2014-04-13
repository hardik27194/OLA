#import "XMLElement.h"
#import <Foundation/Foundation.h>

@implementation XMLElement
@synthesize tagName,attributes,children,textContent;
/*
- (void)dealloc {
   [tagName release];
   [attributes release];
   [children release];
   [super dealloc];
}
*/
@end
