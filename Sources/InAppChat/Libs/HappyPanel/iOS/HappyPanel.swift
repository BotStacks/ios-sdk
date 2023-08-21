//
//  HappyPanel.swift
//  HappyPanel
//
//  Created by Huong Do on 8/25/20.
//  Copyright © 2020 ichigo. All rights reserved.
//

import SwiftUI

enum HPConstants {
  static let screenHeight = UIScreen.main.bounds.size.height
  static let maxHeight: CGFloat = screenHeight - 24
  static let midHeight: CGFloat = UIScreen.main.bounds.size.height / 2
  static let minHeight: CGFloat = 0
  
  static let halfOffset: CGFloat = maxHeight - midHeight
  static let fullOffset: CGFloat = 24
  static let hiddenOffset: CGFloat = screenHeight
}


struct HappyPanel: View {

  @Binding var isOpen: Bool
  let onEmoji: (String) -> Void

  public init(isOpen: Binding<Bool>, onEmoji: @escaping (String) -> Void) {
    self._isOpen = isOpen
    self.onEmoji = onEmoji
  }

  @State var calculatedOffsetY: CGFloat = HPConstants.halfOffset
  @State var lastOffsetY: CGFloat = HPConstants.halfOffset
  @State var isDraggingDown: Bool = false

  @ObservedObject var sharedState = SharedState()

  var offsetY: CGFloat {
    guard isOpen else { return HPConstants.hiddenOffset }
    let shouldToggleFromHalfState =
      sharedState.currentCategory != SharedState.defaultCategory
      && lastOffsetY == HPConstants.halfOffset

    if sharedState.isSearching || shouldToggleFromHalfState {
      DispatchQueue.main.async {
        self.calculatedOffsetY = HPConstants.fullOffset
        self.lastOffsetY = HPConstants.fullOffset
      }

      return lastOffsetY
    }

    return calculatedOffsetY
  }

  var body: some View {
    ZStack {
      MainContent()
        .offset(y: offsetY)
        .animation(.spring(), value: UUID())
        .gesture(panelDragGesture)
        .onChange(of: sharedState.selectedEmoji) { value in
          if let value = value {
            onEmoji(value.string)
            EmojiStore.saveRecentEmoji(value)
            resetViews()
          }
        }
        .environmentObject(sharedState)
        .edgesIgnoringSafeArea(.bottom)
        .background(dimmedBackground)

      if isOpen, !isDraggingDown, !sharedState.isSearching, sharedState.keyword.isEmpty {
        self.sectionPicker
      }
    }
  }

  private var dimmedBackground: some View {
    Color.black.opacity(0.7)
      .edgesIgnoringSafeArea(.all)
      .opacity(isOpen ? 1 : 0)
      .animation(.easeIn, value: UUID())
      .onTapGesture {
        resetViews()
      }
  }

  private var displayedCategories: [String] {
    if EmojiStore.fetchRecentList().isEmpty {
      return SectionType.defaultCategories.map { $0.rawValue }
    }
    return SectionType.allCases.map { $0.rawValue }
  }

  private var sectionPicker: some View {
    VStack {
      Spacer()

      SectionIndexPicker(sections: displayedCategories)
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
        .environmentObject(sharedState)
    }
  }

  private var panelDragGesture: some Gesture {
    DragGesture()
      .onChanged { gesture in
        
        isDraggingDown = gesture.translation.height > 0
        calculatedOffsetY = max(gesture.translation.height + lastOffsetY, HPConstants.fullOffset)
      }
      .onEnded { gesture in
        calculatedOffsetY = max(gesture.translation.height + lastOffsetY, HPConstants.fullOffset)

        // magnet
        if isDraggingDown,
          calculatedOffsetY >= HPConstants.halfOffset
        {
          calculatedOffsetY = HPConstants.hiddenOffset
          resetViews()
        } else {
          calculatedOffsetY = HPConstants.fullOffset
        }

        lastOffsetY = calculatedOffsetY
        isDraggingDown = false
      }
  }

  private func resetViews() {
    calculatedOffsetY = HPConstants.halfOffset
    lastOffsetY = calculatedOffsetY
    isOpen = false
    sharedState.resetState()
  }
}

struct HappyPanel_Previews: PreviewProvider {
  static var previews: some View {
    HappyPanel(
      isOpen: .constant(true)
    ) { print($0) }
  }
}
