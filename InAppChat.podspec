Pod::Spec.new do |s|
  s.name         = 'InAppChat'
  s.version      = "1.0.0"
  s.summary      = 'InAppChat Chat iOS Framework'
  s.description  = 'Messaging and Chat API for Mobile Apps and Websites'
  s.homepage     = 'https://inappchat.io'
  s.license      = 'Commercial'
  s.authors      = {
    'Zaid Daghestani' => 'zaid@dag.tech'
  }
  s.source       = { :git => 'https://github.com/RipBullNetworks/inappchat-ios.git', :tag => "1.0.0" }
  s.platform = :ios, '15.0'
  s.documentation_url = 'https://inappchat.io/'
  s.ios.frameworks = ['UIKit', 'CFNetwork', 'Security', 'Foundation', 'MobileCoreServices', 'SystemConfiguration', 'CoreFoundation']
  s.ios.library   = 'icucore'
  s.swift_version = "5.0"
  s.resource_bundles = {
    "InAppChat": ["Sources/InAppChat/Media.xcassets"]
  }
  s.source_files = 'Sources/InAppChat/**/*.swift'
  s.static_framework = true
  s.dependency        'AnyCodable-FlightSchool'
  s.dependency        'SwiftDate'
  s.dependency        'DynamicColor'
  s.dependency        'SDWebImageSwiftUI'
  s.dependency        'ActivityIndicatorView'
  s.dependency        "SwiftyJSON"
  s.dependency        "Alamofire"
  s.dependency        "Giphy"
  s.dependency        "RollbarNotifier"
  s.dependency        "RollbarPLCrashReporter"
  s.dependency        "CocoaMQTT"
  s.dependency        "Auth0"
  s.dependency        "Gifu"
end
