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
      switch result {
      case .success(let graphQLResult):
        if let errors = graphQLResult.errors {
          for error in errors {
            Monitoring.error(error)
          }
        } else if let data = graphQLResult.data {
          resultHandler(data)
        }
      case .failure(let error):
        Monitoring.error(error)
      }
    }
  }
  
  public func fetchAsync<Query: GraphQLQuery>(query: Query,
                                              cachePolicy: CachePolicy = .fetchIgnoringCacheCompletely,
                                              contextIdentifier: UUID? = nil,
                                              queue: DispatchQueue = .main) async throws -> Query.Data {
    return try await withCheckedThrowingContinuation { (cont: CheckedContinuation<Query.Data, Error>) in
      self.fetch(query: query,
                 cachePolicy: cachePolicy,
                 contextIdentifier: contextIdentifier,
                 queue: queue, resultHandler: handler(cont))
    }
  }
  
  func handler<T>(_ cont: CheckedContinuation<T, Error>) -> GraphQLResultHandler<T> {
    return { result in
      switch (result) {
      case .success(let res):
        if let data = res.data {
          cont.resume(returning: data)
        } else if let errs = res.errors {
          for err in errs {
            Monitoring.error(err)
          }
          cont.resume(throwing: APIError(msg: "GQL Errors", critical: true))
        } else {
          cont.resume(throwing: APIError(msg: "No Data", critical: true))
        }
        break
      case .failure(let err):
        cont.resume(throwing: err)
      }
    }
  }
  
  public func performAsync<Mutation: GraphQLMutation>(mutation: Mutation,
                                                      publishResultToStore: Bool = true,
                                                      queue: DispatchQueue = .main) async throws -> Mutation.Data {
    return try await withCheckedThrowingContinuation { (cont: CheckedContinuation<Mutation.Data, Error>) in
      self.perform(
        mutation: mutation,
        publishResultToStore: publishResultToStore,
        queue: queue,
        resultHandler:handler(cont)
      )
    }
  }
}

extension GraphQLEnum {
  func value() throws -> T {
    switch (self) {
    case .case(let value):
      return value
    case .unknown:
      throw APIError(msg: "unknown enum value", critical: true)
    }
  }
}
