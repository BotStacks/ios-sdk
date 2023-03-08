Pod::Spec.new do |s|
  s.name = 'InAppChat'
  s.ios.deployment_target = '15.0'
  s.osx.deployment_target = '10.11'
  s.version = '1.0.0'
  s.source = { :git => 'git@github.com:RipBullNetworks/inappchat-ios.git', :tag => 'v1.0.0' }
  s.authors = 'Zaid Daghestani'
  s.summary  = 'Quickly and easily integrate fully featured chat into your iOS application'
  s.description      = <<-DESC
    In App Chat iOS SDK.
    Quickly and easily integrated fully featured chat into your iOS applications.
  DESC
  s.social_media_url = 'https://twitter.com/inappchat'
  s.license = "MIT"
  s.homepage = 'https://inappchat.io'
  s.documentation_url = 'https://inappchat.io/docs/chatsdk/ios'
  s.pod_target_xcconfig = { 'PRODUCT_BUNDLE_IDENTIFIER': 'io.inappchat.sdk' }
  s.ios.deployment_target = '15.0'
  s.dependency        'AnyCodable-FlightSchool'
  s.dependency        'SwiftDate'
  s.dependency        'DynamicColor'
  s.dependency        'Nuke'
  s.dependency        'NukeUI'
  s.dependency        'ActivityIndicatorView'
  s.dependency        'Fakery'
  s.dependency        "SwiftyJSON"
  s.dependency        "Introspect"
  s.dependency        "Alamofire"
  s.dependency        "Giphy"
  s.dependency        "RollbarNotifier"
  s.dependency        "RollbarPLCrashReporter"
  s.dependency        "CocoaMQTT"
  s.dependency        "Auth0"
  s.dependency        "Gifu"

  vendored_frameworks = "InAppChat.xcframework"
end
