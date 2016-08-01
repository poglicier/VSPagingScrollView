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
@property (strong, nonatomic) IBOutlet UIPageControl* pageControl;

@end

@implementation ViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.scrollView.numberOfCachedPages = 2;
    self.scrollView.pagingDelegate = self;
    self.scrollView.pagesCount = self.texts.count;
    [self.scrollView setCurrentPage:2 animated:NO];
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
    UILabel* label = [UILabel new];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.font = [UIFont systemFontOfSize:20];
    label.textColor = [UIColor whiteColor];
    label.text = self.texts[page];
    [pageView addSubview:label];
    
    [pageView addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                         attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:pageView
                                                         attribute:NSLayoutAttributeCenterX
                                                        multiplier:1
                                                          constant:0]];
    [pageView addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                         attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:pageView
                                                         attribute:NSLayoutAttributeCenterY
                                                        multiplier:1
                                                          constant:0]];
    
    return pageView;
}

- (void)viewForPagingScrollViewDidChangePage:(VSPagingScrollView *)scrollView {
    if (self.scrollView.currentPage == 0)
        self.pageControl.currentPage = 0;
    else if (self.scrollView.currentPage == self.scrollView.pagesCount - 1)
        self.pageControl.currentPage = self.pageControl.numberOfPages - 1;
    else
        self.pageControl.currentPage = 1;
}

@end