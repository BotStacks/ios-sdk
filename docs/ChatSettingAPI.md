# ChatSettingAPI

All URIs are relative to *https://chat.inappchat.io/v3*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getSettings**](ChatSettingAPI.md#getsettings) | **GET** /settings | Get chat settings that contains profanity and domain filters


# **getSettings**
```swift
    open class func getSettings(completion: @escaping (_ data: ChatSettings?, _ error: Error?) -> Void)
```

Get chat settings that contains profanity and domain filters

Get profanity and domain filter.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat


// Get chat settings that contains profanity and domain filters
ChatSettingAPI.getSettings() { (response, error) in
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

[**ChatSettings**](ChatSettings.md)

### Authorization

[DeviceId](../README.md#DeviceId), [ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

