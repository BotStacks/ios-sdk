[![CodeFactor](https://www.codefactor.io/repository/github/ripbullnetworks/inappchat-ios/badge)](https://www.codefactor.io/repository/github/ripbullnetworks/inappchat-ios) ![Cocoapods](https://img.shields.io/cocoapods/v/InAppChat?style=flat-square) ![GitHub issues](https://img.shields.io/github/issues/RipBullNetworks/inappchat-ios) ![GitHub commit activity](https://img.shields.io/github/commit-activity/y/ripbullnetworks/inappchat-ios)

![IAC IOS](https://github.com/ShadowArcanist/IACios/assets/106978117/45eba8e1-bb01-4dce-8c79-68ab8a1056b3)

# In-AppChat iOS SDK

> Delightful chat for your iOS apps. Try it out, download [In-AppChat iOS](https://apps.apple.com/us/app/inappchat/id6448892489)

&nbsp;  

# 📃 Table of Contents
- [Overview](https://github.com/ShadowArcanist/IACios/blob/main/README.md#-overview)
- [Installation](https://github.com/ShadowArcanist/IACios/blob/main/README.md#-installation)
- [Getting Started](https://github.com/ShadowArcanist/IACios/blob/main/README.md#-getting-started)
- [Theming](https://github.com/ShadowArcanist/IACios/blob/main/README.md#-Theming)
- [Running the Sample App](https://github.com/ShadowArcanist/IACios/blob/main/README.md#-running-the-sample-app)

&nbsp;  

# ✨ Overview

This SDK integrates a fully serviced chat experience on the [InAppChat](https://inappchat.io) platform. 

**InAppChat provides the entire UI and backend to enable chat for your users.**

All you have to do is log your user in to the SDK and display the InAppChat view controller. 

&nbsp;  

You can also checkout the `/Example` directory for a running example of an InAppChat enabled app.

&nbsp;  

# ⚙ Installation

This SDK is accessible via conventional means as a Cocoapod

```
.package(url: "https://github.com/RipBullNetworks/inappchat-ios", .upToNextMajor(from: "1.0.0")),
```

&nbsp;  

### CocoaPods

Add the pod to your podfile

```
pod "InAppChat"
```

&nbsp;  

# 🚀 Getting Started


### Step 1: Initialize the SDK

In your app delegate, or anywhere else you put your startup logic, initialize the InAppChat SDK

```swift
BotStacksChat.setup(apiKey: apiKey)
```

&nbsp;  

Note, you can optionally delay load and later call `InAppChat.shared.load` to load IAC in whatever load sequence you please

&nbsp;  

### Step 2: Log your user in

Before displaying the UI, you **must** log your user in to InAppChat via one of the designatied login methods. 

The methods return a boolean indicating if the user is logged in or not.

```swift
@IBAction func loginToInAppChat() {
  self.loading = true
  Task.detached {
    do {
      let loggedIn = try await InAppChat.shared.login(
            accessToken: nil,
            userId: id,
            username: nickname,
            picture: picture,
            displayName: name
          )
      if loggedIn {
        displayInAppChat()
      }
    } catch let err {
      print("error logging in \(err)")
    }
  }
}
```

&nbsp;  

InAppChat as well as all other state objects in the SDK extend `ObservableObject`. InAppChat maintains an `@Published` isUserLoggedIn that you can use in your SwiftUI apps as well. You can also listen to the `Chats` object which holds state for the entire InAppChat interface.

&nbsp;  

Listen to InAppChat using combine in your view controllers:

```swift
InAppChat.shared.objectWillChange
  .makeConnectable()
  .autoconnect()
  .sink(receiveValue: {[weak self] _ in
    DispatchQueue.main.async {
      // update my chat UI
    }
  }).store(in: bag)
```

&nbsp;  

Use `@ObservedObject` in your SwiftUI

```swift
public struct MyView: View {
  @ObservedObject var inappchat = InAppChat.shared

  public var body: some View {
    ZStack {
      if inappchat.isUserLoggedIn {
        // Render InAppChat UI
        InAppChatView {
          // handle logout
        }
      } else {
        MyLoginView()
      }
    }
  }
}
```

&nbsp;  

## Step 3: Display the UI

### A. UIKit

If you're using UI kit, just push or present the InAppChat controller from anywhere in your UI code. For example, on a messaging button press:

```swift
@IBAction func onPressMessaging() {
  let inapphatController = BotStacksChatController.instance()
  self.navigationController?.push(inappchatController, animated: true)
  // or you can present
  self.present(inappchatController, animated: true)
}
```

&nbsp;  

### B. SwiftUI

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

&nbsp;  

## Step 4: Enabling Giphy support

The UI Kit comes with support for Giphy built in. If you'd to have Giphy enabled in your chat app, get a Giphy API key from [Giphy](https://developers.giphy.com/). Then import and setup in Giphy SDK in your startup code:

```swift
import GiphyUISDK

func onAppStartup() {
  Giphy.configure(apiKey: "your-api-key")
}

```

&nbsp;  

# 🖍 Theming

You can theme your InAppChat UI by passing in a theme to `InAppChat` any time before displaying the UI. The theme supports fonts, colors and things like bubble border radius and image sizes. Provide a `Theme` to InAppChatUI

```swift
InAppChat.set(theme: Theme())
```

&nbsp;  

### A. Colors

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

&nbsp;  

### B. Fonts

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

&nbsp;  

### C. Assets

There are customizable assets and text that you can use in your UI Kit as well. Most importantly is the default image you want to use for groups.

```swift
InAppChat.set(theme:
  Theme(
    assets: Assets(group: Image("my-group-placeholder"))
  )
)
```

&nbsp;  

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

&nbsp;  

# ⚡ Running the Sample App

Get an API key at [InAppChat](https://inappchat.io/app) by clicking on your project and clicking project settings in the top right.

Get a Giphy API key if you'd like Giphy in your Sample.

Add both keys to the `Example/InAppChat-Example/InAppChat_ExampleApp.swift`

**Run the app**

&nbsp;  

# 🙋‍♂️ Help

If you don't understand something in the documentation, you are experiencing problems, or you just need a gentle nudge in the right direction, please join our [Discord server](https://discord.com/invite/5kwyQCz3zZ)

---
**All Content Copyright © 2023 Rip Bull Networks**
