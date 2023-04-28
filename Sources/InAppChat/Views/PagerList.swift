//
//  PagerList.swift
//  InAppChat
//
//  Created by Zaid Daghestani on 1/27/23.
//

import Foundation
import SwiftUI

let defaultSpacing: CGFloat = 8.0

public struct PagerList<T, Header, Content, Footer, Empty>: View
where T: Identifiable, Header: View, Content: View, Footer: View, Empty: View {

  @ObservedObject var pager: Pager<T>
  let prefix: [T]
  let invert: Bool
  let spacing: CGFloat
  let header: (() -> Header)?
  let content: (T) -> Content
  let footer: (() -> Footer)?
  let empty: (() -> Empty)?
  let divider: Bool
  let topInset: CGFloat
  let bottomInset: CGFloat

  @Environment(\.iacTheme) var theme
  @Environment(\.geometry) var geometry

  public init(
    pager: Pager<T>,
    prefix: [T]? = nil,
    invert: Bool = false,
    spacing: CGFloat? = 8.0,
    divider: Bool = false,
    topInset: CGFloat = 0.0,
    bottomInset: CGFloat = 0.0,
    header: (() -> Header)?,
    empty: (() -> Empty)?,
    footer: (() -> Footer)?,
    content: @escaping (T) -> Content
  ) {
    self.pager = pager
    self.prefix = prefix ?? []
    self.invert = invert
    self.spacing = spacing ?? 8.0
    self.content = content
    self.topInset = topInset
    self.bottomInset = bottomInset
    self.divider = divider
    self.header = header
    self.empty = empty
    self.footer = footer
  }

  public var body: some View {
    let items = self.prefix + pager.items
    if items.isEmpty && !pager.hasMore {
      return AnyView(
        VStack {
          Spacer().height(topInset)
          if let header = header {
            header()
          }
          Spacer(minLength: 0)
          VStack {
            if let empty = empty {
              empty()
            }
          }.padding(.horizontal, 16.0)
          Spacer(minLength: 0)
          if let footer = footer {
            footer()
          }
          Spacer().height(bottomInset + 12.0)
        }.refreshable {
          await pager.refresh()
        }.onAppear {
          print("Rendered empty stack")
        })
    } else {
      return AnyView(
        List(items, id: \.id) { item in
          let isFirst = item.id == items.first?.id
          let isLast = item.id == items.last?.id
          VStack {
            if (!invert && isFirst) || (isLast && invert) {
              Spacer().height(topInset)
              if let header = header {
                header()
              }
            }
            content(item)
            if (!invert && isLast) || (invert && isFirst) {
              if let footer = footer {
                footer()
              }
              Spacer().height(bottomInset + 12.0)
            } else if divider {
              Divider()
                .overlay(theme.colors.caption)
            }
          }
          .listRowInsets(edgeInsetsZero)
          .listRowBackground(Color.clear)
          .listRowSeparator(.hidden)
          .padding(isFirst ? .bottom : isLast ? .top : .vertical, spacing / 2.0)
          .invert(invert)
          .onAppear {
            pager.loadMoreIfNeeded(item)
          }.id(item.id)
        }
        .listItemTint(.clear)
        .listStyle(.plain)
        .invert(invert)
        .refreshable {
          await pager.refresh()
        }.onAppear {
          print("list on appear", pager.items.count, pager.hasMore)
          if pager.items.isEmpty {
            pager.loadMore()
          }
        })
    }
  }
}

extension PagerList where Header == EmptyView {
  public init(
    pager: Pager<T>,
    prefix: [T]? = nil,
    invert: Bool = false,
    spacing: CGFloat? = nil,
    divider: Bool = false,
    topInset: CGFloat = 0.0,
    bottomInset: CGFloat = 0.0,
    @ViewBuilder empty: @escaping () -> Empty,
    @ViewBuilder footer: @escaping () -> Footer,
    @ViewBuilder content: @escaping (T) -> Content
  ) {
    self.init(
      pager: pager, prefix: prefix, invert: invert, spacing: spacing,
      divider: divider,
      topInset: topInset,
      bottomInset: bottomInset, header: nil, empty: empty, footer: footer, content: content)
  }
}

