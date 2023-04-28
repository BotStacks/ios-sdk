# APIThreadAPI

All URIs are relative to *https://chat.inappchat.io/v3*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createThread**](APIThreadAPI.md#createthread) | **POST** /user/{uid}/thread | Thread Creation API
[**listThreads**](APIThreadAPI.md#listthreads) | **GET** /threads | Load thread history
[**threadGet**](APIThreadAPI.md#threadget) | **GET** /thread/{tid} | Thread Get API
[**updateThread**](APIThreadAPI.md#updatethread) | **PUT** /thread/{tid} | Thread Update API


# **createThread**
```swift
    internal class func createThread(uid: String, completion: @escaping (_ data: Thread?, _ error: Error?) -> Void)
```

Thread Creation API

Get or Create Thread request before starting chat session with any user. This API is applicable for only one 2 one chat.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let uid = "uid_example" // String | the user's id

// Thread Creation API
APIThreadAPI.createThread(uid: uid) { (response, error) in
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

[**Thread**](Thread.md)

### Authorization

[ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listThreads**
```swift
    internal class func listThreads(skip: String? = nil, limit: String? = nil, threadType: ThreadType_listThreads? = nil, completion: @escaping (_ data: [Thread]?, _ error: Error?) -> Void)
```

Load thread history

Load thread history

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let skip = "skip_example" // String | skip value for pagination. i.e. index. default 0 (optional)
let limit = "limit_example" // String | limit value for pagination. i.e. page-size. default 10 (optional)
let threadType = "threadType_example" // String | threadType in-case specific type threads are needed. Don't provide this field if all threads to be returned in unified way. (optional)

// Load thread history
APIThreadAPI.listThreads(skip: skip, limit: limit, threadType: threadType) { (response, error) in
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
 **skip** | **String** | skip value for pagination. i.e. index. default 0 | [optional] 
 **limit** | **String** | limit value for pagination. i.e. page-size. default 10 | [optional] 
 **threadType** | **String** | threadType in-case specific type threads are needed. Don&#39;t provide this field if all threads to be returned in unified way. | [optional] 

### Return type

[**[Thread]**](Thread.md)

### Authorization

[ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **threadGet**
```swift
    internal class func threadGet(tid: String, uid: String, completion: @escaping (_ data: Thread?, _ error: Error?) -> Void)
```

Thread Get API

Get any existing thread

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let tid = "tid_example" // String | The Thread ID
let uid = "uid_example" // String | the user's id

// Thread Get API
APIThreadAPI.threadGet(tid: tid, uid: uid) { (response, error) in
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
 **tid** | **String** | The Thread ID | 
 **uid** | **String** | the user&#39;s id | 

### Return type

[**Thread**](Thread.md)

### Authorization

[ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateThread**
```swift
    internal class func updateThread(tid: String, updateThreadInput: UpdateThreadInput, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Thread Update API

Update any existing thread

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let tid = "tid_example" // String | The Thread ID
let updateThreadInput = UpdateThreadInput(notificationSettings: NotificationSettings(allowFrom: "allowFrom_example", validTill: "validTill_example", validTillDisplayValue: "validTillDisplayValue_example"), autoDeleteSetting: AutoDeleteSettings(enabled: true, deleteAfterMiliSeconds: 123)) // UpdateThreadInput | Thread settings

// Thread Update API
APIThreadAPI.updateThread(tid: tid, updateThreadInput: updateThreadInput) { (response, error) in
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
 **tid** | **String** | The Thread ID | 
 **updateThreadInput** | [**UpdateThreadInput**](UpdateThreadInput.md) | Thread settings | 

### Return type

Void (empty response body)

### Authorization

[ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

