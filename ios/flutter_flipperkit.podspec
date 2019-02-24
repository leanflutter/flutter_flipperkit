flipperkit_version = '0.16.2'

#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'flutter_flipperkit'
  s.version          = '0.0.2'
  s.summary          = 'Flipper SDK for Flutter.'
  s.description      = <<-DESC
  Flipper SDK for Flutter.
                       DESC
  s.homepage         = 'https://github.com/lijy91/flutter_flipperkit'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'JianyingLi' => 'lijy91@foxmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  
  s.dependency 'Flutter'
  s.dependency 'FlipperKit', '~>' + flipperkit_version
  s.dependency 'FlipperKit/FlipperKitLayoutComponentKitSupport', '~>' + flipperkit_version
  s.dependency 'FlipperKit/SKIOSNetworkPlugin', '~>' + flipperkit_version
  s.dependency 'FlipperKit/FlipperKitUserDefaultsPlugin', '~>' + flipperkit_version

  s.xcconfig = {'OTHER_CFLAGS' => '-DFB_SONARKIT_ENABLED=1'}
  s.ios.deployment_target = '9.0'
end
