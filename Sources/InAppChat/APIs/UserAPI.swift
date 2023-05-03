//
// UserAPI.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

open class UserAPI {

    /**
     Block a user
     
     - parameter uid: (path) the user&#39;s id 
     - returns: Void
     */
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    open class func blockUser(uid: String) async throws {
        return try await blockUserWithRequestBuilder(uid: uid).execute().body
    }

    /**
     Block a user
     - PUT /blocks/{uid}
     - Block a user
     - API Key:
       - type: apiKey X-Device-ID (HEADER)
       - name: DeviceId
     - API Key:
       - type: apiKey X-API-Key (HEADER)
       - name: ApiKeyAuth
     - BASIC:
       - type: http
       - name: BearerAuth
     - parameter uid: (path) the user&#39;s id 
     - returns: RequestBuilder<Void> 
     */
    open class func blockUserWithRequestBuilder(uid: String) -> RequestBuilder<Void> {
        var localVariablePath = "/blocks/{uid}"
        let uidPreEscape = "\(APIHelper.mapValueToPathItem(uid))"
        let uidPostEscape = uidPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        localVariablePath = localVariablePath.replacingOccurrences(of: "{uid}", with: uidPostEscape, options: .literal, range: nil)
        let localVariableURLString = InAppChatAPI.basePath + localVariablePath
        let localVariableParameters: [String: Any]? = nil

        let localVariableUrlComponents = URLComponents(string: localVariableURLString)

        let localVariableNillableHeaders: [String: Any?] = [
            :
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<Void>.Type = InAppChatAPI.requestBuilderFactory.getNonDecodableBuilder()

        return localVariableRequestBuilder.init(method: "PUT", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters, requiresAuthentication: true)
    }

    /**

     - parameter uid: (path) the user&#39;s id 
     - returns: Void
     */
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    open class func deleteUserAvatar(uid: String) async throws {
        return try await deleteUserAvatarWithRequestBuilder(uid: uid).execute().body
    }

    /**
     - DELETE /users/{uid}/avatar
     - Remove user profile pic
     - API Key:
       - type: apiKey X-Device-ID (HEADER)
       - name: DeviceId
     - API Key:
       - type: apiKey X-API-Key (HEADER)
       - name: ApiKeyAuth
     - BASIC:
       - type: http
       - name: BearerAuth
     - parameter uid: (path) the user&#39;s id 
     - returns: RequestBuilder<Void> 
     */
    open class func deleteUserAvatarWithRequestBuilder(uid: String) -> RequestBuilder<Void> {
        var localVariablePath = "/users/{uid}/avatar"
        let uidPreEscape = "\(APIHelper.mapValueToPathItem(uid))"
        let uidPostEscape = uidPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        localVariablePath = localVariablePath.replacingOccurrences(of: "{uid}", with: uidPostEscape, options: .literal, range: nil)
        let localVariableURLString = InAppChatAPI.basePath + localVariablePath
        let localVariableParameters: [String: Any]? = nil

        let localVariableUrlComponents = URLComponents(string: localVariableURLString)

        let localVariableNillableHeaders: [String: Any?] = [
            :
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<Void>.Type = InAppChatAPI.requestBuilderFactory.getNonDecodableBuilder()

        return localVariableRequestBuilder.init(method: "DELETE", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters, requiresAuthentication: true)
    }

    /**
     Get blocked users
     
     - returns: [APIUser]
     */
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    open class func getBlockedUsers() async throws -> [APIUser] {
        return try await getBlockedUsersWithRequestBuilder().execute().body
    }

    /**
     Get blocked users
     - GET /blocks
     - Get blocked users
     - API Key:
       - type: apiKey X-Device-ID (HEADER)
       - name: DeviceId
     - API Key:
       - type: apiKey X-API-Key (HEADER)
       - name: ApiKeyAuth
     - BASIC:
       - type: http
       - name: BearerAuth
     - returns: RequestBuilder<[APIUser]> 
     */
    open class func getBlockedUsersWithRequestBuilder() -> RequestBuilder<[APIUser]> {
        let localVariablePath = "/blocks"
        let localVariableURLString = InAppChatAPI.basePath + localVariablePath
        let localVariableParameters: [String: Any]? = nil

        let localVariableUrlComponents = URLComponents(string: localVariableURLString)

