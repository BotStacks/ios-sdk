//
//  CreateGroup.swift
//  InAppChat
//
//  Created by Zaid Daghestani on 2/9/23.
//

import Foundation
import SwiftUI

class CreateGroupState: ObservableObject {

  @Published var group: Group? = nil
  @Published var image: URL? = nil
  @Published var name: String = ""
  @Published var description: String = ""
  @Published var _private = false
  @Published var users: [Participant] = []

  func apply(_ group: Group) {
    self.group = group
    self.image = group.image.flatMap({ URL(string: $0) })
    self.name = group.name
    self.description = group.description ?? ""
    self._private = group._private
    self.users = group.participants
  }

  func commit() async {
    await self.group?.update(
      name: name != group?.name ? name : nil,
      description: group?.description != description ? description : nil,
      image: group?.image != image?.absoluteString ? image : nil,
      _private: group?._private != _private ? _private : nil
    )
  }

  static var current: CreateGroupState? = nil

  static func currentOrNew() -> CreateGroupState {
    if current == nil {
      current = CreateGroupState()
    }
    return current!
  }
}

public struct CreateGroup: View {

  @Environment(\.iacTheme) var theme
  @EnvironmentObject var navigator: Navigator
  @Environment(\.geometry) var geometry

  enum Field: Hashable {
    case name
    case description
  }

  @FocusState private var focus: Field?

  @ObservedObject var state = CreateGroupState.currentOrNew()
  @State var pickImage = false

  public init(_ groupID: String? = nil) {
    if let groupID = groupID, let group = Group.get(groupID) {
      state.apply(group)
    }
  }

  var canGoNext: Bool {
    return state.name.count >= 3 && state.name.count <= 25 && state.description.count <= 100
  }

