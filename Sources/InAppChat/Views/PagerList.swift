//
//  PagerList.swift
//  InAppChat
//
//  Created by Zaid Daghestani on 1/27/23.
//

import Foundation
import SwiftUI

let defaultSpacing: CGFloat = 8.0

public struct IACList<T, Header, Content, Footer, Empty>: View
where T: Identifiable, Header: View, Content: View, Footer: View, Empty: View
{
  let items: [T]
  let invert: Bool
  let spacing: CGFloat
  let header: (() -> Header)?
  let content: (T) -> Content
  let footer: (() -> Footer)?
  let empty: (() -> Empty)?
  let divider: Bool
  let topInset: CGFloat
  let bottomInset: CGFloat
  let hasMore: Bool
  let loadMore: ((T?) async -> Void)?
  let pullToRefresh: (() async -> Void)?
  
  
  @Environment(\.iacTheme) var theme
  @Environment(\.geometry) var geometry
  
  public init(
    items: [T],
    invert: Bool = false,
    spacing: CGFloat? = 8.0,
    divider: Bool = false,
    topInset: CGFloat = 0.0,
    bottomInset: CGFloat = 0.0,
    header: (() -> Header)?,
    empty: (() -> Empty)?,
    footer: (() -> Footer)?,
    hasMore: Bool = false,
    loadMore: ((T?) async -> Void)? = nil,
    pullToRefresh: (() async -> Void)? = nil,
    content: @escaping (T) -> Content
  ) {
    self.items = items
    self.invert = invert
    self.spacing = spacing ?? 8.0
    self.content = content
    self.topInset = topInset
    self.bottomInset = bottomInset
    self.divider = divider
    self.header = header
    self.empty = empty
    self.footer = footer
    self.hasMore = hasMore
    self.loadMore = loadMore
    self.pullToRefresh = pullToRefresh
  }
  
  @ViewBuilder
  public var stack: some View {
    let stack = VStack {
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
    }
    if let ptr = pullToRefresh {
      stack.refreshable {
        await ptr()
      }
    } else {
      stack
    }
  }
  
  @ViewBuilder
  func renderItem(_ item: T) -> some View {
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
      if hasMore && items.isEmpty, let loadMore = loadMore {
        Task.detached {
          await loadMore(item)
        }
      }
    }.id(item.id)
  }
  
  public var body: some View {
    if items.isEmpty && !hasMore {
        stack
    } else {
      let list = ScrollView {
        LazyVStack {
          ForEach(items, id: \.id) { item in
            renderItem(item)
          }
        }
      }.invert(invert)
        .onAppear {
          if items.isEmpty, let loadMore = loadMore {
            Task.detached {
              await loadMore(nil)
            }
          }
        }
      if let ptr = pullToRefresh {
        list.refreshable {
          await ptr()
        }
      } else {
        list
      }
    }
  }
}

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
    IACList(
      items: items,
      invert: invert,
      spacing: spacing,
      divider: divider,
      topInset: topInset,
      bottomInset: bottomInset,
      header: header,
      empty: empty,
      footer: footer,
      hasMore: pager.hasMore,
      loadMore: {
        if let item = $0 {
          pager.loadMoreIfNeeded(item)
        } else {
          await pager.loadMoreAsync()
        }
      }, pullToRefresh: {
        await pager.refresh()
      }, content: content
    )
  }
}

extension IACList where Header == EmptyView {
  public init(
    items: [T],
    invert: Bool = false,
    spacing: CGFloat? = nil,
    divider: Bool = false,
    topInset: CGFloat = 0.0,
    bottomInset: CGFloat = 0.0,
    @ViewBuilder empty: @escaping () -> Empty,
    @ViewBuilder footer: @escaping () -> Footer,
    hasMore: Bool = false,
    loadMore: ((T?) async -> Void)? = nil,
    pullToRefresh: (() async -> Void)? = nil,
    @ViewBuilder content: @escaping (T) -> Content
  ) {
    self.init(
      items: items, invert: invert, spacing: spacing,
      divider: divider,
      topInset: topInset,
      bottomInset: bottomInset, header: nil, empty: empty, footer: footer,
      hasMore: hasMore,
      loadMore: loadMore,
      pullToRefresh: pullToRefresh,
      content: content)
  }
}

extension IACList where Footer == EmptyView {
  public init(
    items: [T],
    invert: Bool = false,
    spacing: CGFloat? = nil,
    divider: Bool = false,
    topInset: CGFloat = 0.0,
    bottomInset: CGFloat = 0.0,
    @ViewBuilder header: @escaping () -> Header,
    @ViewBuilder empty: @escaping () -> Empty,
    hasMore: Bool = false,
    loadMore: ((T?) async -> Void)? = nil,
    pullToRefresh: (() async -> Void)? = nil,
    @ViewBuilder content: @escaping (T) -> Content
  ) {
    self.init(
      items: items, invert: invert, spacing: spacing,
      divider: divider,
      topInset: topInset,
      bottomInset: bottomInset, header: header, empty: empty, footer: nil,
      hasMore: hasMore,
      loadMore: loadMore,
      pullToRefresh: pullToRefresh,
      content: content)
  }
}

