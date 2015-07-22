#import <UIKit/UIKit.h>

@protocol VSPagingScrollViewDelegate;

@interface VSPagingScrollView : UIScrollView

@property (assign, nonatomic) NSInteger pagesCount;
@property (assign, nonatomic) NSInteger currentPage;
@property (weak, nonatomic) id<VSPagingScrollViewDelegate> pagingDelegate;

- (void)setCurrentPage:(NSInteger)currentPage animated:(BOOL)animated;
- (void)reloadData;

@end

@protocol VSPagingScrollViewDelegate <NSObject>

- (UIView*)viewForPagingScrollView:(VSPagingScrollView*)scrollView onPage:(NSInteger)page;

@end