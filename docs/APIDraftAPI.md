# APIDraftAPI

All URIs are relative to *https://chat.inappchat.io/v3*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getDrafts**](APIDraftAPI.md#getdrafts) | **GET** /draft | Draft API
[**updateDraft**](APIDraftAPI.md#updatedraft) | **POST** /draft | Draft API


# **getDrafts**
```swift
    internal class func getDrafts(deviceid: String, threadId: String? = nil, baseMsgUniqueId: String? = nil, completion: @escaping (_ data: Message?, _ error: Error?) -> Void)
```

Draft API

Send chat over a thread

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let deviceid = "deviceid_example" // String | Source device ID
let threadId = "threadId_example" // String | Get draft for a particular thread (optional)
let baseMsgUniqueId = "baseMsgUniqueId_example" // String | Get thread for a reply thread, this is base message id (optional)

// Draft API
APIDraftAPI.getDrafts(deviceid: deviceid, threadId: threadId, baseMsgUniqueId: baseMsgUniqueId) { (response, error) in
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
 **threadId** | **String** | Get draft for a particular thread | [optional] 
 **baseMsgUniqueId** | **String** | Get thread for a reply thread, this is base message id | [optional] 

### Return type

[**Message**](Message.md)

### Authorization

[ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateDraft**
```swift
    internal class func updateDraft(deviceid: String, updateDraftRequest: UpdateDraftRequest, completion: @escaping (_ data: Message?, _ error: Error?) -> Void)
```

Draft API

Send chat over a thread

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let deviceid = "deviceid_example" // String | Source device ID
let updateDraftRequest = TODO // UpdateDraftRequest | 

// Draft API
APIDraftAPI.updateDraft(deviceid: deviceid, updateDraftRequest: updateDraftRequest) { (response, error) in
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
 **updateDraftRequest** | [**UpdateDraftRequest**](UpdateDraftRequest.md) |  | 

### Return type

[**Message**](Message.md)

### Authorization

[ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: multipart/form-data
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

