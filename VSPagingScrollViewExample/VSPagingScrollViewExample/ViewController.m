//
//  ViewController.m
//  VSPagingScrollViewExample
//
//  Created by Valentin Shamardin on 21.07.15.
//  Copyright (c) 2015 Valentin Shamardin. All rights reserved.
//

#import "ViewController.h"
#import "VSPagingScrollView.h"

@interface ViewController () <VSPagingScrollViewDelegate>

@property (strong, nonatomic) IBOutlet VSPagingScrollView *scrollView;
@property (strong, nonatomic) NSArray* texts;

@end

@implementation ViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.scrollView.numberOfCachedPages = 2;
    self.scrollView.pagingDelegate = self;
    self.scrollView.pagesCount = self.texts.count;
    self.scrollView.currentPage = 0;
}

#pragma mark - Private interface

- (NSArray*)texts
{
    if (!_texts)
        _texts = @[@"PAGE 1", @"PAGE 2", @"PAGE 3", @"PAGE 4", @"PAGE 5", @"PAGE 6", @"PAGE 7", @"PAGE 8"];
    return _texts;
}

#pragma mark - VSPagingScrollViewDelegate interface

- (UIView*)viewForPagingScrollView:(VSPagingScrollView *)scrollView onPage:(NSUInteger)page
{
    UIView* pageView = [[UIView alloc] initWithFrame:self.scrollView.bounds];
    pageView.backgroundColor = [UIColor colorWithRed:page/1./self.texts.count green:0 blue:1 alpha:1];
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake((pageView.frame.size.width - 100)/2,(pageView.frame.size.height - 40)/2 , 100, 40)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
    label.textColor = [UIColor whiteColor];
    label.text = self.texts[page];
    [pageView addSubview:label];
    
    return pageView;
}

@end
