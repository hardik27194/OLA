
/*
@interface XMLHelper : NSObject <NSXMLParserDelegate>
{
}

- (void) init
{
	NSXMLParser *xmlParser = [[NSXMLParser alloc]initWithContentsOfURL:[NSURL URLWithString:@"http://rss.sina.com.cn/roll/sports/hot_roll.xml"]];  

}
*/
/*
- (NSXMLDocument *)loadXMLDocument:(NSString *)xmlFilePath{  
    assert(xmlFilePath);  
    NSXMLDocument *xmlDoc = nil;  
    NSError *error = nil;  
    @try {  
        NSURL *fileURL = [NSURL fileURLWithPath:xmlFilePath];  
        if (fileURL == nil) {  
            return nil;  
        }  
        xmlDoc = [[NSXMLDocument alloc] initWithContentsOfURL:fileURL options:NSXMLDocumentTidyXML error:&error];  
    }  
    @catch (NSException * e) {  
          
    }  
    @finally {  
        return [xmlDoc autorelease];  
    }  
} 
*/


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict 
{

    /*

     * ����һ��start tag for element ���ݲ�ͬ��Ԫ������������ͬ�����ڱ����Ӧ������Ϣ�Ķ��󣨽ṹ�壩

     * �������attribute of the element ����������Ϣ�����󣨽ṹ�壩

     */

if([elementName isEqualToString:@"Books"]) {
//Initialize the array.
appDelegate.books = [[NSMutableArray alloc] init];
}

aBook.bookID = [[attributeDict objectForKey:@"id"] integerValue];

}

//����������Ҫ����element's value ��Ҫһ�㶼�����´�����valueֵ���ַ���

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {

if(!currentElementValue)
currentElementValue = [[NSMutableString alloc] initWithString:string];
else
[currentElementValue appendString:string];

NSLog(@"Processing Value: %@", currentElementValue);

}


- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {

    /*

    *����end tag for element���жϲ�ͬ��Ԫ���������費ͬ�Ĵ��� ����


   */

if([elementName isEqualToString:@"Book"]) {
[appDelegate.books addObject:aBook];

[aBook release];
aBook = nil;
}

}



int main (int argc, const char *argv[]) {  

	NSURL *url = [[NSURL alloc] initWithString:@"book.xml"];
	NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];

	//Initialize the delegate.ʵ���������������Ĵ���������ж���Ĵ���
	xml *parser = [[xml alloc] initXMLParser];

	//Set delegate ����NSXMLParser����Ľ�����������
	[xmlParser setDelegate:parser];

	//Start parsing the XML file.���ô������NSXMLParser����
	BOOL success = [xmlParser parse];

	if(success)
	NSLog(@"No Errors");
	else
	NSLog(@"Error Error Error!!!");
}
