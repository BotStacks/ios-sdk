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
}