extension PagerList where Footer == EmptyView {
  public init(
    pager: Pager<T>,
    prefix: [T]? = nil,
    invert: Bool = false,
    spacing: CGFloat? = nil,
    divider: Bool = false,
    topInset: CGFloat = 0.0,
    bottomInset: CGFloat = 0.0,
    @ViewBuilder header: @escaping () -> Header,
    @ViewBuilder empty: @escaping () -> Empty,
    @ViewBuilder content: @escaping (T) -> Content
  ) {
    self.init(
      pager: pager, prefix: prefix, invert: invert, spacing: spacing,
      divider: divider,
      topInset: topInset,
      bottomInset: bottomInset, header: header, empty: empty, footer: nil, content: content)
  }
}

extension PagerList where Empty == EmptyView {
  public init(
    pager: Pager<T>,
    prefix: [T]? = nil,
    invert: Bool = false,
    spacing: CGFloat? = nil,
    divider: Bool = false,
    topInset: CGFloat = 0.0,
    bottomInset: CGFloat = 0.0,
    @ViewBuilder header: @escaping () -> Header,
    @ViewBuilder footer: @escaping () -> Footer,
    @ViewBuilder content: @escaping (T) -> Content
  ) {
    self.init(
      pager: pager, prefix: prefix, invert: invert, spacing: spacing,
      divider: divider,
      topInset: topInset,
      bottomInset: bottomInset, header: header, empty: nil, footer: footer, content: content)
  }
}

extension PagerList where Header == EmptyView, Footer == EmptyView {
  public init(
    pager: Pager<T>,
    prefix: [T]? = nil,
    invert: Bool = false,
    spacing: CGFloat? = nil,
    divider: Bool = false,
    topInset: CGFloat = 0.0,
    bottomInset: CGFloat = 0.0,
    @ViewBuilder empty: @escaping () -> Empty,
    @ViewBuilder content: @escaping (T) -> Content
  ) {
    self.init(
      pager: pager, prefix: prefix, invert: invert, spacing: spacing,
      divider: divider,
      topInset: topInset,
      bottomInset: bottomInset, header: nil, empty: empty, footer: nil, content: content)
  }
}

extension PagerList where Header == EmptyView, Empty == EmptyView {
  public init(
    pager: Pager<T>,
    prefix: [T]? = nil,
    invert: Bool = false,
    spacing: CGFloat? = nil,
    divider: Bool = false,
    topInset: CGFloat = 0.0,
    bottomInset: CGFloat = 0.0,
    @ViewBuilder footer: @escaping () -> Footer,
    @ViewBuilder content: @escaping (T) -> Content
  ) {
    self.init(
      pager: pager, prefix: prefix, invert: invert, spacing: spacing,
      divider: divider,
      topInset: topInset,
      bottomInset: bottomInset, header: nil, empty: nil, footer: footer, content: content)
  }
}

extension PagerList where Footer == EmptyView, Empty == EmptyView {
  public init(
    pager: Pager<T>,
    prefix: [T]? = nil,
    invert: Bool = false,
    spacing: CGFloat? = nil,
    divider: Bool = false,
    topInset: CGFloat = 0.0,
    bottomInset: CGFloat = 0.0,
    @ViewBuilder header: @escaping () -> Header,
    @ViewBuilder content: @escaping (T) -> Content
  ) {
    self.init(
      pager: pager, prefix: prefix, invert: invert, spacing: spacing,
      divider: divider,
      topInset: topInset,
      bottomInset: bottomInset, header: header, empty: nil, footer: nil, content: content)
  }
}

extension PagerList where Footer == EmptyView, Empty == EmptyView, Header == EmptyView {
  public init(
    pager: Pager<T>,
    prefix: [T]? = nil,
    invert: Bool = false,
    spacing: CGFloat? = nil,
    divider: Bool = false,
    topInset: CGFloat = 0.0,
    bottomInset: CGFloat = 0.0,
    content: @escaping (T) -> Content
  ) {
    self.init(
      pager: pager,
      prefix: prefix,
      invert: invert,
      spacing: spacing,
      divider: divider,
      topInset: topInset,
      bottomInset: bottomInset,
      header: nil,
      empty: nil, footer: nil, content: content)
  }
}

let edgeInsetsZero = EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)

extension View {

  @ViewBuilder
  func invert(_ invert: Bool = true) -> some View {
    if invert {
      rotationEffect(.radians(.pi))
        .scaleEffect(x: -1, y: 1, anchor: .center)
    } else {
      self
    }
  }
}
