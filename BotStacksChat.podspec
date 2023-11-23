# Be sure to run `pod lib lint BotStacksChat.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name = 'BotStacksChat'
  s.version      = "1.0.32"
  s.summary      = 'BotStacks Chat iOS Framework'
  s.description  = 'Messaging and Chat API for Mobile Apps and Websites'
  s.homepage     = 'https://botstacks.ai'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.authors      = {
    'Brent Walter' => 'brent@ripbullnetworks.com'
  }
  s.source       = { :git => 'https://github.com/InAppChat/ios.git', :tag => s.version.to_s }
  s.ios.deployment_target = '15.0'
  s.platform = :ios, '15.0'
  s.swift_version = "5.0"
  s.resource_bundles = {
    "BotStacksChat": ["Sources/BotStacksChat/Media.xcassets", "Sources/BotStacksChat/Screens/BotStacksChat.storyboard", "Sources/**/*.plist", "Sources/BotStacksChat/Libs/ISEmojiView/Assets/Images.xcassets", "Sources/**/*.xib"]
  }
  s.source_files = 'Sources/BotStacksChat/**/*.swift'
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
