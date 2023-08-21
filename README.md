# InAppChat iOS

[![CodeFactor](https://www.codefactor.io/repository/github/ripbullnetworks/inappchat-ios/badge)](https://www.codefactor.io/repository/github/ripbullnetworks/inappchat-ios) ![Cocoapods](https://img.shields.io/cocoapods/v/InAppChat?style=flat-square) ![GitHub issues](https://img.shields.io/github/issues/RipBullNetworks/inappchat-ios) ![GitHub commit activity](https://img.shields.io/github/commit-activity/y/ripbullnetworks/inappchat-ios)

Delightful chat for your iOS apps

## Overview

This SDK integrates a fully serviced chat experience on the [InAppChat](https://inappchat.io) platform.

## Installation

This SDK is accessible via conventional means as a Cocoapod

### CocoaPods

Add the pod to your podfile

`pod "InAppChat"`

## Usage

### Initialize the SDK

In your app delegate, or anywhere else you put your startup logic, initialize the InAppChat SDK

```swift
InAppChat.setup(apiKey: apiKey)
```

Note, you can optionally delay load and later call `InAppChat.shared.load` to load IAC in whatever load sequence you please

### Display the UI

#### UIKit

If you're using UI kit, just push or present the InAppChat controller from anywhere in your UI code. For example, on a messaging button press:

```swift
@IBAction func onPressMessaging() {
  let inapphatController = InAppChatController.instance()
  self.navigationController?.push(inappchatController, animated: true)
  // or you can present
  self.present(inappchatController, animated: true)
}
```

#### SwiftUI

Render InAppChat in any full screen view by rendering InAppChatView. Include a logout handler to return to your own UI upon user logout.

```swift
struct ContentView: View {

  var body: some View {
    InAppChatView {
      // handle logout
      displayUserLogin()
    }
  }
}
```

## Theming

You can theme your InAppChat UI by passing in a theme to `InAppChat` any time before displaying the UI. The theme supports fonts, colors and things like bubble border radius and image sizes. Provide a `Theme` to InAppChatUI

```swift
InAppChat.set(theme: Theme())
```

### Colors

You can provide your own color themes to the theme object with a wide array of parameters. The UI kit uses both a light and a dark theme so provide both.

```swift
InAppChat.set(
theme:
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
```

### Fonts

The UI kit uses the same Fonts styles as the iOS. You can provide your own Fonts object to customize those fonts:

```swift
InAppChat.set(theme:
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
```

### Assets

There are customizable assets and text that you can use in your UI Kit as well. Most importantly is the default image you want to use for groups.

```swift
InAppChat.set(theme:
  Theme(
    assets: Assets(group: Image("my-group-placeholder"))
  )
)
```

There are empty screen configurations as well:

```swift
  InAppChat.set(theme:
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
```

Fin!

All content copyright Rip Bull Networks, Inc
