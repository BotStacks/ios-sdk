# Be sure to run `pod lib lint InAppChat.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name = 'InAppChat'
  s.version      = "1.0.18"
  s.summary      = 'InAppChat Chat iOS Framework'
  s.description  = 'Messaging and Chat API for Mobile Apps and Websites'
  s.homepage     = 'https://inappchat.io'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.authors      = {
    'Zaid Daghestani' => 'zaid@dag.tech'
  }
  s.source       = { :git => 'https://github.com/InAppChat/ios.git', :tag => s.version.to_s }
  s.ios.deployment_target = '15.0'
  s.platform = :ios, '15.0'
  s.swift_version = "5.0"
  s.resource_bundles = {
    "InAppChat": ["Sources/InAppChat/Media.xcassets", "Sources/InAppChat/Screens/InAppChat.storyboard", "Sources/**/*.plist", "Sources/InAppChat/Libs/ISEmojiView/Assets/Images.xcassets", "Sources/**/*.xib"]
  }
  s.source_files = 'Sources/InAppChat/**/*.swift'
  s.dependency        'AnyCodable-FlightSchool'
  s.dependency        'SwiftDate'
  s.dependency        'DynamicColor'
  s.dependency        'SDWebImageSwiftUI'
  s.dependency        'ActivityIndicatorView'
  s.dependency        "SwiftyJSON"
  s.dependency        "Giphy"
  s.dependency        "Gifu"
  s.dependency        'Sentry'
  s.dependency        'Apollo'
  s.dependency        'Apollo/WebSocket'
  s.dependency        'SnapKit'
end
