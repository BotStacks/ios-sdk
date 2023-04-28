import SwiftUI

open class Pager<T>: ObservableObject where T: Identifiable {
  @Published var loading = false
  @Published var refreshing = false
  @Published var hasMore = true

  let pageSize: Int = 20
  @Published var items: [T] = []

  var isSinglePage: Bool {
    return false
  }

  func loadMoreIfEmpty() {
    if items.isEmpty {
      loadMore()
    }
  }

  func loadMoreIfNeeded(_ item: T) {
    if isSinglePage || !hasMore { return }
    if items.count < pageSize * 2 {
      self.loadMore()
      return
    }
    let thresholdIndex = items.index(items.endIndex, offsetBy: -pageSize)
    if items.firstIndex(where: { $0.id == item.id }) == thresholdIndex {
      self.loadMore()
    }
  }

  func skip(_ isRefresh: Bool) -> Int {
    return isRefresh ? 0 : items.count
  }

  public func refresh() async {
    if self.refreshing {
      return
    }
    publish {
      self.refreshing = true
    }
    let items = await self._load(true)
    publish {
      if items.count > 0 {
        self.items = items
      }
      self.hasMore = items.count >= self.pageSize
      self.loading = false
      self.refreshing = false
    }
  }

  public func loadMore() {
    if isSinglePage && hasMore {
      hasMore = false
    }
    guard !isSinglePage && hasMore && !refreshing && !loading else { return }
    self.loading = true
    Task.detached {
      let items = await self._load(false)
      publish {
        if items.count > 0 {
          self.items = items
        }
        self.hasMore = items.count >= self.pageSize
        self.loading = false
      }
    }
  }

  private func _load(_ isRefresh: Bool) async -> [T] {
    do {
      return try await load(skip: skip(isRefresh), limit: pageSize)
    } catch let err {
      Monitoring.error(err)
    }
    return []
  }

  open func load(skip: Int, limit: Int) async throws -> [T] {
    return []
  }
}
