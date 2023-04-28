# PasswordAPI

All URIs are relative to *https://chat.inappchat.io/v3*

Method | HTTP request | Description
------------- | ------------- | -------------
[**changePassword**](PasswordAPI.md#changepassword) | **POST** /auth/change-password | Change Password
[**resetPassword**](PasswordAPI.md#resetpassword) | **POST** /auth/reset-password | Forgot Password


# **changePassword**
```swift
    internal class func changePassword(loginPasswordInput: LoginPasswordInput, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Change Password

API to change user password

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let loginPasswordInput = LoginPasswordInput(loginType: "loginType_example", appUserId: "appUserId_example", currentPassword: "currentPassword_example", newPassword: "newPassword_example") // LoginPasswordInput | 

// Change Password
PasswordAPI.changePassword(loginPasswordInput: loginPasswordInput) { (response, error) in
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
 **loginPasswordInput** | [**LoginPasswordInput**](LoginPasswordInput.md) |  | 

### Return type

Void (empty response body)

### Authorization

[ApiKeyAuth](../README.md#ApiKeyAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **resetPassword**
```swift
    internal class func resetPassword(resetPasswordInput: ResetPasswordInput, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Forgot Password

On calling this API, password gets reset and new password gets delivered on email

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let resetPasswordInput = ResetPasswordInput(loginType: "loginType_example", appUserId: "appUserId_example") // ResetPasswordInput | 

// Forgot Password
PasswordAPI.resetPassword(resetPasswordInput: resetPasswordInput) { (response, error) in
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
 **resetPasswordInput** | [**ResetPasswordInput**](ResetPasswordInput.md) |  | 

### Return type

Void (empty response body)

### Authorization

[ApiKeyAuth](../README.md#ApiKeyAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

