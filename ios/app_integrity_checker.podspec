#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint app_integrity_checker.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'app_integrity_checker'
  s.version          = '0.0.1'
  s.summary          = 'A Flutter plugin to check app integrity in Android and iOS to detect if app has been tampered with.'
  s.description      = <<-DESC
A Flutter plugin to check app integrity in Android and iOS to detect if app has been tampered with.
                       DESC
  s.homepage         = 'https://github.com/romikavinda/app_integrity_checker'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'romikavinda' => '' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'IOSSecuritySuite'
  s.platform = :ios, '10.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
