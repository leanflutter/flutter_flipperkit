flipperkit_version = '0.189.0'

#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_flipperkit.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_flipperkit'
  s.version          = '0.0.28'
  s.summary          = 'Flipper (Extensible mobile app debugger) for flutter.'
  s.description      = <<-DESC
  Flipper (Extensible mobile app debugger) for flutter.
                       DESC
  s.homepage         = 'https://github.com/lijy91/flutter_flipperkit'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'LiJianying' => 'lijy91@foxmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  
  s.dependency 'Flutter'
  s.dependency 'FlipperKit', '~>' + flipperkit_version
  s.dependency 'FlipperKit/FlipperKitLayoutComponentKitSupport', '~>' + flipperkit_version
  s.dependency 'FlipperKit/SKIOSNetworkPlugin', '~>' + flipperkit_version
  s.dependency 'FlipperKit/FlipperKitUserDefaultsPlugin', '~>' + flipperkit_version

  s.xcconfig = {'OTHER_CFLAGS' => '-DFB_SONARKIT_ENABLED=1'}
  s.ios.deployment_target = '11.0'
  s.static_framework = true

  # Flutter.framework does not contain a arm64 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
end
