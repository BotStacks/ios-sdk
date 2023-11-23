extension Array where Element: Equatable {

  /// Remove first collection element that is equal to the given `object` or `element`:
  mutating func remove(element: Element) {
    if let index = firstIndex(of: element) {
      remove(at: index)
    }
  }
}

extension Array where Element == String {

  func join(_ seperator: String = "") -> String {
    var result = ""
    for (i, str) in self.enumerated() {
      result += str
      if i + 1 < self.count {
        result += seperator
      }
    }
    return result
  }
}

extension Sequence where Iterator.Element: Hashable {
  func unique() -> [Iterator.Element] {
    var seen: Set<Iterator.Element> = []
    return filter { seen.insert($0).inserted }
  }
}

extension Sequence {
  func concurrentForEach(
    _ operation: @escaping (Element) async -> Void
  ) async {
    // A task group automatically waits for all of its
    // sub-tasks to complete, while also performing those
    // tasks in parallel:
    await withTaskGroup(of: Void.self) { group in
      for element in self {
        group.addTask {
          await operation(element)
        }
      }
    }
  }
}

extension Sequence {
  func asyncMap<T>(
    _ transform: (Element) async throws -> T
  ) async rethrows -> [T] {
    var values = [T]()

    for element in self {
      try await values.append(transform(element))
    }

    return values
  }

  func concurrentMap<T>(
    _ transform: @escaping (Element) async throws -> T
  ) async throws -> [T] {
    let tasks = map { element in
      Task {
        try await transform(element)
      }
    }

    return try await tasks.asyncMap { task in
      try await task.value
    }
  }
}
