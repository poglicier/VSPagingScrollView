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
}

- (void)loadVisiblePages
{
    NSInteger page = self.currentPage;
    if (page < 0)
        page = 0;
    else if (page > self.pagesCount)
        page = self.pagesCount;
    
    NSInteger firstPage = page - 1;
    NSInteger lastPage = page + 1;
    
    for (NSInteger i=0; i<firstPage; i++)
        [self purgePage:i];
    
    for (NSInteger i=firstPage; i<=lastPage; i++)
        [self loadPage:i];
    
    for (NSInteger i=lastPage+1; i<self.pageViews.count; i++)
        [self purgePage:i];
}

- (void)loadPage:(NSInteger)page
{
    if (page < 0 || page >= self.pageViews.count)
        return;
    
    UIView *pageView = [self.pageViews objectAtIndex:page];
    if ((NSNull*)pageView == [NSNull null])
    {
        CGRect frame = self.bounds;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        
        UIView* newPageView = [self.pagingDelegate viewForPagingScrollView:self onPage:page];
        CGRect pageViewFrame = newPageView.frame;
        pageViewFrame.origin.x = page*self.frame.size.width;
        newPageView.frame = pageViewFrame;
        
        [self addSubview:newPageView];
        [self.pageViews replaceObjectAtIndex:page withObject:newPageView];
    }
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

- (void)setPagesCount:(NSInteger)pagesCount
{
    _pagesCount = pagesCount;
    self.contentSize = CGSizeMake(self.frame.size.width*pagesCount, self.frame.size.height);
    
    for (NSInteger i=0; i<pagesCount; i++)
        [self.pageViews addObject:[NSNull null]];
    
    [self loadVisiblePages];
}

- (NSInteger)currentPage
{
    CGFloat pageWidth = self.frame.size.width;
    return (NSInteger)floor((self.contentOffset.x*2 + pageWidth) / (pageWidth*2.0));
}

#pragma mark - UIScrollViewDelegate interface

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self loadVisiblePages];
}

@end