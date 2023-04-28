# FCMAPI

All URIs are relative to *https://chat.inappchat.io/v3*

Method | HTTP request | Description
------------- | ------------- | -------------
[**fCMValidationPost**](FCMAPI.md#fcmvalidationpost) | **POST** /fcmValidation | FCM Validation


# **fCMValidationPost**
```swift
    open class func fCMValidationPost(fCMValidationInput: FCMValidationInput, completion: @escaping (_ data: APIThread?, _ error: Error?) -> Void)
```

FCM Validation

Endpoint to just validate FCM notification by App teams

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let fCMValidationInput = FCMValidationInput(fcmToken: "fcmToken_example", payload: "TODO", options: "TODO") // FCMValidationInput | Unique AppID of the user to get

// FCM Validation
FCMAPI.fCMValidationPost(fCMValidationInput: fCMValidationInput) { (response, error) in
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
 **fCMValidationInput** | [**FCMValidationInput**](FCMValidationInput.md) | Unique AppID of the user to get | 

### Return type

[**APIThread**](APIThread.md)

### Authorization

[DeviceId](../README.md#DeviceId), [ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

