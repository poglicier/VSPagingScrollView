# VSPagingScrollView

The main idea was took from [Ray Wenderlich tutorial] (http://www.raywenderlich.com/10518/how-to-use-uiscrollview-to-scroll-and-zoom-content), then upgraded.
### Installation with CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party libraries in your projects.

#### Podfile

```ruby
platform :ios, '7.0'
pod "VSPagingScrollView"
```

## Usage

Just add `VSPagingScrollView` to your view and set `VSPagingScrollViewDelegate`. This delegate has one method to get a view for each page. For example, this snippet creates a scroll view with colored pages:

```objective-c
#pragma mark - VSPagingScrollViewDelegate interface

- (UIView*)viewForPagingScrollView:(VSPagingScrollView *)scrollView onPage:(NSUInteger)page
{
    UIView* pageView = [[UIView alloc] initWithFrame:self.scrollView.bounds];
    pageView.backgroundColor = [UIColor colorWithRed:page/1./self.texts.count green:0 blue:1 alpha:1];
    
    return pageView;
}
```

## License

VSPagingScrollView is released under the MIT license. See LICENSE for details.
