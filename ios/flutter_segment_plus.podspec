#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_segment_plus.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_segment_plus'
  s.version          = '0.0.1'
  s.summary          = 'Segment integration plugin for Flutter.'
  s.description      = <<-DESC
Segment integration plugin for Flutter.
                       DESC
  s.homepage         = 'https://github.com/circus-kitchens/flutter_segment_plus'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Circus Kitchens GmbH' => 'contact@circuskitchens.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.static_framework = true
  s.dependency 'Flutter'
  s.dependency 'Segment', '~> 1.3.4'
  s.dependency 'Adjust', '~> 4.33.4'
  s.dependency 'SegmentSwiftAmplitude', '~> 1.1.6'
  s.dependency 'SegmentBraze', '~> 1.0.0'
  s.platform = :ios, '9.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
