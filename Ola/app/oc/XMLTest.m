#import <Foundation/Foundation.h>
#import "xml/XMLDocument.h"
#import "xml/XMLAttribute.h"
#import "xml/XMLElement.h"
#import "xml/XMLText.h"
#import "LOStack.h"


int main (int argc, const char *argv[]) {  
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];  
    NSLog(@"Hello World!");  

    NSXMLParser *xmlParser = [[NSXMLParser alloc]initWithContentsOfURL:[NSURL URLWithString:@"file:///GNUstep/msys/1.0/home/xingbao-/oc/book.xml"]];  
    XMLDocument *parser = [[XMLDocument alloc] initXMLParser];
   [xmlParser setDelegate:parser];  
   [xmlParser parse];  


	/*
	NSURL *url = [[NSURL alloc] initWithString:@"http://localhost:8080/test/book.xml"];
	NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];

	//Initialize the delegate.ʵ���������������Ĵ���������ж���Ĵ���
	XMLParser *parser = [[XMLParser alloc] initXMLParser];

	//Set delegate ����NSXMLParser����Ľ�����������
	[xmlParser setDelegate:parser];

	//Start parsing the XML file.���ô������NSXMLParser����
	BOOL success = [xmlParser parse];

	if(success)
	NSLog(@"No Errors");
	else
	NSLog(@"Error Error Error!!!");
	*/
	NSLog(@"-----------Show Dom Tree---------");
	XMLElement *xml= parser.root;

	NSMutableSet *children = xml.children;

	for(XMLElement *ele in children)
	{
		NSLog(@"Node:[Tag = %@]",ele.tagName);
		for(XMLElement *c in ele.children)
		{
			NSLog(@"Node:[Tag = %@]",c.tagName);
		}
	}

    [pool drain];  

    return 0;  
}  
