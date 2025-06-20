#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_opacity_core.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_opacity_core'
  s.version          = '0.0.1'
  s.summary          = 'Opacity Core for flutter'
  s.description      = <<-DESC
Opacity Core for flutter
                       DESC
  s.homepage         = 'http://opacitylabs.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Opacity Labs' => 'help@opacitylabs.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '14.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  s.dependency 'OpacityCore', '5.6.2'
  s.frameworks = "WebKit", "CoreTelephony", "CoreLocation", "SystemConfiguration"

  # If your plugin requires a privacy manifest, for example if it uses any
  # required reason APIs, update the PrivacyInfo.xcprivacy file to describe your
  # plugin's privacy impact, and then uncomment this line. For more information,
  # see https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
  # s.resource_bundles = {'flutter_opacity_core_privacy' => ['Resources/PrivacyInfo.xcprivacy']}
end
