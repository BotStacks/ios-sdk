//
//  SwiftUI Router
//  Created by Freek (github.com/frzi) 2021
//

import Combine
import SwiftUI

/// Entry for a routing environment.
///
/// The Router holds the state of the current path (i.e. the URI).
/// Wrap your entire app (or the view that initiates a routing environment) using this view.
///
/// ```swift
/// Router {
/// 	HomeView()
///
/// 	Route("/news") {
/// 		NewsHeaderView()
/// 	}
/// }
/// ```
///
/// # Routers in Routers
/// It's possible to have a Router somewhere in the child hierarchy of another Router. *However*, these will
/// work completely independent of each other. It is not possible to navigate from one Router to another; whether
/// via `NavLink` or programmatically.
///
/// - Note: A Router's base path (root) is always `/`.
public struct Router<Content: View>: View {
  @StateObject private var navigator: Navigator
  private let content: Content

  /// Initialize a Router environment.
  /// - Parameter initialPath: The initial path the `Router` should start at once initialized.
  /// - Parameter content: Content views to render inside the Router environment.
  public init(initialPath: String = "/", @ViewBuilder content: () -> Content) {
    _navigator = StateObject(wrappedValue: Navigator(initialPath: initialPath))
    self.content = content()
  }

  /// Initialize a Router environment.
  ///
  /// Provide an already initialized instance of `Navigator` to use inside a Router environment.
  ///
  /// - Important: This is considered an advanced usecase for *SwiftUI Router* used only for specific design patterns.
  /// It is stronlgy adviced to use the `init(initialPath:content:)` initializer instead.
  ///
  /// - Parameter navigator: A pre-initialized instance of `Navigator`.
  /// - Parameter content: Content views to render inside the Router environment.
  public init(navigator: Navigator, @ViewBuilder content: () -> Content) {
    _navigator = StateObject(wrappedValue: navigator)
    self.content = content()
  }
  
  public var logStack: some View {
    print("Stacks", navigator.historyStack, navigator.forwardStack)
    return EmptyView()
  }

  public var body: some View {
    logStack
    ZStack {
      if let route = navigator.historyStack.last {
        content
          .environmentObject(navigator)
          .environmentObject(SwitchRoutesEnvironment())
          .environment(\.relativePath, "/")
          .environment(\.path, route)
      }
    }.edgesIgnoringSafeArea(.all)
      .grow()
  }
}

// MARK: - Relative path environment key
public struct RelativeRouteEnvironment: EnvironmentKey {
  public static var defaultValue = "/"
}

public struct PathEnvironment: EnvironmentKey {
  public static var defaultValue = "/"
}

public extension EnvironmentValues {
  /// The current relative path of the closest `Route`.
  var relativePath: String {
    get { self[RelativeRouteEnvironment.self] }
    set { self[RelativeRouteEnvironment.self] = newValue }
  }
  var path: String {
    get { self[PathEnvironment.self] }
    set { self[PathEnvironment.self] = newValue }
  }
}
