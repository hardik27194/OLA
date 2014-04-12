// Book.h
//#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@interface Book:NSObject {
   NSInteger  bookID;
   NSString    *title;
   NSString    *author;
   NSString    *summary;
}

@property (nonatomic, readwrite) NSInteger bookID;
@property (nonatomic, retain) NSString  *title;
@property (nonatomic, retain) NSString  *author;
@property (nonatomic, retain) NSString  *summary;

@end

