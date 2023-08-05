import Foundation
import SwiftUI
import UIKit

public struct Header<Content>: View where Content: View {

  public static var height: CGFloat {
    return 44.0
  }

  @Environment(\.iacTheme) var theme
  @Environment(\.geometry) var geometry
  @EnvironmentObject var navigator: Navigator

  public let title: String
  public let showStartMessage: Bool
  public let showSearch: Bool
  public let onBack: (() -> Void)?
  public let onMenu: (() -> Void)?
  public let icon: (() -> Content)?
  public let addPath: String?

  public init(
    title: String, showStartMessage: Bool = false, showSearch: Bool = false,
    onBack: (() -> Void)? = nil,
    background: Color? = nil,
    onMenu: (() -> Void)? = nil,
    addPath: String? = nil,
    icon: (() -> Content)?
  ) {
    self.title = title
    self.showStartMessage = showStartMessage
    self.showSearch = showSearch
    self.onBack = onBack
    self.onMenu = onMenu
    self.addPath = addPath
    self.icon = icon
  }

  var back: (() -> Void)? {
    print("HEader Geometry \(geometry)")
    return onBack ?? (navigator.canGoBack ? { navigator.goBack() } : nil)
  }

  public var body: some View {
    VStack {
      HStack(alignment: .center) {
        if let back = back {
          Button {
            print("Header back button back")
            back()
          } label: {
            Image(systemName: "chevron.left")
              .resizable()
              .scaledToFit()
              .foregroundColor(theme.colors.text)
              .size(20)
          }.size(Header.height)
        }
        if let icon = icon {
          icon()
        }
        Text(title)
          .font(theme.fonts.title.font.bold())
          .foregroundColor(theme.colors.text)
        Spacer(minLength: 44.0)
        if let addPath = addPath {
          NavLink(to: addPath) {
            ZStack {
              Circle().fill(theme.colors.button)
              Image(
                systemName: "plus"
              ).resizable()
                .scaledToFit()
                .size(16.0)
                .tint(theme.colors.text)
            }.size(40)
          }
        }
        if showSearch {
          NavLink(to: "/search") {
            ZStack {
              Circle().fill(theme.colors.button)
              Image(
                systemName: "magnifyingglass"
              ).resizable()
                .scaledToFit()
                .size(16.0)
                .foregroundColor(theme.colors.text)
            }
            .size(40)
          }
        }
//        if showStartMessage {
//          NavLink(to: "/chats/new") {
//            ZStack {
//              Circle().fill(theme.colors.button)
//              Image(
//                systemName: "message.fill"
//              ).resizable()
//                .scaledToFit()
//                .size(16.0)
//                .foregroundColor(theme.colors.text)
//            }.size(40)
//          }
//        }

        if let onMenu = onMenu {
          Button {
            onMenu()
          } label: {
            ZStack {
              // Circle().fill(theme.colors.button)
              AssetImage(
                "dots-three-vertical-fill"
              ).image.resizable()
                .size(30.0)
                .foregroundColor(theme.colors.text)
            }.size(40)
          }
        }
      }.padding(.leading, 16.0)
        .padding(.trailing, 8.0)
        .height(Header.height)
    }
    .padding(.top, geometry.insets.top)
    .background(.thinMaterial)
    .edgesIgnoringSafeArea(.top)
  }
}

extension Header where Content == Image {
  public init(
    title: String, showStartMessage: Bool = false, showSearch: Bool = false,
    onBack: (() -> Void)? = nil,
    onMenu: (() -> Void)? = nil,
    addPath: String? = nil,
    background: Color? = nil
  ) {
    self.init(
      title: title, showStartMessage: showStartMessage, showSearch: showSearch,
      onBack: onBack, background: background, onMenu: onMenu, addPath: addPath, icon: nil)
  }
}
