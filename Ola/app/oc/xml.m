
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

     * 处理一：start tag for element 根据不同的元素名，创建不同的用于保存对应数据信息的对象（结构体）

     * 处理二：attribute of the element 保存数据信息到对象（结构体）

     */

if([elementName isEqualToString:@"Books"]) {
//Initialize the array.
appDelegate.books = [[NSMutableArray alloc] init];
}

aBook.bookID = [[attributeDict objectForKey:@"id"] integerValue];

}

//方法二：主要处理element's value 主要一般都是如下处理保存value值到字符串

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

    *处理end tag for element，判断不同的元素名，给予不同的处理 保存


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

	//Initialize the delegate.实例化解析处理方法的代理（步骤二中定义的代理）
	xml *parser = [[xml alloc] initXMLParser];

	//Set delegate 设置NSXMLParser对象的解析方法代理
	[xmlParser setDelegate:parser];

	//Start parsing the XML file.调用代理解析NSXMLParser对象
	BOOL success = [xmlParser parse];

	if(success)
	NSLog(@"No Errors");
	else
	NSLog(@"Error Error Error!!!");
}
