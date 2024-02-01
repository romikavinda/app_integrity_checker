#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint app_integrity_checker.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'app_integrity_checker'
  s.version          = '1.0.3'
  s.summary          = 'Flutter plugin to verify the integrity of the app and detect if it has been tampered at run time.'
  s.description      = <<-DESC
Flutter plugin to verify the integrity of the app and detect if it has been tampered at run time.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'romikavinda' => '' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'IOSSecuritySuite'
  s.platform = :ios, '11.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