extension IACList where Empty == EmptyView {
  public init(
    items: [T],
    invert: Bool = false,
    spacing: CGFloat? = nil,
    divider: Bool = false,
    topInset: CGFloat = 0.0,
    bottomInset: CGFloat = 0.0,
    @ViewBuilder header: @escaping () -> Header,
    @ViewBuilder footer: @escaping () -> Footer,
    hasMore: Bool = false,
    loadMore: ((T?) async -> Void)? = nil,
    pullToRefresh: (() async -> Void)? = nil,
    @ViewBuilder content: @escaping (T) -> Content
  ) {
    self.init(
      items: items, invert: invert, spacing: spacing,
      divider: divider,
      topInset: topInset,
      bottomInset: bottomInset, header: header, empty: nil, footer: footer,
      hasMore: hasMore,
      loadMore: loadMore,
      pullToRefresh: pullToRefresh, content: content)
  }
}

extension IACList where Header == EmptyView, Footer == EmptyView {
  public init(
    items: [T],
    invert: Bool = false,
    spacing: CGFloat? = nil,
    divider: Bool = false,
    topInset: CGFloat = 0.0,
    bottomInset: CGFloat = 0.0,
    @ViewBuilder empty: @escaping () -> Empty,
    hasMore: Bool = false,
    loadMore: ((T?) async -> Void)? = nil,
    pullToRefresh: (() async -> Void)? = nil,
    @ViewBuilder content: @escaping (T) -> Content
  ) {
    self.init(
      items: items, invert: invert, spacing: spacing,
      divider: divider,
      topInset: topInset,
      bottomInset: bottomInset, header: nil, empty: empty, footer: nil,
      hasMore: hasMore,
      loadMore: loadMore,
      pullToRefresh: pullToRefresh,
      content: content)
  }
}

extension IACList where Header == EmptyView, Empty == EmptyView {
  public init(
    items: [T],
    invert: Bool = false,
    spacing: CGFloat? = nil,
    divider: Bool = false,
    topInset: CGFloat = 0.0,
    bottomInset: CGFloat = 0.0,
    @ViewBuilder footer: @escaping () -> Footer,
    hasMore: Bool = false,
    loadMore: ((T?) async -> Void)? = nil,
    pullToRefresh: (() async -> Void)? = nil,
    @ViewBuilder content: @escaping (T) -> Content
  ) {
    self.init(
      items: items,
      invert: invert, spacing: spacing,
      divider: divider,
      topInset: topInset,
      bottomInset: bottomInset, header: nil, empty: nil, footer: footer,
      hasMore: hasMore,
      loadMore: loadMore,
      pullToRefresh: pullToRefresh,
      content: content)
  }
}

extension IACList where Footer == EmptyView, Empty == EmptyView {
  public init(
    items: [T],
    invert: Bool = false,
    spacing: CGFloat? = nil,
    divider: Bool = false,
    topInset: CGFloat = 0.0,
    bottomInset: CGFloat = 0.0,
    @ViewBuilder header: @escaping () -> Header,
    hasMore: Bool = false,
    loadMore: ((T?) async -> Void)? = nil,
    pullToRefresh: (() async -> Void)? = nil,
    @ViewBuilder content: @escaping (T) -> Content
  ) {
    self.init(
      items: items,
      invert: invert,
      spacing: spacing,
      divider: divider,
      topInset: topInset,
      bottomInset: bottomInset,
      header: header,
      empty: nil,
      footer: nil,
      hasMore: hasMore,
      loadMore: loadMore,
      pullToRefresh: pullToRefresh,
      content: content)
  }
}

extension IACList where Footer == EmptyView, Empty == EmptyView, Header == EmptyView {
  public init(
    items: [T],
    invert: Bool = false,
    spacing: CGFloat? = nil,
    divider: Bool = false,
    topInset: CGFloat = 0.0,
    bottomInset: CGFloat = 0.0,
    hasMore: Bool = false,
    loadMore: ((T?) async -> Void)? = nil,
    pullToRefresh: (() async -> Void)? = nil,
    content: @escaping (T) -> Content
  ) {
    self.init(
      items: items,
      invert: invert,
      spacing: spacing,
      divider: divider,
      topInset: topInset,
      bottomInset: bottomInset,
      header: nil,
      empty: nil, footer: nil,
      hasMore: hasMore,
      loadMore: loadMore,
      pullToRefresh: pullToRefresh,
      content: content)
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
