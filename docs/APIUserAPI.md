# APIUserAPI

All URIs are relative to *https://chat.inappchat.io/v3*

Method | HTTP request | Description
------------- | ------------- | -------------
[**blockUser**](APIUserAPI.md#blockuser) | **PUT** /blocks/{uid} | Block a user
[**deleteUserAvatar**](APIUserAPI.md#deleteuseravatar) | **DELETE** /users/{uid}/avatar | 
[**getBlockedUsers**](APIUserAPI.md#getblockedusers) | **GET** /blocks | Get blocked users
[**getPendingEvents**](APIUserAPI.md#getpendingevents) | **GET** /events | 
[**getUser**](APIUserAPI.md#getuser) | **GET** /user/{uid} | 
[**getUsers**](APIUserAPI.md#getusers) | **GET** /users | 
[**refreshAuthToken**](APIUserAPI.md#refreshauthtoken) | **GET** /token/refresh | Refresh auth token
[**resetBadgeCount**](APIUserAPI.md#resetbadgecount) | **GET** /resetBadgeCount | reset notification badge count
[**syncContacts**](APIUserAPI.md#synccontacts) | **POST** /contacts/sync | Sync Contacts
[**unblockUser**](APIUserAPI.md#unblockuser) | **DELETE** /blocks/{uid} | Unblock a user
[**updateUser**](APIUserAPI.md#updateuser) | **POST** /user/{uid} | Update user


# **blockUser**
```swift
    internal class func blockUser(uid: String, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Block a user

Block a user

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let uid = "uid_example" // String | the user's id

// Block a user
APIUserAPI.blockUser(uid: uid) { (response, error) in
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

[ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteUserAvatar**
```swift
    internal class func deleteUserAvatar(uid: String, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```



Remove user profile pic

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let uid = "uid_example" // String | the user's id

APIUserAPI.deleteUserAvatar(uid: uid) { (response, error) in
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

[ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getBlockedUsers**
```swift
    internal class func getBlockedUsers(completion: @escaping (_ data: [User]?, _ error: Error?) -> Void)
```

Get blocked users

Get blocked users

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat


// Get blocked users
APIUserAPI.getBlockedUsers() { (response, error) in
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

[**[User]**](User.md)

### Authorization

[ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getPendingEvents**
```swift
    internal class func getPendingEvents(deviceid: String, completion: @escaping (_ data: [Event]?, _ error: Error?) -> Void)
```



Get pending events for particular device

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let deviceid = "deviceid_example" // String | Source device ID

APIUserAPI.getPendingEvents(deviceid: deviceid) { (response, error) in
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
 **deviceid** | **String** | Source device ID | 

### Return type

[**[Event]**](Event.md)

### Authorization

[ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getUser**
```swift
    internal class func getUser(uid: String, completion: @escaping (_ data: User?, _ error: Error?) -> Void)
```



Get a user

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let uid = "uid_example" // String | the user's id

APIUserAPI.getUser(uid: uid) { (response, error) in
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

[**User**](User.md)

### Authorization

[ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getUsers**
```swift
    internal class func getUsers(lastId: String? = nil, lastCallTime: Int? = nil, updateType: String? = nil, completion: @escaping (_ data: [User]?, _ error: Error?) -> Void)
```



List users

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let lastId = "lastId_example" // String | To be used for Pagination (optional)
let lastCallTime = 987 // Int | epoch time value for time based sunc. Do not pass this param itself for retrieving all data. (optional)
let updateType = "updateType_example" // String | type of sync i.e. addUpdated/inactive/deleted. Default value is addUpdated (optional)

APIUserAPI.getUsers(lastId: lastId, lastCallTime: lastCallTime, updateType: updateType) { (response, error) in
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

[**[User]**](User.md)

### Authorization

[ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **refreshAuthToken**
```swift
    internal class func refreshAuthToken(uid: String, completion: @escaping (_ data: Token?, _ error: Error?) -> Void)
```

Refresh auth token

Refresh auth token

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let uid = "uid_example" // String | the user's id

// Refresh auth token
APIUserAPI.refreshAuthToken(uid: uid) { (response, error) in
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

[ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **resetBadgeCount**
```swift
    internal class func resetBadgeCount(completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

reset notification badge count

reset badge count

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat


// reset notification badge count
APIUserAPI.resetBadgeCount() { (response, error) in
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

[ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **syncContacts**
```swift
    internal class func syncContacts(syncContactsInput: SyncContactsInput? = nil, completion: @escaping (_ data: SyncContacts200Response?, _ error: Error?) -> Void)
```

Sync Contacts

Sync contacts

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let syncContactsInput = SyncContactsInput(contacts: ["contacts_example"]) // SyncContactsInput |  (optional)

// Sync Contacts
APIUserAPI.syncContacts(syncContactsInput: syncContactsInput) { (response, error) in
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

[**SyncContacts200Response**](SyncContacts200Response.md)

### Authorization

[ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **unblockUser**
```swift
    internal class func unblockUser(uid: String, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Unblock a user

Unblock a user

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let uid = "uid_example" // String | the user's id

// Unblock a user
APIUserAPI.unblockUser(uid: uid) { (response, error) in
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

[ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateUser**
```swift
    internal class func updateUser(uid: String, updateUserInput: UpdateUserInput, completion: @escaping (_ data: User?, _ error: Error?) -> Void)
```

Update user

Update a user

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let uid = "uid_example" // String | the user's id
let updateUserInput = UpdateUserInput(deviceId: "deviceId_example", deviceType: "deviceType_example", fcmToken: "fcmToken_example", fcmVersion: "fcmVersion_example", availabilityStatus: "availabilityStatus_example", notificationSettings: NotificationSettings(allowFrom: "allowFrom_example", validTill: "validTill_example", validTillDisplayValue: "validTillDisplayValue_example"), displayName: "displayName_example", username: "username_example", phoneNumber: "phoneNumber_example") // UpdateUserInput | User properties to update with

// Update user
APIUserAPI.updateUser(uid: uid, updateUserInput: updateUserInput) { (response, error) in
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
 **updateUserInput** | [**UpdateUserInput**](UpdateUserInput.md) | User properties to update with | 

### Return type

[**User**](User.md)

### Authorization

[ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

