import Foundation

public class UserThreads: Pager<Thread> {

  override public func load(skip: Int, limit: Int) async throws -> [Thread] {
    return try await api.getJoinedUserThreads(skip: skip, limit: limit)
  }

}
