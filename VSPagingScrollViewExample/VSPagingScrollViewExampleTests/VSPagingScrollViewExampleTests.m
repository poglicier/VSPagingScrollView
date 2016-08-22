//
//  VSPagingScrollViewExampleTests.m
//  VSPagingScrollViewExampleTests
//
//  Created by Valentin Shamardin on 21.07.15.
//  Copyright (c) 2015 Valentin Shamardin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "VSPagingScrollView.h"


static NSInteger const kPagesCount = 3;

@interface VSPagingScrollViewExampleTests : XCTestCase {
    VSPagingScrollView *scrollView;
}

@end

@implementation VSPagingScrollViewExampleTests

- (void)setUp {
    [super setUp];
    scrollView = [[VSPagingScrollView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    scrollView.pagesCount = kPagesCount;
}

- (void)tearDown {
    [super tearDown];
}

- (void)testCurrentPageSetting {
    NSInteger currentPage = 1;
    [scrollView setCurrentPage:currentPage animated:YES];
    XCTAssertEqual(scrollView.currentPage, currentPage, @"Set current page");
}

- (void)testPagesCount {
    XCTAssertEqual(scrollView.pagesCount, kPagesCount, @"Pages count");
}

@end
