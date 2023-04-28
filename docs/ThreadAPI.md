# ThreadAPI

All URIs are relative to *https://chat.inappchat.io/v3*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createThread**](ThreadAPI.md#createthread) | **POST** /user/{uid}/thread | Thread Creation API
[**getGroupThread**](ThreadAPI.md#getgroupthread) | **GET** /group/{gid}/thread | 
[**getThread**](ThreadAPI.md#getthread) | **GET** /thread/{tid} | Thread Get API
[**getThreads**](ThreadAPI.md#getthreads) | **GET** /threads | Load thread history
[**updateThread**](ThreadAPI.md#updatethread) | **PUT** /thread/{tid} | Thread Update API


# **createThread**
```swift
    open class func createThread(uid: String, completion: @escaping (_ data: APIThread?, _ error: Error?) -> Void)
```

Thread Creation API

Get or Create Thread request before starting chat session with any user. This API is applicable for only one 2 one chat.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let uid = "uid_example" // String | the user's id

// Thread Creation API
ThreadAPI.createThread(uid: uid) { (response, error) in
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

[**APIThread**](APIThread.md)

### Authorization

[DeviceId](../README.md#DeviceId), [ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getGroupThread**
```swift
    open class func getGroupThread(gid: String, completion: @escaping (_ data: APIThread?, _ error: Error?) -> Void)
```



Get a thread belonging to a group

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let gid = "gid_example" // String | Group ID

ThreadAPI.getGroupThread(gid: gid) { (response, error) in
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
 **gid** | **String** | Group ID | 

### Return type

[**APIThread**](APIThread.md)

### Authorization

[DeviceId](../README.md#DeviceId), [ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getThread**
```swift
    open class func getThread(tid: String, completion: @escaping (_ data: APIThread?, _ error: Error?) -> Void)
```

Thread Get API

Get any existing thread

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let tid = "tid_example" // String | The Thread ID

// Thread Get API
ThreadAPI.getThread(tid: tid) { (response, error) in
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

### Return type

[**APIThread**](APIThread.md)

### Authorization

[DeviceId](../README.md#DeviceId), [ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getThreads**
```swift
    open class func getThreads(skip: Int? = nil, limit: Int? = nil, threadType: ThreadType_getThreads? = nil, completion: @escaping (_ data: [APIThread]?, _ error: Error?) -> Void)
```

Load thread history

Load thread history

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let skip = 987 // Int | skip value for pagination. i.e. index. default 0 (optional) (default to 0)
let limit = 987 // Int | limit value for pagination. i.e. page-size. default 10 (optional) (default to 20)
let threadType = "threadType_example" // String | threadType in-case specific type threads are needed. Don't provide this field if all threads to be returned in unified way. (optional)

// Load thread history
ThreadAPI.getThreads(skip: skip, limit: limit, threadType: threadType) { (response, error) in
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
 **skip** | **Int** | skip value for pagination. i.e. index. default 0 | [optional] [default to 0]
 **limit** | **Int** | limit value for pagination. i.e. page-size. default 10 | [optional] [default to 20]
 **threadType** | **String** | threadType in-case specific type threads are needed. Don&#39;t provide this field if all threads to be returned in unified way. | [optional] 

### Return type

[**[APIThread]**](APIThread.md)

### Authorization

[DeviceId](../README.md#DeviceId), [ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateThread**
```swift
    open class func updateThread(tid: String, updateThreadInput: UpdateThreadInput, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
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
ThreadAPI.updateThread(tid: tid, updateThreadInput: updateThreadInput) { (response, error) in
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

[DeviceId](../README.md#DeviceId), [ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

