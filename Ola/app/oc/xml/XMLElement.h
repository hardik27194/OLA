#import <Foundation/Foundation.h>
@interface XMLElement:NSObject {
   NSString			*tagName;
   NSMutableSet		*attributes;
   NSMutableSet		*children;
}
@property (nonatomic, retain) NSString  *tagName;
@property (nonatomic, retain) NSMutableSet  *attributes;
@property (nonatomic, retain) NSMutableSet  *children;

@end
