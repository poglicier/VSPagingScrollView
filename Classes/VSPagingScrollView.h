#import <UIKit/UIKit.h>

@protocol VSPagingScrollViewDelegate;

@interface VSPagingScrollView : UIScrollView

@property (assign, nonatomic) NSInteger pagesCount;
@property (assign, nonatomic, readonly) NSInteger currentPage;
@property (weak, nonatomic) id<VSPagingScrollViewDelegate> pagingDelegate;

@end

@protocol VSPagingScrollViewDelegate <NSObject>

- (UIView*)viewForPagingScrollView:(VSPagingScrollView*)scrollView onPage:(NSInteger)page;

@end