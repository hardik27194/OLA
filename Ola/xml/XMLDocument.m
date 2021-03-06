//XMLParser.m
#import "XMLDocument.h"
#import "XMLAttribute.h"
#import "XMLElement.h"
#import "XMLText.h"
#import "LOStack.h"
//#import "XMLAppDelegate.h"
//#import "Book.h"
 
@implementation XMLDocument
@synthesize root;
 
 LOStack *stack ;

 XMLElement *parent;
 XMLElement *current;

- (XMLDocument *) initXMLParser {
 
	//[super init];
	 
	//appDelegate = (XMLAppDelegate *)[[UIApplication sharedApplication] delegate];
	stack = [[LOStack alloc] init];
	 
	return self;
}
 
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName
attributes:(NSDictionary *)attributeDict {
 
	 //NSLog(@"Start didStartElement, name=%@",elementName);
	 /*
	if([elementName isEqualToString:@"Books"]) {
	//Initialize the array.
	//在这里初始化用于存储最终解析结果的数组变量,我们是在当遇到Books根元素时才开始初始化，有关此初始化过程也可以在parserDidStartDocument 方法中实现
	//appDelegate.books = [[NSMutableArray alloc] init];
	NSLog(@"Node:Books");
	}
	else if([elementName isEqualToString:@"Book"]) {
	 
	//Initialize the book.
	//当碰到Book元素时，初始化用于存储Book信息的实例对象aBook
	//aBook = [[Book alloc] init];
	 
	//Extract the attribute here.
	//从attributeDict字典中读取Book元素的属性
	//aBook.bookID = [[attributeDict objectForKey:@"id"] integerValue];
	 
	NSLog(@"Reading id value :%i", [[attributeDict objectForKey:@"id"] integerValue]);// aBook.bookID);
	}
	*/
	eleLevel++;
		current =[[XMLElement alloc] init];
		//Extract the attribute here.
		//从attributeDict字典中读取Book元素的属性
		//aBook.bookID = [[attributeDict objectForKey:@"id"] integerValue];

		//(NSArray *) keys = [attributeDict allKeys];
		current.tagName=elementName;
    current.attributes = [[NSMutableDictionary alloc] initWithDictionary:attributeDict];
    /*
		for(id key in [attributeDict allKeys])
		{
			XMLAttribute *attr=(XMLAttribute *)[[XMLAttribute alloc] init];
			attr.name=key;
			attr.value=[attributeDict objectForKey:key];
			if(current.attributes == nil)
			{
				current.attributes =[NSMutableSet setWithCapacity:1];
			}
			[current.attributes addObject:attr];
		}
     */


	if(eleLevel==1)
	{
		root=current;
		parent=current;
		[stack push:parent];
	}
	else
	{
		parent = [stack pop];
		[stack push:parent];
		if(parent.children == nil)
		{
			parent.children =[[NSMutableArray alloc] initWithCapacity:1];
		}
		[parent.children addObject:current];
		[stack push:current];
	}

    currentElementValue = [[NSMutableString alloc] initWithString:@""];
	//NSLog(@"Processing Element: %@,Level:%i", elementName,eleLevel);
}

/* 可以看出parser:didStartElement:namespaceURI:qualifiedName:attributes方法实现的就是在解析元素开始标签时，进行一些初始化流程 */
 
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    //NSLog(@"Start foundCharacters...");
	// 当用于存储当前元素的值是空时，则先用值进行初始化赋值
	// 否则就直接追加信息
    //NSLog(@"Text Value: %@", string);
    //NSLog(@"currentElementValue: %@", currentElementValue);
    /*
	if(!currentElementValue)
	{
		currentElementValue = [[NSMutableString alloc] initWithString:string];
		return;
	}
	else
     */
	{
		[currentElementValue appendString:string];
		
	}
	 
	
 
}

// 这里才是真正完成整个解析并保存数据的最终结果的地方
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
 
	 /*
	if([elementName isEqualToString:@"Books"])
	{
	NSLog(@"Node:Books");
	return;
	}
	 
	//There is nothing to do if we encounter the Books element here.
	//If we encounter the Book element howevere, we want to add the book object to the array 遇到Book元素的结束标签，则添加book对象到设置好的数组中。
	// and release the object.
	if([elementName isEqualToString:@"Book"]) {
	//[appDelegate.books addObject:aBook];
	 
	//[aBook release];
	//aBook = nil;
	}
	else
	// 不是Book元素时也不是根元素，则用 setValue:forKey为当前book对象的属性赋值

	////[aBook setValue:currentElementValue forKey:elementName];
	*/

	 //NSLog(@"Start didEndElement, tag: %@ Level:%i",elementName,eleLevel);
	 eleLevel--;
	 parent = [stack pop];
    XMLText *text;
    if(currentElementValue)
    {
     text=[[XMLText alloc] init];
    text.value= [NSString stringWithString: trim(currentElementValue)];
    //[current.children addObject:text];
    current.textContent=text;
    }

	//[currentElementValue release];
	currentElementValue = nil;
    //NSLog(@"end didEndElement, name=%@,tesxt=%@",elementName,trim(current.textContent.value));
}
 /*
- (void) dealloc {
 
	////[aBook release];
	[currentElementValue release];
	[super dealloc];
}
*/

@end