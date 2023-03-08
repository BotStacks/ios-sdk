// swift-tools-version:5.7

import PackageDescription

let package = Package(
  name: "InAppChat",
  platforms: [
    .iOS(.v15)
  ],
  products: [
    // Products define the executables and libraries produced by a package, and make them visible to other packages.
    .library(
      name: "InAppChat",
      targets: ["InAppChat"]
    ),
    .library(name: "InAppChatDeps", targets: ["InAppChatDeps"]),
  ],
  dependencies: [
    // Dependencies declare other packages that this package depends on.
    .package(url: "https://github.com/Flight-School/AnyCodable", .upToNextMajor(from: "0.6.1")),
    .package(url: "https://github.com/malcommac/SwiftDate.git", from: "7.0.0"),
    .package(url: "https://github.com/yannickl/DynamicColor.git", from: "5.0.0"),
    .package(url: "https://github.com/exyte/ActivityIndicatorView.git", from: "1.1.0"),
    .package(url: "https://github.com/vadymmarkov/Fakery", from: "5.0.0"),
    .package(url: "https://github.com/kean/Nuke", from: "12.0.0-rc.1"),
    .package(url: "https://github.com/rollbar/rollbar-apple.git", from: "2.4.0"),
    .package(url: "https://github.com/SwiftyJSON/SwiftyJSON", from: "5.0.0"),
    .package(url: "https://github.com/Giphy/giphy-ios-sdk", from: "2.1.3"),
    .package(url: "https://github.com/siteline/SwiftUI-Introspect.git", from: "0.2.0"),
    .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.6.1")),
    .package(url: "https://github.com/emqx/CocoaMQTT", .upToNextMajor(from: "2.0.0")),
    .package(url: "https://github.com/kaishin/Gifu", .upToNextMajor(from: "3.0.0")),
    .package(url: "https://github.com/auth0/Auth0.swift", .upToNextMajor(from: "2.0.0")),
  ],
  targets: [
    .binaryTarget(
      name: "InAppChat",
      path: "InAppChat.xcframework"),
    .target(
      name: "InAppChatDeps",
      dependencies: [
        "AnyCodable",
        "SwiftDate",
        "DynamicColor",
        "ActivityIndicatorView",
        "Fakery",
        "Nuke",
        .product(name: "NukeUI", package: "nuke"),
        .product(name: "RollbarPLCrashReporter", package: "rollbar-apple"),
        .product(name: "RollbarSwift", package: "rollbar-apple"),
        "SwiftyJSON",
        .product(name: "GiphyUISDK", package: "giphy-ios-sdk"),
        .product(name: "Introspect", package: "SwiftUI-Introspect"),
        "Alamofire",
        "CocoaMQTT",
        "Gifu",
        "Auth0.swift",
      ], path: "Sources"),
  ]
)
