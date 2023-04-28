# APIAuthAPI

All URIs are relative to *https://chat.inappchat.io/v3*

Method | HTTP request | Description
------------- | ------------- | -------------
[**auth0Login**](APIAuthAPI.md#auth0login) | **POST** /auth/auth0/login | Verify User information
[**changePassword**](APIAuthAPI.md#changepassword) | **POST** /auth/change-password | Change Password
[**logout**](APIAuthAPI.md#logout) | **POST** /logout | Logout
[**logoutOtherDevices**](APIAuthAPI.md#logoutotherdevices) | **POST** /logoutOtherDevices | Logout
[**nftLogin**](APIAuthAPI.md#nftlogin) | **POST** /auth/nft/login | signup and login with NFT
[**resetPassword**](APIAuthAPI.md#resetpassword) | **POST** /auth/reset-password | Forgot Password


# **auth0Login**
```swift
    internal class func auth0Login(loginInput: LoginInput, completion: @escaping (_ data: Auth?, _ error: Error?) -> Void)
```

Verify User information

verify user information, device information

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let loginInput = LoginInput(loginType: "loginType_example", appUserId: "appUserId_example", deviceId: "deviceId_example", deviceType: "deviceType_example", fcmToken: "fcmToken_example") // LoginInput | 

// Verify User information
APIAuthAPI.auth0Login(loginInput: loginInput) { (response, error) in
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
 **loginInput** | [**LoginInput**](LoginInput.md) |  | 

### Return type

[**Auth**](Auth.md)

### Authorization

[ApiKeyAuth](../README.md#ApiKeyAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

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
APIAuthAPI.changePassword(loginPasswordInput: loginPasswordInput) { (response, error) in
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

# **logout**
```swift
    internal class func logout(deviceid: String, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Logout

Logout

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let deviceid = "deviceid_example" // String | Source device ID

// Logout
APIAuthAPI.logout(deviceid: deviceid) { (response, error) in
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

Void (empty response body)

### Authorization

[ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **logoutOtherDevices**
```swift
    internal class func logoutOtherDevices(completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Logout

logoutOtherDevices

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat


// Logout
APIAuthAPI.logoutOtherDevices() { (response, error) in
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

# **nftLogin**
```swift
    internal class func nftLogin(nFTLoginInput: NFTLoginInput, completion: @escaping (_ data: Auth?, _ error: Error?) -> Void)
```

signup and login with NFT

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let nFTLoginInput = NFTLoginInput(address: "address_example", contract: "contract_example", signature: "signature_example", tokenID: "tokenID_example", username: "username_example", profilePicture: "profilePicture_example") // NFTLoginInput | array of eRTCUserIds of invitees

// signup and login with NFT
APIAuthAPI.nftLogin(nFTLoginInput: nFTLoginInput) { (response, error) in
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
 **nFTLoginInput** | [**NFTLoginInput**](NFTLoginInput.md) | array of eRTCUserIds of invitees | 

### Return type

[**Auth**](Auth.md)

### Authorization

[ApiKeyAuth](../README.md#ApiKeyAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

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
APIAuthAPI.resetPassword(resetPasswordInput: resetPasswordInput) { (response, error) in
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