  public var body: some View {
    VStack(alignment: .leading) {
      Header(
        title: "Create Channel",
        onBack: {
          navigator.goBack()
          CreateGroupState.current = nil
        })
      ScrollView {
        VStack {
          VStack {
            Button {
              pickImage = true
            } label: {
              if let image = state.image {
                GifImageView(url: image)
                  .circle(116, theme.colors.softBackground)
              } else {
                AssetImage("plus-circle-fill")
                  .resizable()
                  .foregroundColor(theme.colors.softBackground)
                  .size(95)
              }
            }
          }
          VStack {
            VStack {
              HStack {
                Text("Channel Name")
                  .font(theme.fonts.headline)
                  .foregroundColor(theme.colors.text)
                Spacer()
                Text("\(state.name.count)/25")
                  .font(theme.fonts.headline)
                  .foregroundColor(
                    theme.colors.caption
                  )
              }
              HStack {
                TextField(
                  text: $state.name,
                  prompt: Text("Type here").font(theme.fonts.headline)
                    .foregroundColor(
                      theme.colors.caption),
                  label: {}
                )
                .background(.clear)
                .font(theme.fonts.headline)
                .foregroundColor(theme.colors.text)
                .onChange(of: state.name) {
                  state.name = String($0.prefix(25))
                }.focused($focus, equals: .name)
              }.growX()
                .padding(.horizontal, 20)
                .height(50)
                .background(theme.colors.softBackground)
                .cornerRadius(25)
                .overlay(
                  RoundedRectangle(cornerRadius: 25).stroke(theme.colors.border, lineWidth: 1)
                )
                .onTapGesture {
                  focus = .name
                }
            }
            VStack {
              HStack {
                Text("Description (Optional)")
                  .font(theme.fonts.headline)
                  .foregroundColor(theme.colors.text)
                Spacer()
                Text("\(state.description.count)/100")
                  .font(theme.fonts.headline)
                  .foregroundColor(
                    theme.colors.caption
                  )
              }
              ZStack(alignment: .topLeading) {
                let e = TextEditor(text: $state.description)
                  .background(.clear)
                  .grow()
                  .font(theme.fonts.headline)
                  .foregroundColor(theme.colors.text)
                  .focused($focus, equals: .description)
                  .onChange(
                    of: state.description,
                    perform: { newValue in
                      state.description = String(newValue.prefix(100))
                    })
                if #available(iOS 16.0, *) {
                  e.scrollContentBackground(.hidden)
                } else {
                  e.onAppear {
                    UITextView.appearance().backgroundColor = .clear
                  }
                }

                if state.description.isEmpty && focus != .description {
                  Text("Showcase what your channel is all about for everyone to see").font(
                    theme.fonts.headline
                  ).foregroundColor(theme.colors.caption)
                }
              }.growX()
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .height(128)
                .background(theme.colors.softBackground)
                .cornerRadius(25)
                .overlay(
                  RoundedRectangle(cornerRadius: 25).stroke(theme.colors.border, lineWidth: 1)
                )
                .onTapGesture {
                  focus = .description
                }
            }
            VStack(alignment: .leading) {
              Text("Privacy Setting")
                .font(theme.fonts.headline)
                .foregroundColor(theme.colors.text)
                .padding(.leading, 8)
              ZStack {
                HStack {
                  if state._private {
                    Spacer()
                  }
                  Capsule()
                    .fill(theme.colors.primary)
                    .frame(width: (geometry.width - 32.0) / 2.0, height: 50)
                  if !state._private {
                    Spacer()
                  }
                }
                HStack {
                  Button {
                    state._private = false
                  } label: {
                    ZStack {
                      Text("Public")
                        .font(theme.fonts.title3)
                        .foregroundColor(
                          state._private ? theme.colors.text : theme.colors.background
                        )
                    }.grow()
                  }
                  Button {
                    state._private = true
                  } label: {
                    ZStack {
                      Text("Private")
                        .font(theme.fonts.title3)
                        .foregroundColor(
                          !state._private ? theme.colors.text : theme.colors.background)
                    }.grow()
                  }
                }.grow()
              }.growX()
                .overlay(
                  RoundedRectangle(cornerRadius: 25).stroke(theme.colors.border, lineWidth: 1)
                )
                .height(50)
                .background(theme.colors.softBackground)
                .cornerRadius(25)
              Text(
                state._private
                  ? "Public channels will be viewed by all and available for everyone to join."
                  : "Private channels will not be seen by anyone unless they are invited to join the channel."
              )
              .font(theme.fonts.caption)
              .foregroundColor(theme.colors.text)
            }
            Spacer()
            HStack {
              Spacer()
              Button {
                if canGoNext {
                  if state.group != nil {
                    Task.detached {
                      await state.commit()
                      await MainActor.run {
                        navigator.goBack()
                      }
                    }
                  } else {
                    navigator.navigate("invite")
                  }
                }
              } label: {
                if state.group != nil {
                  VStack {
                    HStack {
                      if state.group?.updating == true {
                        Spinner().size(35)
                          .foregroundColor(theme.colors.background)
                      }
                      Text("Save")
                        .font(theme.fonts.headline)
                        .foregroundColor(theme.colors.text)
                    }
                  }.growX()
                    .height(50)
                    .background(canGoNext ? theme.colors.primary : theme.colors.caption)
                    .cornerRadius(25)
                } else {
                  ZStack {
                    Image(systemName: "chevron.right")
                      .resizable()
                      .scaledToFit()
                      .size(20)
                      .tint(theme.colors.background)
                  }.circle(50, canGoNext ? theme.colors.primary : theme.colors.caption)
                }
              }
            }
          }.padding(.horizontal, 16.0)
        }
        .padding(.bottom, geometry.insets.bottom + 12.0)
        .padding(.top, 12.0)
        .frame(minHeight: geometry.height - geometry.insets.top - Header<EmptyView>.height)
      }
    }.grow()
      .background(theme.colors.background)
      .sheet(isPresented: $pickImage) {
        PhotoPicker(video: false, onProgress: { $0.resume() }) {
          self.state.image = $0
        }
      }
  }
}
