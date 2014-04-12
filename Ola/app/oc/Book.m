//Book.m
#import "Book.h"
#import <Foundation/Foundation.h>
@implementation Book
@synthesize title,author,summary,bookID;

- (void)dealloc {
   [summary release];
   [author release];
   [title release];
   [super dealloc];
}
@end