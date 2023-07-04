import Foundation
import SwiftUI

public struct MyProfile: View {

  @Environment(\.iacTheme) var theme
  let onBack: (() -> Void)?

  @State var logout = false

  public init(onBack: (() -> Void)? = nil) {
    self.onBack = onBack
  }

  public var body: some View {
    ScrollView {
      Header(title: "My Profile", showStartMessage: false, showSearch: false, onBack: onBack)
      VStack(alignment: .center) {
        Avatar(url: User.current?.avatar, size: 150.0)
        Text(
          .init(User.current?.displayNameFb ?? "")
        )
        .foregroundColor(theme.colors.text)
        .frame(maxWidth: 150.0)
        .truncationMode(.middle)
        .multilineTextAlignment(.center)
      }
      NavLink(to: "/profile") {
        Row(icon: "user-fill", text: "Profile")
      }
      NavLink(to: "/favorites") {
        Row(icon: "star-fill", text: "Favorite Messages")
      }
      NavLink(to: "/settings/notifications") {
        Row(
          icon: "bell-simple-fill", text: "Manage Notifications"
        )
      }
      Row(icon: "door-fill", text: "Logout")
        .onTapGesture {
          logout = true
        }
      Spacer()
    }.edgesIgnoringSafeArea(.all)
      .alert("Are you sure you want to log out?", isPresented: $logout) {
        Button {
          logout = false
        } label: {
          Text("Cancel")
            .foregroundColor(theme.colors.caption)
            .font(theme.fonts.headline)
        }

        Button {
          InAppChat.logout()
        } label: {
          Text("Log Out")
            .foregroundColor(theme.colors.primary)
            .font(theme.fonts.headline)
        }
      }
  }
}