        let localVariableNillableHeaders: [String: Any?] = [
            :
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<[APIUser]>.Type = InAppChatAPI.requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "GET", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters, requiresAuthentication: true)
    }

    /**

     - returns: [Event]
     */
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    open class func getPendingEvents() async throws -> [Event] {
        return try await getPendingEventsWithRequestBuilder().execute().body
    }

    /**
     - GET /events
     - Get pending events for particular device
     - API Key:
       - type: apiKey X-Device-ID (HEADER)
       - name: DeviceId
     - API Key:
       - type: apiKey X-API-Key (HEADER)
       - name: ApiKeyAuth
     - BASIC:
       - type: http
       - name: BearerAuth
     - returns: RequestBuilder<[Event]> 
     */
    open class func getPendingEventsWithRequestBuilder() -> RequestBuilder<[Event]> {
        let localVariablePath = "/events"
        let localVariableURLString = InAppChatAPI.basePath + localVariablePath
        let localVariableParameters: [String: Any]? = nil

        let localVariableUrlComponents = URLComponents(string: localVariableURLString)

        let localVariableNillableHeaders: [String: Any?] = [
            :
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<[Event]>.Type = InAppChatAPI.requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "GET", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters, requiresAuthentication: true)
    }

    /**

     - parameter uid: (path) the user&#39;s id 
     - returns: APIUser
     */
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    open class func getUser(uid: String) async throws -> APIUser {
        return try await getUserWithRequestBuilder(uid: uid).execute().body
    }

    /**
     - GET /user/{uid}
     - Get a user
     - API Key:
       - type: apiKey X-Device-ID (HEADER)
       - name: DeviceId
     - API Key:
       - type: apiKey X-API-Key (HEADER)
       - name: ApiKeyAuth
     - BASIC:
       - type: http
       - name: BearerAuth
     - parameter uid: (path) the user&#39;s id 
     - returns: RequestBuilder<APIUser> 
     */
    open class func getUserWithRequestBuilder(uid: String) -> RequestBuilder<APIUser> {
        var localVariablePath = "/user/{uid}"
        let uidPreEscape = "\(APIHelper.mapValueToPathItem(uid))"
        let uidPostEscape = uidPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        localVariablePath = localVariablePath.replacingOccurrences(of: "{uid}", with: uidPostEscape, options: .literal, range: nil)
        let localVariableURLString = InAppChatAPI.basePath + localVariablePath
        let localVariableParameters: [String: Any]? = nil

        let localVariableUrlComponents = URLComponents(string: localVariableURLString)

        let localVariableNillableHeaders: [String: Any?] = [
            :
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<APIUser>.Type = InAppChatAPI.requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "GET", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters, requiresAuthentication: true)
    }

    /**

     - parameter lastId: (query) To be used for Pagination (optional)
     - parameter lastCallTime: (query) epoch time value for time based sunc. Do not pass this param itself for retrieving all data. (optional)
     - parameter updateType: (query) type of sync i.e. addUpdated/inactive/deleted. Default value is addUpdated (optional)
     - returns: [APIUser]
     */
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    open class func getUsers(lastId: String? = nil, lastCallTime: Int? = nil, updateType: String? = nil) async throws -> [APIUser] {
        return try await getUsersWithRequestBuilder(lastId: lastId, lastCallTime: lastCallTime, updateType: updateType).execute().body
    }

    /**
     - GET /users
     - List users
     - API Key:
       - type: apiKey X-Device-ID (HEADER)
       - name: DeviceId
     - API Key:
       - type: apiKey X-API-Key (HEADER)
       - name: ApiKeyAuth
     - BASIC:
       - type: http
       - name: BearerAuth
     - parameter lastId: (query) To be used for Pagination (optional)
     - parameter lastCallTime: (query) epoch time value for time based sunc. Do not pass this param itself for retrieving all data. (optional)
     - parameter updateType: (query) type of sync i.e. addUpdated/inactive/deleted. Default value is addUpdated (optional)
     - returns: RequestBuilder<[APIUser]> 
     */
    open class func getUsersWithRequestBuilder(lastId: String? = nil, lastCallTime: Int? = nil, updateType: String? = nil) -> RequestBuilder<[APIUser]> {
        let localVariablePath = "/users"
        let localVariableURLString = InAppChatAPI.basePath + localVariablePath
        let localVariableParameters: [String: Any]? = nil

