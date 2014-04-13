#import <Foundation/Foundation.h>
#import "XMLText.h"
@interface XMLElement:NSObject {
   NSString			*tagName;
   NSMutableDictionary		*attributes;
   NSMutableArray		*children;
    XMLText * textContent;
}
@property (nonatomic, retain) NSString  *tagName;
@property (nonatomic, retain) NSMutableDictionary  *attributes;
@property (nonatomic, retain) NSMutableArray  *children;
@property (nonatomic)XMLText * textContent;

@end
