//
// SearchAPI.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

open class SearchAPI {

    /**
     Unified search API
     
     - parameter searchInput: (body) Chat multiple request 
     - parameter skip: (query) skip value for pagination. i.e. index. default 0 (optional, default to 0)
     - parameter limit: (query) limit value for pagination. i.e. page-size. default 10 (optional, default to 20)
     - returns: SearchResults
     */
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    open class func search(searchInput: SearchInput, skip: Int? = nil, limit: Int? = nil) async throws -> SearchResults {
        return try await searchWithRequestBuilder(searchInput: searchInput, skip: skip, limit: limit).execute().body
    }

    /**
     Unified search API
     - POST /search
     - One stop for all search APIs, can be used to search files, messages or groups.
     - API Key:
       - type: apiKey X-Device-ID (HEADER)
       - name: DeviceId
     - API Key:
       - type: apiKey X-API-Key (HEADER)
       - name: ApiKeyAuth
     - BASIC:
       - type: http
       - name: BearerAuth
     - parameter searchInput: (body) Chat multiple request 
     - parameter skip: (query) skip value for pagination. i.e. index. default 0 (optional, default to 0)
     - parameter limit: (query) limit value for pagination. i.e. page-size. default 10 (optional, default to 20)
     - returns: RequestBuilder<SearchResults> 
     */
    open class func searchWithRequestBuilder(searchInput: SearchInput, skip: Int? = nil, limit: Int? = nil) -> RequestBuilder<SearchResults> {
        let localVariablePath = "/search"
        let localVariableURLString = InAppChatAPI.basePath + localVariablePath
        let localVariableParameters = JSONEncodingHelper.encodingParameters(forEncodableObject: searchInput)

        var localVariableUrlComponents = URLComponents(string: localVariableURLString)
        localVariableUrlComponents?.queryItems = APIHelper.mapValuesToQueryItems([
            "skip": (wrappedValue: skip?.encodeToJSON(), isExplode: true),
            "limit": (wrappedValue: limit?.encodeToJSON(), isExplode: true),
        ])

        let localVariableNillableHeaders: [String: Any?] = [
            :
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<SearchResults>.Type = InAppChatAPI.requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "POST", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters, requiresAuthentication: true)
    }
}