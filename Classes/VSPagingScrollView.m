#import "VSPagingScrollView.h"

@interface EmptyView : UIView

@end

@implementation EmptyView

@end

@interface VSPagingScrollView ()

@property (strong, nonatomic) NSMutableArray* pageViews;
@property (strong, nonatomic) UIView* contentView;
@property (assign, nonatomic) UIInterfaceOrientation orientation;
@property (assign, nonatomic) NSUInteger currentPage;

@end

@implementation VSPagingScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"contentSize"];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat pageWidth = self.frame.size.width;
    double page = floor((self.contentOffset.x*2 + pageWidth) / (pageWidth*2.0));

    if (page < 0)
        page = 0;
    
    self.currentPage = page;
    
    [self loadVisiblePages];
}

#pragma mark - Private interface

- (void)initialize
{
    self.pagingEnabled = YES;
    self.pageViews = [NSMutableArray new];
    self.numberOfCachedPages = 1;
    
    self.contentView = [UIView new];
    [self addSubview:self.contentView];

    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self.contentView
                                                                      attribute:NSLayoutAttributeLeading
                                                                      relatedBy:0
                                                                         toItem:self
                                                                      attribute:NSLayoutAttributeLeading
                                                                     multiplier:1.0
                                                                       constant:0];
    [self addConstraint:leftConstraint];
    
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self.contentView
                                                                       attribute:NSLayoutAttributeTrailing
                                                                       relatedBy:0
                                                                          toItem:self
                                                                       attribute:NSLayoutAttributeTrailing
                                                                      multiplier:1.0
                                                                        constant:0];
    [self addConstraint:rightConstraint];
    
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.contentView
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:0
                                                                        toItem:self
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1.0
                                                                      constant:0];
    [self addConstraint:topConstraint];
    
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:self.contentView
                                                                        attribute:NSLayoutAttributeBottom
                                                                        relatedBy:0
                                                                           toItem:self
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1.0
                                                                         constant:0];
    [self addConstraint:bottomConstraint];
    
    [self addObserver:self forKeyPath:@"contentSize" options:0 context:nil];
}

- (void)loadVisiblePages
{
    NSUInteger page = self.currentPage;

    if (page > self.pagesCount)
        page = self.pagesCount;
    
    NSInteger firstPage = page - self.numberOfCachedPages;
    NSInteger lastPage = page + self.numberOfCachedPages;
    
    for (NSInteger i=0; i<firstPage; i++) {
        [self purgePage:i];
    }
    
    for (NSInteger i = firstPage; i <= lastPage; i++) {
        [self loadPage:i];
    }
    
    for (NSInteger i=lastPage+1; i<self.pageViews.count; i++) {
        [self purgePage:i];
    }
}

- (void)loadPage:(NSInteger)page
{
    if (page < 0 || page >= self.pageViews.count)
        return;

    UIView *pageView = self.pageViews[page];
    if ([pageView isKindOfClass:[EmptyView class]])
    {
        UIView* newPageView = [self.pagingDelegate viewForPagingScrollView:self onPage:page];
        newPageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:newPageView];
        
        [self addNewPageView:newPageView onPage:page];

        [self.pageViews replaceObjectAtIndex:page withObject:newPageView];
        [pageView removeFromSuperview];
    }
}

- (void)purgePage:(NSInteger)page
{
    if (page < 0 || page >= self.pageViews.count)
        return;
    
    UIView *pageView = [self.pageViews objectAtIndex:page];
    if (![pageView isKindOfClass:[EmptyView class]]) {
        EmptyView* empty = [EmptyView new];
        empty.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:empty];
        
        [self addNewPageView:empty onPage:page];
        
        [self.pageViews replaceObjectAtIndex:page withObject:empty];
        [pageView removeFromSuperview];
    }
}

