# InAppChat iOS

Delightful chat for your iOS apps

## Overview

This SDK integrates a fully serviced chat experience on the [InAppChat](https://inappchat.io) platform.

## Installation

This SDK is accessible via conventional means as a Swift PM, CocoaPods or Carthage

### Swift PM

Add the dependency to your package

`.package(url: "https://github.com/RipBullNetworks/inappchat-ios", .upToNextMajor(from: "1.0.0")),`

### CocoaPods

Add the pod to your podfile

`pod "InAppChat", :git`

### Carthage

Add it to your Cartfile

`github "RipBullNetworks/inappchat-ios"`

## Usage

### Initialize the SDK

In your app delegate, or anywhere else you put your startup logic, initialize the InAppChat SDK

```swift
InAppChat.setup(namespace: namespace, apiKey: apiKey, delayLoad: true)
```

Note, you can optionally delay load and later call `InAppChat.shared.load` to load IAC in whatever load sequence you please

### Render the UI

Render in app chat in any view by rendering InAppChatUI You can include any

```swift
struct ContentView: View {

  var body: some View {
    InAppChatUI()
  }
}
```

## Theming

You can theme your InAppChat UI kit by passing in a theme to `InAppChatUI`. The theme supports fonts, colors and things like bubble border radius and image sizes. Provide a `Theme` to InAppChatUI

```swift
struct ContentView: View {

  var body: some View {
    InAppChatUI(theme: Theme())
  }
}
```

### Colors

You can provide your own color themes to the theme object with a wide array of parameters. The UI kit uses both a light and a dark theme so provide both.

```swift
struct ContentView: View {

  var body: some View {
    InAppChatUI(theme:
      Theme(
        light:
          Colors(
            primary: .blue,
            background: .white
          ),
        dark:
          Colors(
            primary: .blue,
            background: .black
          )
        )
      )
  }
}
```

### Fonts

The UI kit uses the same Fonts styles as the iOS. You can provide your own Fonts object to customize those fonts:

```swift
struct ContentView: View {

  var body: some View {
    InAppChatUI(theme:
      Theme(
        fonts: Fonts(
          title: .app(22, .black),
          title2: .app(20, .heavy),
          title2Regular: .app(20),
          title3: .app(16, .heavy),
          headline: .app(16, .bold),
          body: .app(14),
          caption: .app(12)
        )
      )
    )
  }
}
```

### Assets

There are customizable assets and text that you can use in your UI Kit as well. Most importantly is the default image you want to use for groups.

```swift
struct ContentView: View {

  var body: some View {
    InAppChatUI(theme:
      Theme(
        assets: Assets(group: Image("my-group-placeholder"))
      )
    )
  }
}
```

There are empty screen configurations as well:

```swift
struct ContentView: View {

  var body: some View {
    InAppChatUI(theme:
      Theme(
        emptyChannels: EmptyScreenConfig(
          image: Image("empty-channels"),
          caption: "You haven't joined any channels yet"),
        emptyChat: EmptyScreenConfig(
          image: Image("empty-chat"),
          caption: "Your friends are ***dying*** to see you"
        ),
        emptyThreads: EmptyScreenConfig(
          image: Image("empty-threads"),
          caption: "You haven't added to any threads yet"),
        emptyAllChannels: EmptyScreenConfig(
          image: Image("empty-all-channels"),
          caption: "It's dead in here"
        )
      )
    )
  }
}
```

Fin!

All content copyright Rip Bull Networks, Inc
