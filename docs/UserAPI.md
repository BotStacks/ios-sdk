# UserAPI

All URIs are relative to *https://chat.inappchat.io/v3*

Method | HTTP request | Description
------------- | ------------- | -------------
[**blockUser**](UserAPI.md#blockuser) | **PUT** /blocks/{uid} | Block a user
[**deleteUserAvatar**](UserAPI.md#deleteuseravatar) | **DELETE** /users/{uid}/avatar | 
[**getBlockedUsers**](UserAPI.md#getblockedusers) | **GET** /blocks | Get blocked users
[**getPendingEvents**](UserAPI.md#getpendingevents) | **GET** /events | 
[**getUser**](UserAPI.md#getuser) | **GET** /user/{uid} | 
[**getUsers**](UserAPI.md#getusers) | **GET** /users | 
[**me**](UserAPI.md#me) | **GET** /me | 
[**refreshAuthToken**](UserAPI.md#refreshauthtoken) | **GET** /token/refresh | Refresh auth token
[**resetBadgeCount**](UserAPI.md#resetbadgecount) | **GET** /resetBadgeCount | reset notification badge count
[**syncContacts**](UserAPI.md#synccontacts) | **POST** /contacts/sync | Sync Contacts
[**unblockUser**](UserAPI.md#unblockuser) | **DELETE** /blocks/{uid} | Unblock a user
[**updateMe**](UserAPI.md#updateme) | **POST** /me | 


# **blockUser**
```swift
    open class func blockUser(uid: String, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Block a user

Block a user

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let uid = "uid_example" // String | the user's id

// Block a user
UserAPI.blockUser(uid: uid) { (response, error) in
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
 **uid** | **String** | the user&#39;s id | 

### Return type

Void (empty response body)

### Authorization

[DeviceId](../README.md#DeviceId), [ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteUserAvatar**
```swift
    open class func deleteUserAvatar(uid: String, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```



Remove user profile pic

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let uid = "uid_example" // String | the user's id

UserAPI.deleteUserAvatar(uid: uid) { (response, error) in
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
 **uid** | **String** | the user&#39;s id | 

### Return type

Void (empty response body)

### Authorization

[DeviceId](../README.md#DeviceId), [ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getBlockedUsers**
```swift
    open class func getBlockedUsers(completion: @escaping (_ data: [APIUser]?, _ error: Error?) -> Void)
```

Get blocked users

Get blocked users

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat


// Get blocked users
UserAPI.getBlockedUsers() { (response, error) in
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
This endpoint does not need any parameter.

### Return type

[**[APIUser]**](APIUser.md)

### Authorization

[DeviceId](../README.md#DeviceId), [ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getPendingEvents**
```swift
    open class func getPendingEvents(completion: @escaping (_ data: [Event]?, _ error: Error?) -> Void)
```



Get pending events for particular device

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat


UserAPI.getPendingEvents() { (response, error) in
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
This endpoint does not need any parameter.

### Return type

[**[Event]**](Event.md)

### Authorization

[DeviceId](../README.md#DeviceId), [ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getUser**
```swift
    open class func getUser(uid: String, completion: @escaping (_ data: APIUser?, _ error: Error?) -> Void)
```



Get a user

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let uid = "uid_example" // String | the user's id

UserAPI.getUser(uid: uid) { (response, error) in
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
 **uid** | **String** | the user&#39;s id | 

### Return type

[**APIUser**](APIUser.md)

### Authorization

[DeviceId](../README.md#DeviceId), [ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getUsers**
```swift
    open class func getUsers(lastId: String? = nil, lastCallTime: Int? = nil, updateType: String? = nil, completion: @escaping (_ data: [APIUser]?, _ error: Error?) -> Void)
```



List users

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let lastId = "lastId_example" // String | To be used for Pagination (optional)
let lastCallTime = 987 // Int | epoch time value for time based sunc. Do not pass this param itself for retrieving all data. (optional)
let updateType = "updateType_example" // String | type of sync i.e. addUpdated/inactive/deleted. Default value is addUpdated (optional)

UserAPI.getUsers(lastId: lastId, lastCallTime: lastCallTime, updateType: updateType) { (response, error) in
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
 **lastId** | **String** | To be used for Pagination | [optional] 
 **lastCallTime** | **Int** | epoch time value for time based sunc. Do not pass this param itself for retrieving all data. | [optional] 
 **updateType** | **String** | type of sync i.e. addUpdated/inactive/deleted. Default value is addUpdated | [optional] 

### Return type

[**[APIUser]**](APIUser.md)

### Authorization

[DeviceId](../README.md#DeviceId), [ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **me**
```swift
    open class func me(completion: @escaping (_ data: APIUser?, _ error: Error?) -> Void)
```



Get current user

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat


UserAPI.me() { (response, error) in
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
This endpoint does not need any parameter.

### Return type

[**APIUser**](APIUser.md)

### Authorization

[DeviceId](../README.md#DeviceId), [ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **refreshAuthToken**
```swift
    open class func refreshAuthToken(uid: String, completion: @escaping (_ data: Token?, _ error: Error?) -> Void)
```

Refresh auth token

Refresh auth token

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let uid = "uid_example" // String | the user's id

// Refresh auth token
UserAPI.refreshAuthToken(uid: uid) { (response, error) in
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
 **uid** | **String** | the user&#39;s id | 

### Return type

[**Token**](Token.md)

### Authorization

[DeviceId](../README.md#DeviceId), [ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **resetBadgeCount**
```swift
    open class func resetBadgeCount(completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

reset notification badge count

reset badge count

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat


// reset notification badge count
UserAPI.resetBadgeCount() { (response, error) in
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
This endpoint does not need any parameter.

### Return type

Void (empty response body)

### Authorization

[DeviceId](../README.md#DeviceId), [ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **syncContacts**
```swift
    open class func syncContacts(syncContactsInput: SyncContactsInput? = nil, completion: @escaping (_ data: [APIUser]?, _ error: Error?) -> Void)
```

Sync Contacts

Sync contacts

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let syncContactsInput = SyncContactsInput(contacts: ["contacts_example"]) // SyncContactsInput |  (optional)

// Sync Contacts
UserAPI.syncContacts(syncContactsInput: syncContactsInput) { (response, error) in
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
 **syncContactsInput** | [**SyncContactsInput**](SyncContactsInput.md) |  | [optional] 

### Return type

[**[APIUser]**](APIUser.md)

### Authorization

[DeviceId](../README.md#DeviceId), [ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **unblockUser**
```swift
    open class func unblockUser(uid: String, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Unblock a user

Unblock a user

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let uid = "uid_example" // String | the user's id

// Unblock a user
UserAPI.unblockUser(uid: uid) { (response, error) in
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
 **uid** | **String** | the user&#39;s id | 

### Return type

Void (empty response body)

### Authorization

[DeviceId](../README.md#DeviceId), [ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateMe**
```swift
    open class func updateMe(updateUserInput: UpdateUserInput, completion: @escaping (_ data: APIUser?, _ error: Error?) -> Void)
```



Update current user

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let updateUserInput = UpdateUserInput(fcmToken: "fcmToken_example", fcmVersion: "fcmVersion_example", apnsToken: "apnsToken_example", availabilityStatus: AvailabilityStatus(), notificationSettings: NotificationSettings(allowFrom: "allowFrom_example", validTill: "validTill_example", validTillDisplayValue: "validTillDisplayValue_example"), displayName: "displayName_example", username: "username_example", phoneNumber: "phoneNumber_example") // UpdateUserInput | User properties to update with

UserAPI.updateMe(updateUserInput: updateUserInput) { (response, error) in
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
 **updateUserInput** | [**UpdateUserInput**](UpdateUserInput.md) | User properties to update with | 

### Return type

[**APIUser**](APIUser.md)

### Authorization

[DeviceId](../README.md#DeviceId), [ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

