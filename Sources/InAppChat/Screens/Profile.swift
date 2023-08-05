import Foundation
import SwiftUI

public struct Profile: View {

  let id: String
  @State var user: User?
  @Environment(\.iacTheme) var theme
  @Environment(\.geometry) var geometry

  public init(id: String) {
    self.id = id
    _user = State(initialValue: User.get(id))
  }

  public var body: some View {
    ZStack(alignment: .top) {
      ScrollView {
        if let user = user {
          UserProfile(user: user).grow()
        } else {
          SpinnerList()
        }
      }.grow().padding(.top, geometry.insets.top + Header<Image>.height + 20.0)
      Header(title: user?.username ?? "") {
        Avatar(url: user?.avatar)
      }
    }.grow().edgesIgnoringSafeArea(.all)
  }
}

public struct UserProfile: View {
  @ObservedObject var user: User
  @Environment(\.iacTheme) var theme
  @Environment(\.geometry) var geometry

  public var body: some View {
    VStack {
      VStack {
        Avatar(url: user.avatar, size: 150.0)
        Text(user.displayNameFb)
          .foregroundColor(theme.colors.text)
          .font(theme.fonts.headline.font)
        ZStack {
          Text(user.status == .online ? "Online" : user.lastSeen?.timeAgo() ?? "")
            .foregroundColor(user.status == .online ? theme.colors.primary : theme.colors.text)
        }.padding(.horizontal, 12.0)
          .padding(.vertical, 5.0)
          .cornerRadius(30.0)
          .background(theme.colors.softBackground)
      }

      if !user.isCurrent {
        Divider()
          .foregroundColor(theme.colors.softBackground)
        NavLink(to: user.chatPath) {
          Row(icon: "paper-plane-tilt-fill", text: "Send a Chat", iconPrimary: true)
        }
      }
//      HStack {
//        Text("Shared Media")
//          .foregroundColor(theme.colors.text)
//          .font(theme.fonts.body.font)
//        Spacer()
//      }.padding(.top, 8.0)
//        .padding(.leading, 16.0)
//      ScrollView(.horizontal, showsIndicators: false) {
//        LazyHStack {
//          ForEach(user.sharedMedia.items, id: \.id) {
//            message in
//            MessageContent(message: message)
//          }
//        }.padding(.leading, 16.0)
//      }
      Spacer().height(24.0)
      Divider().foregroundColor(theme.colors.caption)
      if !user.isCurrent {
        Button {
          user.block()
        } label: {
          Row(
            icon: user.blocked ? "lock-simple-open-fill" : "lock-fill",
            text: "\(user.blocked ? "Unblock" : "Block") \(user.username)",
            iconPrimary: user.blocked,
            destructive: !user.blocked
          )
        }
      }
    }
      .onChange(of: user.blocked) { newValue in
        print("User blocked ", newValue)
      }
  }
}
