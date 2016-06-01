//
//  OlaTests.m
//  OlaTests
//
//  Created by Terrence Xing on 3/19/14.
//  Copyright (c) 2014 Terrence Xing. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OLAStringUtil.h"

@interface OlaTests : XCTestCase

@end

@implementation OlaTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    //XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
    NSString * cb=@" test( ) ";
    NSString * result=[OLAStringUtil addParameter:cb param:@"'name'"];
    NSLog(@"%@",result);
    XCTAssertEqualObjects(result, @"test('name')","SHould equals");
    
    cb=@" test('test') ";
    result=[OLAStringUtil addParameter:cb param:@"'name'"];
    NSLog(@"%@",result);
    XCTAssertEqualObjects(result, @"test('test','name')");
    
    NSString * a=@"a";
    NSArray *as=[a componentsSeparatedByString:@","];
    NSLog(@"length=%d",as.count);
    
}

@end