        var localVariableUrlComponents = URLComponents(string: localVariableURLString)
        localVariableUrlComponents?.queryItems = APIHelper.mapValuesToQueryItems([
            "lastId": (wrappedValue: lastId?.encodeToJSON(), isExplode: true),
            "lastCallTime": (wrappedValue: lastCallTime?.encodeToJSON(), isExplode: true),
            "updateType": (wrappedValue: updateType?.encodeToJSON(), isExplode: true),
        ])

        let localVariableNillableHeaders: [String: Any?] = [
            :
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<[APIUser]>.Type = InAppChatAPI.requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "GET", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters, requiresAuthentication: true)
    }

    /**

     - returns: APIUser
     */
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    open class func me() async throws -> APIUser {
        return try await meWithRequestBuilder().execute().body
    }

    /**
     - GET /me
     - Get current user
     - API Key:
       - type: apiKey X-Device-ID (HEADER)
       - name: DeviceId
     - API Key:
       - type: apiKey X-API-Key (HEADER)
       - name: ApiKeyAuth
     - BASIC:
       - type: http
       - name: BearerAuth
     - returns: RequestBuilder<APIUser> 
     */
    open class func meWithRequestBuilder() -> RequestBuilder<APIUser> {
        let localVariablePath = "/me"
        let localVariableURLString = InAppChatAPI.basePath + localVariablePath
        let localVariableParameters: [String: Any]? = nil

        let localVariableUrlComponents = URLComponents(string: localVariableURLString)

        let localVariableNillableHeaders: [String: Any?] = [
            :
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<APIUser>.Type = InAppChatAPI.requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "GET", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters, requiresAuthentication: true)
    }

    /**
     Refresh auth token
     
     - parameter uid: (path) the user&#39;s id 
     - returns: Token
     */
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    open class func refreshAuthToken(uid: String) async throws -> Token {
        return try await refreshAuthTokenWithRequestBuilder(uid: uid).execute().body
    }

    /**
     Refresh auth token
     - GET /token/refresh
     - Refresh auth token
     - API Key:
       - type: apiKey X-Device-ID (HEADER)
       - name: DeviceId
     - API Key:
       - type: apiKey X-API-Key (HEADER)
       - name: ApiKeyAuth
     - BASIC:
       - type: http
       - name: BearerAuth
     - parameter uid: (path) the user&#39;s id 
     - returns: RequestBuilder<Token> 
     */
    open class func refreshAuthTokenWithRequestBuilder(uid: String) -> RequestBuilder<Token> {
        var localVariablePath = "/token/refresh"
        let uidPreEscape = "\(APIHelper.mapValueToPathItem(uid))"
        let uidPostEscape = uidPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        localVariablePath = localVariablePath.replacingOccurrences(of: "{uid}", with: uidPostEscape, options: .literal, range: nil)
        let localVariableURLString = InAppChatAPI.basePath + localVariablePath
        let localVariableParameters: [String: Any]? = nil

        let localVariableUrlComponents = URLComponents(string: localVariableURLString)

        let localVariableNillableHeaders: [String: Any?] = [
            :
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<Token>.Type = InAppChatAPI.requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "GET", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters, requiresAuthentication: true)
    }

    /**
     reset notification badge count
     
     - returns: Void
     */
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    open class func resetBadgeCount() async throws {
        return try await resetBadgeCountWithRequestBuilder().execute().body
    }

    /**
     reset notification badge count
     - GET /resetBadgeCount
     - reset badge count
     - API Key:
       - type: apiKey X-Device-ID (HEADER)
       - name: DeviceId
     - API Key:
       - type: apiKey X-API-Key (HEADER)
       - name: ApiKeyAuth
     - BASIC:
       - type: http
       - name: BearerAuth
     - returns: RequestBuilder<Void> 
     */
    open class func resetBadgeCountWithRequestBuilder() -> RequestBuilder<Void> {
        let localVariablePath = "/resetBadgeCount"
        let localVariableURLString = InAppChatAPI.basePath + localVariablePath
        let localVariableParameters: [String: Any]? = nil

        let localVariableUrlComponents = URLComponents(string: localVariableURLString)

        let localVariableNillableHeaders: [String: Any?] = [
            :
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<Void>.Type = InAppChatAPI.requestBuilderFactory.getNonDecodableBuilder()

        return localVariableRequestBuilder.init(method: "GET", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters, requiresAuthentication: true)
    }