- (void)addNewPageView:(UIView*)newPageView onPage:(NSUInteger)page {
    NSLayoutConstraint *leftConstraint;
    if (page == 0) {
        leftConstraint = [NSLayoutConstraint constraintWithItem:newPageView
                                                      attribute:NSLayoutAttributeLeading
                                                      relatedBy:0
                                                         toItem:self.contentView
                                                      attribute:NSLayoutAttributeLeading
                                                     multiplier:1.0
                                                       constant:0];
    } else {
        leftConstraint = [NSLayoutConstraint constraintWithItem:newPageView
                                                      attribute:NSLayoutAttributeLeft
                                                      relatedBy:0
                                                         toItem:self.pageViews[page-1]
                                                      attribute:NSLayoutAttributeRight
                                                     multiplier:1.0
                                                       constant:0];
    }
    [self.contentView addConstraint:leftConstraint];
    
    NSLayoutConstraint *rightConstraint;
    if (page == self.pagesCount-1) {
        rightConstraint = [NSLayoutConstraint constraintWithItem:newPageView
                                                       attribute:NSLayoutAttributeTrailing
                                                       relatedBy:0
                                                          toItem:self.contentView
                                                       attribute:NSLayoutAttributeTrailing
                                                      multiplier:1.0
                                                        constant:0];
    } else {
        rightConstraint = [NSLayoutConstraint constraintWithItem:newPageView
                                                       attribute:NSLayoutAttributeRight
                                                       relatedBy:0
                                                          toItem:self.pageViews[page+1]
                                                       attribute:NSLayoutAttributeLeft
                                                      multiplier:1.0
                                                        constant:0];
    }
    [self.contentView addConstraint:rightConstraint];
    
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:newPageView
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:0
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1.0
                                                                      constant:0];
    [self.contentView addConstraint:topConstraint];
    
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:newPageView
                                                                        attribute:NSLayoutAttributeBottom
                                                                        relatedBy:0
                                                                           toItem:self.contentView
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1.0
                                                                         constant:0];
    [self.contentView addConstraint:bottomConstraint];
    
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:newPageView
                                                                       attribute:NSLayoutAttributeWidth
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self
                                                                       attribute:NSLayoutAttributeWidth
                                                                      multiplier:1.0
                                                                        constant:0];
    [self addConstraint:widthConstraint];
    
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:newPageView
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self
                                                                        attribute:NSLayoutAttributeHeight
                                                                       multiplier:1.0
                                                                         constant:0];
    [self addConstraint:heightConstraint];
}

#pragma mark - Public interface

- (void)setPagesCount:(NSUInteger)pagesCount
{
    _pagesCount = pagesCount;
    
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.pageViews removeAllObjects];

    for (NSUInteger i=0; i<pagesCount; i++) {
        EmptyView* empty = [EmptyView new];
        empty.translatesAutoresizingMaskIntoConstraints = NO;
        [self.pageViews addObject:empty];
        [self.contentView addSubview:empty];
    }
    
    for (NSUInteger i=0; i<pagesCount; i++) {
        [self addNewPageView:self.pageViews[i] onPage:i];
    }
    
    if (self.currentPage >= _pagesCount)
        self.currentPage = pagesCount - 1;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentSize"]) {
        if (self.currentPage < self.pagesCount) {
            [self setContentOffset:CGPointMake(self.frame.size.width*self.currentPage, 0) animated:NO];
        }
    }
}

- (void)setCurrentPage:(NSUInteger)currentPage {
    if (_currentPage != currentPage) {
        _currentPage = currentPage;
        if ([self.pagingDelegate respondsToSelector:@selector(viewForPagingScrollViewDidChangePage:)]) {
            [self.pagingDelegate viewForPagingScrollViewDidChangePage:self];
        }
    }
}

- (void)setCurrentPage:(NSUInteger)currentPage animated:(BOOL)animated
{
    if (currentPage < self.pagesCount) {
        [self setContentOffset:CGPointMake(self.frame.size.width*currentPage, 0) animated:animated];
        self.currentPage = currentPage;
    } else if (currentPage > self.pagesCount - 1) {
        self.currentPage = self.pagesCount - 1;
    }
}

- (void)reloadData
{
    [self.pageViews enumerateObjectsUsingBlock:^(id pageView, NSUInteger idx, BOOL *stop) {
        [self purgePage:idx];
    }];
    
    [self loadVisiblePages];
}

@end