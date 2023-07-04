//
//  Client.swift
//  InAppChat
//
//  Created by Zaid Daghestani on 6/28/23.
//

import Foundation
import Apollo

extension ApolloClient {
  public func sub<Subscription: GraphQLSubscription>(subscription: Subscription,
                                                           queue: DispatchQueue = .main,
                                                     resultHandler: @escaping (Subscription.Data) -> Void) -> Cancellable {
    return subscribe(subscription: subscription, queue: queue) { result in
      guard let self = self else {
        return
      }
      switch result {
      case .success(let graphQLResult):
        if let errors = graphQLResult.errors {
          for (let error in errors) {
            Monitoring.error(error)
          }
        } else if let data = graphQLResult.data {
          cb(data)
        }
      case .failure(let error):
        Monitoring.error(error)
      }
    }
  }
  
  public func fetchAsync<Query: GraphQLQuery>(query: Query,
                                              cachePolicy: CachePolicy = .fetchIgnoringCacheCompletely,
                                              contextIdentifier: UUID? = nil,
                                              queue: DispatchQueue = .main) async -> Query.Data {
    return withCheckedThrowingContinuation<Query.Data> { cont in
      self.networkTransport.send(operation: query,
                                 cachePolicy: cachePolicy,
                                 contextIdentifier: contextIdentifier,
                                 callbackQueue: queue) { result in
        switch (result) {
        case .success(let result):
          cont.resume(with: result.data)
          break
        case .failure(let err):
          cont.resume(with: err)
        }
      }
    }
  }
  
  public func performAsync<Mutation: GraphQLMutation>(mutation: Mutation,
                                                      publishResultToStore: Bool = true,
                                                      queue: DispatchQueue = .main) async -> Mutation.Data {
    return withCheckedThrowingContinuation<Mutation.Data> { cont in
      return self.networkTransport.send(
        operation: mutation,
        cachePolicy: publishResultToStore ? .default : .fetchIgnoringCacheCompletely,
        contextIdentifier: nil,
        callbackQueue: queue,
        completionHandler: { result in
          switch (result) {
          case .success(let result):
            cont.resume(with: result.data)
            break
          case .failure(let err):
            cont.resume(with: err)
          }
        }
      )
    }
  }
}

extension GraphQLEnum {
  func value() -> T {
    switch (self) {
    case .case(let value):
      return value
    case .unknown():
      throw APIError(msg: "unknown enum value", critical: true)
    }
  }
}
