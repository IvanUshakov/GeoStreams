Pod::Spec.new do |s|
  s.name     = 'SVPullToRefresh'
  s.version  = '0.2'
  s.platform = :ios
  s.license  = 'MIT'
  s.summary  = 'Give pull-to-refresh to any UIScrollView with 1 line of code.'
  s.homepage = 'https://github.com/samvermette/SVPullToRefresh'
  s.author   = { 'Sam Vermette' => 'hello@samvermette.com' }
  s.source   = { :git => 'https://github.com/samvermette/SVPullToRefresh.git',
                 :commit => '3b0bdb0abe99083d4405d1833274912ccd198fd1' }

  s.description = 'SVPullToRefresh allows you to easily add pull-to-refresh ' \
                  'functionality to any UIScrollView subclass with only 1 ' \
                  'line of code. Instead of depending on delegates and/or ' \
                  'subclassing UIViewController, SVPullToRefresh extends ' \
                  'UIScrollView with a addPullToRefreshWithActionHandler: ' \
                  'method as well as a pullToRefreshView property.'

  s.frameworks   = 'QuartzCore'
  s.source_files = 'SVPullToRefresh/*.{h,m}'
  s.resource = 'SVPullToRefresh/SVPullToRefresh.bundle'
  s.clean_paths  = 'Demo'
  s.resources    = 'SVPullToRefresh/SVPullToRefresh.bundle'
end

