#import "VSPagingScrollView.h"

@interface VSPagingScrollView () <UIScrollViewDelegate>

@property (strong, nonatomic) NSMutableArray* pageViews;

@end

@implementation VSPagingScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initialize];
    }
    return self;
}

#pragma mark - Private interface

- (void)initialize
{
    self.pagingEnabled = YES;
    self.delegate = self;
    self.pageViews = [NSMutableArray new];
    self.numberOfCachedPages = 1;
}

- (void)loadVisiblePages
{
    NSInteger page = self.currentPage;
    if (page < 0)
        page = 0;
    else if (page > self.pagesCount)
        page = self.pagesCount;
    
    NSInteger firstPage = page - self.numberOfCachedPages;
    NSInteger lastPage = page + self.numberOfCachedPages;
    
    for (NSInteger i=0; i<firstPage; i++)
        [self purgePage:i];


    CGFloat maxHeight = 0;
    for (NSInteger i = firstPage; i <= lastPage; i++)
    {
        UIView *view = [self loadPage:i];
        if (view.frame.size.height > maxHeight)
        {
            maxHeight = view.frame.size.height;
        }
    }

    self.contentSize = CGSizeMake(self.frame.size.width * _pagesCount, maxHeight);

    for (NSInteger i=lastPage+1; i<self.pageViews.count; i++)
        [self purgePage:i];
}

- (UIView *)loadPage:(NSInteger)page
{
    if (page < 0 || page >= self.pageViews.count)
        return nil;
    
    UIView *pageView = self.pageViews[page];
    if ((NSNull*)pageView == [NSNull null])
    {
        UIView* newPageView = [self.pagingDelegate viewForPagingScrollView:self onPage:page];
        CGRect pageViewFrame = newPageView.frame;
        pageViewFrame.origin.x = page*self.frame.size.width;
        newPageView.frame = pageViewFrame;
        
        [self addSubview:newPageView];
        self.pageViews[page] = newPageView;
    }
    return _pageViews[page];
}

- (void)purgePage:(NSInteger)page
{
    if (page < 0 || page >= self.pageViews.count)
        return;
    
    UIView *pageView = [self.pageViews objectAtIndex:page];
    if ((NSNull*)pageView != [NSNull null])
    {
        [pageView removeFromSuperview];
        [self.pageViews replaceObjectAtIndex:page withObject:[NSNull null]];
    }
}

#pragma mark - Public interface

- (void)setPagesCount:(NSUInteger)pagesCount
{
    _pagesCount = pagesCount;

    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.pageViews removeAllObjects];
    
    for (NSUInteger i=0; i<pagesCount; i++)
        [self.pageViews addObject:[NSNull null]];
}

- (NSUInteger)currentPage
{
    CGFloat pageWidth = self.frame.size.width;
    double page = floor((self.contentOffset.x*2 + pageWidth) / (pageWidth*2.0));
    
    if (page < 0)
        return 0;
    else
        return (NSUInteger)page;
}

- (void)setCurrentPage:(NSUInteger)currentPage
{
    [self setCurrentPage:currentPage animated:NO];
}

- (void)setCurrentPage:(NSUInteger)currentPage animated:(BOOL)animated
{
    if (currentPage < self.pagesCount)
        [self setContentOffset:CGPointMake(self.frame.size.width*currentPage, 0) animated:animated];
    
    if (currentPage == 0 &&
        self.contentOffset.x == 0)
        [self loadVisiblePages];
}

- (void)reloadData
{
    [self.pageViews enumerateObjectsUsingBlock:^(id pageView, NSUInteger idx, BOOL *stop) {
        [self purgePage:idx];
    }];
    
    [self loadVisiblePages];
}

#pragma mark - UIScrollViewDelegate interface

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self loadVisiblePages];
}

@end
