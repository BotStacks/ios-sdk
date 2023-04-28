# ERTCUserAPI

All URIs are relative to *https://virtserver.swaggerhub.com/RBN/Socket-Server/1.0.0*

Method | HTTP request | Description
------------- | ------------- | -------------
[**blockUnblockUserPost**](ERTCUserAPI.md#blockunblockuserpost) | **POST** /{version}/tenants/{tenantId}/user/{eRTCUserId}/blockUnblock/{action} | Update user by eRTC userId
[**blockedUsersGet**](ERTCUserAPI.md#blockedusersget) | **GET** /{version}/tenants/{tenantId}/user/{eRTCUserId}/blockedUsers | Get blocked users
[**getChatUserDetailsPost**](ERTCUserAPI.md#getchatuserdetailspost) | **POST** /{version}/tenants/{tenantId}/user/{eRTCUserId}/chatUserDetails | Get specific details of other chatUsers
[**getOrUpdateUserByAppId**](ERTCUserAPI.md#getorupdateuserbyappid) | **POST** /{version}/tenants/{tenantId}/user/ | Get or Update user by appUserId
[**logoutOtherDevices**](ERTCUserAPI.md#logoutotherdevices) | **POST** /{version}/tenants/{tenantId}/user/{eRTCUserId}/logoutOtherDevices | Logout
[**logoutUser**](ERTCUserAPI.md#logoutuser) | **POST** /{version}/tenants/{tenantId}/user/{eRTCUserId}/logout | Logout
[**pendingEventsGet**](ERTCUserAPI.md#pendingeventsget) | **GET** /{version}/tenants/{tenantId}/user/{eRTCUserId}/pendingEvents | Get pending events for particular device
[**refreshAuthToken**](ERTCUserAPI.md#refreshauthtoken) | **GET** /{version}/tenants/{tenantId}/user/{eRTCUserId}/refreshToken | Refresh auth token
[**resetBadgeCount**](ERTCUserAPI.md#resetbadgecount) | **GET** /{version}/tenants/{tenantId}/user/{eRTCUserId}/resetBadgeCount | reset notification badge count
[**updateUserByeRTCUserId**](ERTCUserAPI.md#updateuserbyertcuserid) | **POST** /{version}/tenants/{tenantId}/user/{eRTCUserId} | Update user by eRTC userId


# **blockUnblockUserPost**
```swift
    internal class func blockUnblockUserPost(authorization: String, xRequestSignature: String, xNonce: String, version: String, tenantId: String, eRTCUserId: String, action: String, body: BlockUnblockUserRequest, completion: @escaping (_ data: BlockUnblockUserPost200Response?, _ error: Error?) -> Void)
```

Update user by eRTC userId

Get a user by eRTC userId

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let authorization = "authorization_example" // String | Authorization Token
let xRequestSignature = "xRequestSignature_example" // String | sha256 of <chatServer apiKey>~<bundleId>~<epoch timeStamp>
let xNonce = "xNonce_example" // String | epoch timestamp
let version = "version_example" // String | API version
let tenantId = "tenantId_example" // String | Tenanat Id. Example 5f61c2c3fee2af1f303a16d7
let eRTCUserId = "eRTCUserId_example" // String | eRTC user ID of caller. Example '5cbdc711c25983101b1b4198'.
let action = "action_example" // String | Action. For example block/unblock.
let body = BlockUnblockUserRequest(appUserId: "appUserId_example") // BlockUnblockUserRequest | Unique AppID of the user to get

// Update user by eRTC userId
ERTCUserAPI.blockUnblockUserPost(authorization: authorization, xRequestSignature: xRequestSignature, xNonce: xNonce, version: version, tenantId: tenantId, eRTCUserId: eRTCUserId, action: action, body: body) { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **authorization** | **String** | Authorization Token | 
 **xRequestSignature** | **String** | sha256 of &lt;chatServer apiKey&gt;~&lt;bundleId&gt;~&lt;epoch timeStamp&gt; | 
 **xNonce** | **String** | epoch timestamp | 
 **version** | **String** | API version | 
 **tenantId** | **String** | Tenanat Id. Example 5f61c2c3fee2af1f303a16d7 | 
 **eRTCUserId** | **String** | eRTC user ID of caller. Example &#39;5cbdc711c25983101b1b4198&#39;. | 
 **action** | **String** | Action. For example block/unblock. | 
 **body** | [**BlockUnblockUserRequest**](BlockUnblockUserRequest.md) | Unique AppID of the user to get | 

### Return type

[**BlockUnblockUserPost200Response**](BlockUnblockUserPost200Response.md)

### Authorization

[sdk_key](../README.md#sdk_key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **blockedUsersGet**
```swift
    internal class func blockedUsersGet(authorization: String, xRequestSignature: String, xNonce: String, deviceid: String, version: String, tenantId: String, eRTCUserId: String, completion: @escaping (_ data: BlockedUsersGet200Response?, _ error: Error?) -> Void)
```

Get blocked users

Get blocked users

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let authorization = "authorization_example" // String | Authorization Token
let xRequestSignature = "xRequestSignature_example" // String | sha256 of <chatServer apiKey>~<bundleId>~<epoch timeStamp>
let xNonce = "xNonce_example" // String | epoch timestamp
let deviceid = "deviceid_example" // String | device123
let version = "version_example" // String | API version
let tenantId = "tenantId_example" // String | Tenant Id. Example 5f61c2c3fee2af1f303a16d7
let eRTCUserId = "eRTCUserId_example" // String | eRTC user ID. Example '5cbdc711c25983101b1b4198'

// Get blocked users
ERTCUserAPI.blockedUsersGet(authorization: authorization, xRequestSignature: xRequestSignature, xNonce: xNonce, deviceid: deviceid, version: version, tenantId: tenantId, eRTCUserId: eRTCUserId) { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **authorization** | **String** | Authorization Token | 
 **xRequestSignature** | **String** | sha256 of &lt;chatServer apiKey&gt;~&lt;bundleId&gt;~&lt;epoch timeStamp&gt; | 
 **xNonce** | **String** | epoch timestamp | 
 **deviceid** | **String** | device123 | 
 **version** | **String** | API version | 
 **tenantId** | **String** | Tenant Id. Example 5f61c2c3fee2af1f303a16d7 | 
 **eRTCUserId** | **String** | eRTC user ID. Example &#39;5cbdc711c25983101b1b4198&#39; | 

### Return type

[**BlockedUsersGet200Response**](BlockedUsersGet200Response.md)

### Authorization

[sdk_key](../README.md#sdk_key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getChatUserDetailsPost**
```swift
    internal class func getChatUserDetailsPost(authorization: String, xRequestSignature: String, xNonce: String, version: String, tenantId: String, eRTCUserId: String, body: ChatUserDetailsRequest, completion: @escaping (_ data: GetChatUserDetailsPost200Response?, _ error: Error?) -> Void)
```

Get specific details of other chatUsers

Get specific details of other chatUsers

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let authorization = "authorization_example" // String | Authorization Token
let xRequestSignature = "xRequestSignature_example" // String | sha256 of <chatServer apiKey>~<bundleId>~<epoch timeStamp>
let xNonce = "xNonce_example" // String | epoch timestamp
let version = "version_example" // String | API version
let tenantId = "tenantId_example" // String | Tenant Id. Example 5f61c2c3fee2af1f303a16d7
let eRTCUserId = "eRTCUserId_example" // String | eRTC user ID. Example '5cbdc711c25983101b1b4198'
let body = chatUserDetailsRequest(statusKeys: ["statusKeys_example"], appUserIds: ["appUserIds_example"]) // ChatUserDetailsRequest | list of appUserIds of chatUsers

// Get specific details of other chatUsers
ERTCUserAPI.getChatUserDetailsPost(authorization: authorization, xRequestSignature: xRequestSignature, xNonce: xNonce, version: version, tenantId: tenantId, eRTCUserId: eRTCUserId, body: body) { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **authorization** | **String** | Authorization Token | 
 **xRequestSignature** | **String** | sha256 of &lt;chatServer apiKey&gt;~&lt;bundleId&gt;~&lt;epoch timeStamp&gt; | 
 **xNonce** | **String** | epoch timestamp | 
 **version** | **String** | API version | 
 **tenantId** | **String** | Tenant Id. Example 5f61c2c3fee2af1f303a16d7 | 
 **eRTCUserId** | **String** | eRTC user ID. Example &#39;5cbdc711c25983101b1b4198&#39; | 
 **body** | [**ChatUserDetailsRequest**](ChatUserDetailsRequest.md) | list of appUserIds of chatUsers | 

### Return type

[**GetChatUserDetailsPost200Response**](GetChatUserDetailsPost200Response.md)

### Authorization

[sdk_key](../README.md#sdk_key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getOrUpdateUserByAppId**
```swift
    internal class func getOrUpdateUserByAppId(version: String, tenantId: String, xRequestSignature: String, xNonce: String, body: GetOrUpdateUserRequest, completion: @escaping (_ data: GetOrUpdateUserByAppId200Response?, _ error: Error?) -> Void)
```

Get or Update user by appUserId

Get a user by APP Unique ID

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let version = "version_example" // String | API version
let tenantId = "tenantId_example" // String | Tenant ID
let xRequestSignature = "xRequestSignature_example" // String | sha256 of <chatServer apiKey>~<bundleId>~<epoch timeStamp>
let xNonce = "xNonce_example" // String | epoch timestamp
let body = GetOrUpdateUserRequest(appUserId: "appUserId_example", deviceId: "deviceId_example", deviceType: "deviceType_example", fcmToken: "fcmToken_example", fcmVersion: "fcmVersion_example", publicKey: "publicKey_example", muteSetting: "muteSetting_example", authPayload: userAuthPayload(data: User_Auth_payload_data__Version_2_N(params: "TODO", header: "TODO", body: "TODO", query: "TODO"))) // GetOrUpdateUserRequest | Unique AppID of the user to get

// Get or Update user by appUserId
ERTCUserAPI.getOrUpdateUserByAppId(version: version, tenantId: tenantId, xRequestSignature: xRequestSignature, xNonce: xNonce, body: body) { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **version** | **String** | API version | 
 **tenantId** | **String** | Tenant ID | 
 **xRequestSignature** | **String** | sha256 of &lt;chatServer apiKey&gt;~&lt;bundleId&gt;~&lt;epoch timeStamp&gt; | 
 **xNonce** | **String** | epoch timestamp | 
 **body** | [**GetOrUpdateUserRequest**](GetOrUpdateUserRequest.md) | Unique AppID of the user to get | 

### Return type

[**GetOrUpdateUserByAppId200Response**](GetOrUpdateUserByAppId200Response.md)

### Authorization

[sdk_key](../README.md#sdk_key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **logoutOtherDevices**
```swift
    internal class func logoutOtherDevices(authorization: String, xRequestSignature: String, xNonce: String, version: String, tenantId: String, eRTCUserId: String, body: LogoutUserRequest, completion: @escaping (_ data: LogoutOtherDevices200Response?, _ error: Error?) -> Void)
```

Logout

logoutOtherDevices

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let authorization = "authorization_example" // String | Authorization Token
let xRequestSignature = "xRequestSignature_example" // String | sha256 of <chatServer apiKey>~<bundleId>~<epoch timeStamp>
let xNonce = "xNonce_example" // String | epoch timestamp
let version = "version_example" // String | API version
let tenantId = "tenantId_example" // String | Tenant Id. Example 5f61c2c3fee2af1f303a16d7
let eRTCUserId = "eRTCUserId_example" // String | eRTC user ID. Example '5cbdc711c25983101b1b4198'
let body = LogoutUserRequest(appUserId: "appUserId_example", deviceId: "deviceId_example") // LogoutUserRequest | Unique AppID of the user to get

// Logout
ERTCUserAPI.logoutOtherDevices(authorization: authorization, xRequestSignature: xRequestSignature, xNonce: xNonce, version: version, tenantId: tenantId, eRTCUserId: eRTCUserId, body: body) { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **authorization** | **String** | Authorization Token | 
 **xRequestSignature** | **String** | sha256 of &lt;chatServer apiKey&gt;~&lt;bundleId&gt;~&lt;epoch timeStamp&gt; | 
 **xNonce** | **String** | epoch timestamp | 
 **version** | **String** | API version | 
 **tenantId** | **String** | Tenant Id. Example 5f61c2c3fee2af1f303a16d7 | 
 **eRTCUserId** | **String** | eRTC user ID. Example &#39;5cbdc711c25983101b1b4198&#39; | 
 **body** | [**LogoutUserRequest**](LogoutUserRequest.md) | Unique AppID of the user to get | 

### Return type

[**LogoutOtherDevices200Response**](LogoutOtherDevices200Response.md)

### Authorization

[sdk_key](../README.md#sdk_key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **logoutUser**
```swift
    internal class func logoutUser(authorization: String, xRequestSignature: String, xNonce: String, version: String, tenantId: String, eRTCUserId: String, body: LogoutUserRequest, completion: @escaping (_ data: LogoutUser200Response?, _ error: Error?) -> Void)
```

Logout

LogoutUser

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let authorization = "authorization_example" // String | Authorization Token
let xRequestSignature = "xRequestSignature_example" // String | sha256 of <chatServer apiKey>~<bundleId>~<epoch timeStamp>
let xNonce = "xNonce_example" // String | epoch timestamp
let version = "version_example" // String | API version
let tenantId = "tenantId_example" // String | Tenant Id. Example 5f61c2c3fee2af1f303a16d7
let eRTCUserId = "eRTCUserId_example" // String | eRTC user ID. Example '5cbdc711c25983101b1b4198'
let body = LogoutUserRequest(appUserId: "appUserId_example", deviceId: "deviceId_example") // LogoutUserRequest | Unique AppID of the user to get

// Logout
ERTCUserAPI.logoutUser(authorization: authorization, xRequestSignature: xRequestSignature, xNonce: xNonce, version: version, tenantId: tenantId, eRTCUserId: eRTCUserId, body: body) { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **authorization** | **String** | Authorization Token | 
 **xRequestSignature** | **String** | sha256 of &lt;chatServer apiKey&gt;~&lt;bundleId&gt;~&lt;epoch timeStamp&gt; | 
 **xNonce** | **String** | epoch timestamp | 
 **version** | **String** | API version | 
 **tenantId** | **String** | Tenant Id. Example 5f61c2c3fee2af1f303a16d7 | 
 **eRTCUserId** | **String** | eRTC user ID. Example &#39;5cbdc711c25983101b1b4198&#39; | 
 **body** | [**LogoutUserRequest**](LogoutUserRequest.md) | Unique AppID of the user to get | 

### Return type

[**LogoutUser200Response**](LogoutUser200Response.md)

### Authorization

[sdk_key](../README.md#sdk_key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **pendingEventsGet**
```swift
    internal class func pendingEventsGet(authorization: String, xRequestSignature: String, xNonce: String, version: String, tenantId: String, eRTCUserId: String, deviceId: String? = nil, completion: @escaping (_ data: PendingEventsGet200Response?, _ error: Error?) -> Void)
```

Get pending events for particular device

Get blocked users

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let authorization = "authorization_example" // String | Authorization Token
let xRequestSignature = "xRequestSignature_example" // String | sha256 of <chatServer apiKey>~<bundleId>~<epoch timeStamp>
let xNonce = "xNonce_example" // String | epoch timestamp
let version = "version_example" // String | API version
let tenantId = "tenantId_example" // String | Tenant Id. Example 5f61c2c3fee2af1f303a16d7
let eRTCUserId = "eRTCUserId_example" // String | eRTC user ID. Example '5cbdc711c25983101b1b4198'
let deviceId = "deviceId_example" // String | source device Id (optional)

// Get pending events for particular device
ERTCUserAPI.pendingEventsGet(authorization: authorization, xRequestSignature: xRequestSignature, xNonce: xNonce, version: version, tenantId: tenantId, eRTCUserId: eRTCUserId, deviceId: deviceId) { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **authorization** | **String** | Authorization Token | 
 **xRequestSignature** | **String** | sha256 of &lt;chatServer apiKey&gt;~&lt;bundleId&gt;~&lt;epoch timeStamp&gt; | 
 **xNonce** | **String** | epoch timestamp | 
 **version** | **String** | API version | 
 **tenantId** | **String** | Tenant Id. Example 5f61c2c3fee2af1f303a16d7 | 
 **eRTCUserId** | **String** | eRTC user ID. Example &#39;5cbdc711c25983101b1b4198&#39; | 
 **deviceId** | **String** | source device Id | [optional] 

### Return type

[**PendingEventsGet200Response**](PendingEventsGet200Response.md)

### Authorization

[sdk_key](../README.md#sdk_key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **refreshAuthToken**
```swift
    internal class func refreshAuthToken(authorization: String, xRequestSignature: String, xNonce: String, version: String, tenantId: String, eRTCUserId: String, completion: @escaping (_ data: RefreshAuthToken200Response?, _ error: Error?) -> Void)
```

Refresh auth token

Refresh auth token

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let authorization = "authorization_example" // String | Authorization Token
let xRequestSignature = "xRequestSignature_example" // String | sha256 of <chatServer apiKey>~<bundleId>~<epoch timeStamp>
let xNonce = "xNonce_example" // String | epoch timestamp
let version = "version_example" // String | API version
let tenantId = "tenantId_example" // String | Tenant Id. Example 5f61c2c3fee2af1f303a16d7
let eRTCUserId = "eRTCUserId_example" // String | eRTC user ID. Example '5cbdc711c25983101b1b4198'

// Refresh auth token
ERTCUserAPI.refreshAuthToken(authorization: authorization, xRequestSignature: xRequestSignature, xNonce: xNonce, version: version, tenantId: tenantId, eRTCUserId: eRTCUserId) { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **authorization** | **String** | Authorization Token | 
 **xRequestSignature** | **String** | sha256 of &lt;chatServer apiKey&gt;~&lt;bundleId&gt;~&lt;epoch timeStamp&gt; | 
 **xNonce** | **String** | epoch timestamp | 
 **version** | **String** | API version | 
 **tenantId** | **String** | Tenant Id. Example 5f61c2c3fee2af1f303a16d7 | 
 **eRTCUserId** | **String** | eRTC user ID. Example &#39;5cbdc711c25983101b1b4198&#39; | 

### Return type

[**RefreshAuthToken200Response**](RefreshAuthToken200Response.md)

### Authorization

[sdk_key](../README.md#sdk_key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **resetBadgeCount**
```swift
    internal class func resetBadgeCount(authorization: String, xRequestSignature: String, xNonce: String, version: String, tenantId: String, eRTCUserId: String, completion: @escaping (_ data: ResetBadgeCount200Response?, _ error: Error?) -> Void)
```

reset notification badge count

reset Bagde count

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let authorization = "authorization_example" // String | Authorization Token
let xRequestSignature = "xRequestSignature_example" // String | sha256 of <chatServer apiKey>~<bundleId>~<epoch timeStamp>
let xNonce = "xNonce_example" // String | epoch timestamp
let version = "version_example" // String | API version
let tenantId = "tenantId_example" // String | Tenant Id. Example 5f61c2c3fee2af1f303a16d7
let eRTCUserId = "eRTCUserId_example" // String | eRTC user ID. Example '5cbdc711c25983101b1b4198'

// reset notification badge count
ERTCUserAPI.resetBadgeCount(authorization: authorization, xRequestSignature: xRequestSignature, xNonce: xNonce, version: version, tenantId: tenantId, eRTCUserId: eRTCUserId) { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **authorization** | **String** | Authorization Token | 
 **xRequestSignature** | **String** | sha256 of &lt;chatServer apiKey&gt;~&lt;bundleId&gt;~&lt;epoch timeStamp&gt; | 
 **xNonce** | **String** | epoch timestamp | 
 **version** | **String** | API version | 
 **tenantId** | **String** | Tenant Id. Example 5f61c2c3fee2af1f303a16d7 | 
 **eRTCUserId** | **String** | eRTC user ID. Example &#39;5cbdc711c25983101b1b4198&#39; | 

### Return type

[**ResetBadgeCount200Response**](ResetBadgeCount200Response.md)

### Authorization

[sdk_key](../README.md#sdk_key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateUserByeRTCUserId**
```swift
    internal class func updateUserByeRTCUserId(authorization: String, xRequestSignature: String, xNonce: String, version: String, tenantId: String, eRTCUserId: String, body: UpdateUserRequest, completion: @escaping (_ data: GetOrUpdateUserByAppId200Response?, _ error: Error?) -> Void)
```

Update user by eRTC userId

Get a user by eRTC userId

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let authorization = "authorization_example" // String | Authorization Token
let xRequestSignature = "xRequestSignature_example" // String | sha256 of <chatServer apiKey>~<bundleId>~<epoch timeStamp>
let xNonce = "xNonce_example" // String | epoch timestamp
let version = "version_example" // String | API version
let tenantId = "tenantId_example" // String | Tenant Id. Example 5f61c2c3fee2af1f303a16d7
let eRTCUserId = "eRTCUserId_example" // String | eRTC user ID. Example '5cbdc711c25983101b1b4198'
let body = UpdateUserRequest(deviceId: "deviceId_example", deviceType: "deviceType_example", fcmToken: "fcmToken_example", fcmVersion: "fcmVersion_example", availabilityStatus: "availabilityStatus_example", notificationSettings: notificationSettings(allowFrom: "allowFrom_example", validTill: "validTill_example", validTillDisplayValue: "validTillDisplayValue_example")) // UpdateUserRequest | Unique AppID of the user to get

// Update user by eRTC userId
ERTCUserAPI.updateUserByeRTCUserId(authorization: authorization, xRequestSignature: xRequestSignature, xNonce: xNonce, version: version, tenantId: tenantId, eRTCUserId: eRTCUserId, body: body) { (response, error) in
    guard error == nil else {
        print(error)
        return
    }

    if (response) {
        dump(response)
    }
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **authorization** | **String** | Authorization Token | 
 **xRequestSignature** | **String** | sha256 of &lt;chatServer apiKey&gt;~&lt;bundleId&gt;~&lt;epoch timeStamp&gt; | 
 **xNonce** | **String** | epoch timestamp | 
 **version** | **String** | API version | 
 **tenantId** | **String** | Tenant Id. Example 5f61c2c3fee2af1f303a16d7 | 
 **eRTCUserId** | **String** | eRTC user ID. Example &#39;5cbdc711c25983101b1b4198&#39; | 
 **body** | [**UpdateUserRequest**](UpdateUserRequest.md) | Unique AppID of the user to get | 

### Return type

[**GetOrUpdateUserByAppId200Response**](GetOrUpdateUserByAppId200Response.md)

### Authorization

[sdk_key](../README.md#sdk_key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

