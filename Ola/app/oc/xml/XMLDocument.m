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
 
	[super init];
	 
	//appDelegate = (XMLAppDelegate *)[[UIApplication sharedApplication] delegate];
	stack = [[LOStack alloc] init];
	 
	return self;
}
 
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName
attributes:(NSDictionary *)attributeDict {
 
	 //NSLog(@"Start didStartElement...");
	 /*
	if([elementName isEqualToString:@"Books"]) {
	//Initialize the array.
	//�������ʼ�����ڴ洢���ս���������������,�������ڵ�����Books��Ԫ��ʱ�ſ�ʼ��ʼ�����йش˳�ʼ������Ҳ������parserDidStartDocument ������ʵ��
	//appDelegate.books = [[NSMutableArray alloc] init];
	NSLog(@"Node:Books");
	}
	else if([elementName isEqualToString:@"Book"]) {
	 
	//Initialize the book.
	//������BookԪ��ʱ����ʼ�����ڴ洢Book��Ϣ��ʵ������aBook
	//aBook = [[Book alloc] init];
	 
	//Extract the attribute here.
	//��attributeDict�ֵ��ж�ȡBookԪ�ص�����
	//aBook.bookID = [[attributeDict objectForKey:@"id"] integerValue];
	 
	NSLog(@"Reading id value :%i", [[attributeDict objectForKey:@"id"] integerValue]);// aBook.bookID);
	}
	*/
	eleLevel++;
		current =[[XMLElement alloc] init];
		//Extract the attribute here.
		//��attributeDict�ֵ��ж�ȡBookԪ�ص�����
		//aBook.bookID = [[attributeDict objectForKey:@"id"] integerValue];

		//(NSArray *) keys = [attributeDict allKeys];
		current.tagName=elementName;
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
			parent.children =[NSMutableSet setWithCapacity:1];
		}
		[parent.children addObject:current];
		[stack push:current];
	}


	//NSLog(@"Processing Element: %@,Level:%i", elementName,eleLevel);
}

/* ���Կ���parser:didStartElement:namespaceURI:qualifiedName:attributes����ʵ�ֵľ����ڽ���Ԫ�ؿ�ʼ��ǩʱ������һЩ��ʼ������ */
 
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    //NSLog(@"Start foundCharacters...");
	// �����ڴ洢��ǰԪ�ص�ֵ�ǿ�ʱ��������ֵ���г�ʼ����ֵ
	// �����ֱ��׷����Ϣ 
	if(!currentElementValue)
	{
	//	currentElementValue = [[NSMutableString alloc] initWithString:string];
		return;
	}
	else
	{
	//	[currentElementValue appendString:string];
		XMLText *text=[[XMLText alloc] init];
		text.value=string;
		[current.children addObject:text];
	}
	 
	//NSLog(@"Text Value: %@", currentElementValue);
 
}

// �������������������������������ݵ����ս���ĵط�
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
 
	 /*
	if([elementName isEqualToString:@"Books"])
	{
	NSLog(@"Node:Books");
	return;
	}
	 
	//There is nothing to do if we encounter the Books element here.
	//If we encounter the Book element howevere, we want to add the book object to the array ����BookԪ�صĽ�����ǩ��������book�������úõ������С�
	// and release the object.
	if([elementName isEqualToString:@"Book"]) {
	//[appDelegate.books addObject:aBook];
	 
	//[aBook release];
	//aBook = nil;
	}
	else
	// ����BookԪ��ʱҲ���Ǹ�Ԫ�أ����� setValue:forKeyΪ��ǰbook��������Ը�ֵ

	////[aBook setValue:currentElementValue forKey:elementName];
	*/

	 //NSLog(@"Start didEndElement, tag: %@ Level:%i",elementName,eleLevel);
	 eleLevel--;
	 parent = [stack pop];

	[currentElementValue release];
	currentElementValue = nil;
}
 
- (void) dealloc {
 
	////[aBook release];
	[currentElementValue release];
	[super dealloc];
}


@end