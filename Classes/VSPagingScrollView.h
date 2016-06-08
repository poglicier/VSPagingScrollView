#import <UIKit/UIKit.h>

@protocol VSPagingScrollViewDelegate;

@interface VSPagingScrollView : UIScrollView

@property (assign, nonatomic) NSUInteger pagesCount;
@property (assign, nonatomic, readonly) NSUInteger currentPage;
@property (assign, nonatomic) NSUInteger numberOfCachedPages;

@property (weak, nonatomic) id<VSPagingScrollViewDelegate> pagingDelegate;

- (void)setCurrentPage:(NSUInteger)currentPage animated:(BOOL)animated;
- (void)reloadData;

@end

@protocol VSPagingScrollViewDelegate <NSObject>

- (UIView*)viewForPagingScrollView:(VSPagingScrollView*)scrollView onPage:(NSUInteger)page;

@end