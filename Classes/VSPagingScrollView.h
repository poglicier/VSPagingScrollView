#import <UIKit/UIKit.h>

@protocol VSPagingScrollViewDelegate;

@interface VSPagingScrollView : UIScrollView

@property (assign, nonatomic) NSUInteger pagesCount;
@property (assign, nonatomic, readonly) NSUInteger currentPage;
@property (assign, nonatomic) NSUInteger numberOfCachedPages;

@property (weak, nonatomic) id<VSPagingScrollViewDelegate> pagingDelegate;

- (void)setCurrentPage:(NSUInteger)currentPage animated:(BOOL)animated;
- (void)reloadData;
- (UIView*)viewOnPage:(NSUInteger)page;

@end

@protocol VSPagingScrollViewDelegate <NSObject>

- (UIView*)viewForPagingScrollView:(VSPagingScrollView*)scrollView onPage:(NSUInteger)page;

@optional
- (void)viewForPagingScrollViewDidChangePage:(VSPagingScrollView*)scrollView;

@end