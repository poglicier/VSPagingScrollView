Pod::Spec.new do |s|
  s.name         = "VSPagingScrollView"
  s.version      = "0.0.9"
  s.summary      = "VSPagingScrollView is a UIScrollView with paging enabled based on Ray Wenderlich tutorial"
  s.homepage     = "https://github.com/poglicier/VSPagingScrollView"
  s.license               = { :type => 'MIT', :file => 'LICENSE' }
  s.author             = { "poglicier" => "poglicier@gmail.com" }
  s.social_media_url   = "https://www.facebook.com/valentin.shamardin"
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/poglicier/VSPagingScrollView.git", :tag => s.version.to_s }
  s.source_files  = "Classes", "Classes/**/*.{h,m}"
  s.public_header_files   = 'Classes/*.h'
  s.framework             = 'Foundation'
  s.requires_arc          = true
end
