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
          DispatchQueue.main.async {
            resultHandler(data)
          }
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
    try await withCheckedThrowingContinuation { (cont: CheckedContinuation<Query.Data, Error>) in
      self.fetch(query: query,
                 cachePolicy: cachePolicy,
                 contextIdentifier: contextIdentifier,
                 queue: queue, resultHandler: handler(cont))
    }
  }
  
  func handler<T>(_ cont: CheckedContinuation<T, Error>) -> GraphQLResultHandler<T> {
    return { result in
      print("GQL Result \(result)")
      switch (result) {
      case .success(let res):
        if let data = res.data {
          DispatchQueue.main.async {
            cont.resume(returning: data)
          }
        } else if let errs = res.errors {
          for err in errs {
            Monitoring.error(err)
            if err.message == "login required" {
              api.loggedOut()
            }
            print("Error \(err)")
          }
          cont.resume(throwing: APIError(msg: "GQL Errors", critical: true))
        } else {
          cont.resume(throwing: APIError(msg: "No Data", critical: true))
        }
        break
      case .failure(let err):
        cont.resume(throwing: err)
        break
      }
    }
  }
  
  public func performAsync<Mutation: GraphQLMutation>(mutation: Mutation,
                                                      publishResultToStore: Bool = false,
                                                      queue: DispatchQueue = .main) async throws -> Mutation.Data {
    try await withCheckedThrowingContinuation { (cont: CheckedContinuation<Mutation.Data, Error>) in
      self.perform(
        mutation: mutation,
        publishResultToStore: publishResultToStore,
        queue: queue,
        resultHandler:handler(cont)
      )
    }
  }
}

class RequestLoggingInterceptor: ApolloInterceptor {
  var id: String = UUID().uuidString
  
  func interceptAsync<Operation: GraphQLOperation>(
    chain: RequestChain,
    request: HTTPRequest<Operation>,
    response: HTTPResponse<Operation>?,
    completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void
  ) {
    print( "Outgoing request: \(try! request.toURLRequest().cURL(pretty: true))")
    chain.proceedAsync(
      request: request,
      response: response,
      interceptor: self,
      completion: completion
    )
  }
}


extension URLRequest {
  public func cURL(pretty: Bool = false) -> String {
    let newLine = pretty ? "\\\n" : ""
    let method = (pretty ? "--request " : "-X ") + "\(self.httpMethod ?? "GET") \(newLine)"
    let url: String = (pretty ? "--url " : "") + "\'\(self.url?.absoluteString ?? "")\' \(newLine)"
    
    var cURL = "curl "
    var header = ""
    var data: String = ""
    
    if let httpHeaders = self.allHTTPHeaderFields, httpHeaders.keys.count > 0 {
      for (key,value) in httpHeaders {
        header += (pretty ? "--header " : "-H ") + "\'\(key): \(value)\' \(newLine)"
      }
    }
    
    if let bodyData = self.httpBody, let bodyString = String(data: bodyData, encoding: .utf8),  !bodyString.isEmpty {
      data = "--data '\(bodyString)'"
    }
    
    cURL += method + url + header + data
    
    return cURL
  }
}