    /**
     Sync Contacts
     
     - parameter syncContactsInput: (body)  (optional)
     - returns: [APIUser]
     */
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    open class func syncContacts(syncContactsInput: SyncContactsInput? = nil) async throws -> [APIUser] {
        return try await syncContactsWithRequestBuilder(syncContactsInput: syncContactsInput).execute().body
    }

    /**
     Sync Contacts
     - POST /contacts/sync
     - Sync contacts
     - API Key:
       - type: apiKey X-Device-ID (HEADER)
       - name: DeviceId
     - API Key:
       - type: apiKey X-API-Key (HEADER)
       - name: ApiKeyAuth
     - BASIC:
       - type: http
       - name: BearerAuth
     - parameter syncContactsInput: (body)  (optional)
     - returns: RequestBuilder<[APIUser]> 
     */
    open class func syncContactsWithRequestBuilder(syncContactsInput: SyncContactsInput? = nil) -> RequestBuilder<[APIUser]> {
        let localVariablePath = "/contacts/sync"
        let localVariableURLString = InAppChatAPI.basePath + localVariablePath
        let localVariableParameters = JSONEncodingHelper.encodingParameters(forEncodableObject: syncContactsInput)

        let localVariableUrlComponents = URLComponents(string: localVariableURLString)

        let localVariableNillableHeaders: [String: Any?] = [
            :
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<[APIUser]>.Type = InAppChatAPI.requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "POST", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters, requiresAuthentication: true)
    }

    /**
     Unblock a user
     
     - parameter uid: (path) the user&#39;s id 
     - returns: Void
     */
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    open class func unblockUser(uid: String) async throws {
        return try await unblockUserWithRequestBuilder(uid: uid).execute().body
    }

    /**
     Unblock a user
     - DELETE /blocks/{uid}
     - Unblock a user
     - API Key:
       - type: apiKey X-Device-ID (HEADER)
       - name: DeviceId
     - API Key:
       - type: apiKey X-API-Key (HEADER)
       - name: ApiKeyAuth
     - BASIC:
       - type: http
       - name: BearerAuth
     - parameter uid: (path) the user&#39;s id 
     - returns: RequestBuilder<Void> 
     */
    open class func unblockUserWithRequestBuilder(uid: String) -> RequestBuilder<Void> {
        var localVariablePath = "/blocks/{uid}"
        let uidPreEscape = "\(APIHelper.mapValueToPathItem(uid))"
        let uidPostEscape = uidPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        localVariablePath = localVariablePath.replacingOccurrences(of: "{uid}", with: uidPostEscape, options: .literal, range: nil)
        let localVariableURLString = InAppChatAPI.basePath + localVariablePath
        let localVariableParameters: [String: Any]? = nil

        let localVariableUrlComponents = URLComponents(string: localVariableURLString)

        let localVariableNillableHeaders: [String: Any?] = [
            :
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<Void>.Type = InAppChatAPI.requestBuilderFactory.getNonDecodableBuilder()

        return localVariableRequestBuilder.init(method: "DELETE", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters, requiresAuthentication: true)
    }

    /**

     - parameter updateUserInput: (body) User properties to update with 
     - returns: APIUser
     */
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    open class func updateMe(updateUserInput: UpdateUserInput) async throws -> APIUser {
        return try await updateMeWithRequestBuilder(updateUserInput: updateUserInput).execute().body
    }

    /**
     - POST /me
     - Update current user
     - API Key:
       - type: apiKey X-Device-ID (HEADER)
       - name: DeviceId
     - API Key:
       - type: apiKey X-API-Key (HEADER)
       - name: ApiKeyAuth
     - BASIC:
       - type: http
       - name: BearerAuth
     - parameter updateUserInput: (body) User properties to update with 
     - returns: RequestBuilder<APIUser> 
     */
    open class func updateMeWithRequestBuilder(updateUserInput: UpdateUserInput) -> RequestBuilder<APIUser> {
        let localVariablePath = "/me"
        let localVariableURLString = InAppChatAPI.basePath + localVariablePath
        let localVariableParameters = JSONEncodingHelper.encodingParameters(forEncodableObject: updateUserInput)

        let localVariableUrlComponents = URLComponents(string: localVariableURLString)

        let localVariableNillableHeaders: [String: Any?] = [
            :
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<APIUser>.Type = InAppChatAPI.requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "POST", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters, requiresAuthentication: true)
    }
}