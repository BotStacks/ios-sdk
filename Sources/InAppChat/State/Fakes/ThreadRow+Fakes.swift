extension ThreadRow {
  public static var sample: ThreadRow {
    return ThreadRow(thread: Thread.gen())
  }

  public static var sampleUser: ThreadRow {
    return ThreadRow(thread: Thread.gen(user: User.sample))
  }

  public static var samplePrivateGroup: ThreadRow {
    return ThreadRow(thread: Thread.gen(group: Group.gen(_private: true)))
  }

  public static var samplePublicGroup: ThreadRow {
    return ThreadRow(thread: Thread.gen(group: Group.gen(_private: false)))
  }

  public static var sampleUnread: ThreadRow {
    return ThreadRow(thread: Thread.gen(unreadCount: 2))
  }
}
