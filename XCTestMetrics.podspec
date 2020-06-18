Pod::Spec.new do |s|
  s.name             = 'XCTestMetrics'
  s.version          = '0.0.7'
  s.summary          = 'A command-line tool that provides metrics about your project tests.'
  s.homepage         = 'https://github.com/serralvo/XCTestMetrics'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'serralvo' => 'fabricio.serralvo@gmail.com' }
  s.social_media_url = 'https://twitter.com/serralvo_'
  s.source           = { :git => 'https://github.com/serralvo/XCTestMetrics.git', :tag => s.version.to_s }
  s.preserve_paths = '*'
end