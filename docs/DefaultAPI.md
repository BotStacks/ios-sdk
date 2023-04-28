# DefaultAPI

All URIs are relative to *https://chat.inappchat.io/v3*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getUserMessages**](DefaultAPI.md#getusermessages) | **GET** /user/{uid}/messages | 
[**stub**](DefaultAPI.md#stub) | **GET** /stub | 


# **getUserMessages**
```swift
    open class func getUserMessages(uid: String, skip: Int? = nil, limit: Int? = nil, msgType: MessageType? = nil, direction: Direction_getUserMessages? = nil, completion: @escaping (_ data: [APIMessage]?, _ error: Error?) -> Void)
```



### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let uid = "uid_example" // String | the user's id
let skip = 987 // Int | skip value for pagination. i.e. index. default 0 (optional) (default to 0)
let limit = 987 // Int | limit value for pagination. i.e. page-size. default 10 (optional) (default to 20)
let msgType = MessageType() // MessageType | Filters message by (optional)
let direction = "direction_example" // String | future/past (optional) (default to .past)

DefaultAPI.getUserMessages(uid: uid, skip: skip, limit: limit, msgType: msgType, direction: direction) { (response, error) in
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
 **skip** | **Int** | skip value for pagination. i.e. index. default 0 | [optional] [default to 0]
 **limit** | **Int** | limit value for pagination. i.e. page-size. default 10 | [optional] [default to 20]
 **msgType** | [**MessageType**](.md) | Filters message by | [optional] 
 **direction** | **String** | future/past | [optional] [default to .past]

### Return type

[**[APIMessage]**](APIMessage.md)

### Authorization

[DeviceId](../README.md#DeviceId), [ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **stub**
```swift
    open class func stub(completion: @escaping (_ data: Stub?, _ error: Error?) -> Void)
```



This api does not exist. This is only to generate types that wouldnt have otherwise been generated

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat


DefaultAPI.stub() { (response, error) in
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

[**Stub**](Stub.md)

### Authorization

[DeviceId](../README.md#DeviceId), [ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

