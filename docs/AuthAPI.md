# AuthAPI

All URIs are relative to *https://chat.inappchat.io/v3*

Method | HTTP request | Description
------------- | ------------- | -------------
[**changePassword**](AuthAPI.md#changepassword) | **POST** /auth/change-password | Change Password
[**login**](AuthAPI.md#login) | **POST** /auth/login | Login to InAppChat as a user on your Application.
[**logout**](AuthAPI.md#logout) | **POST** /logout | Logout
[**logoutOtherDevices**](AuthAPI.md#logoutotherdevices) | **POST** /logoutOtherDevices | Logout
[**nftLogin**](AuthAPI.md#nftlogin) | **POST** /auth/nft/login | signup and login with NFT
[**resetPassword**](AuthAPI.md#resetpassword) | **POST** /auth/reset-password | Forgot Password


# **changePassword**
```swift
    open class func changePassword(loginPasswordInput: LoginPasswordInput, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Change Password

API to change user password

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let loginPasswordInput = LoginPasswordInput(loginType: "loginType_example", appUserId: "appUserId_example", currentPassword: "currentPassword_example", newPassword: "newPassword_example") // LoginPasswordInput | 

// Change Password
AuthAPI.changePassword(loginPasswordInput: loginPasswordInput) { (response, error) in
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

[DeviceId](../README.md#DeviceId), [ApiKeyAuth](../README.md#ApiKeyAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **login**
```swift
    open class func login(loginInput: LoginInput, completion: @escaping (_ data: Auth?, _ error: Error?) -> Void)
```

Login to InAppChat as a user on your Application.

Login to InAppChat as a user on your Application. This will updated the User's profile info in InAppChat. InAppChat will verify the authenticity of the credentials provided by calling the configured backend function of your server.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let loginInput = LoginInput(userId: "userId_example", accessToken: "accessToken_example", email: "email_example", picture: "picture_example", name: "name_example", nickname: "nickname_example", deviceId: "deviceId_example", deviceType: "deviceType_example", fcmToken: "fcmToken_example", apnsToken: "apnsToken_example") // LoginInput | 

// Login to InAppChat as a user on your Application.
AuthAPI.login(loginInput: loginInput) { (response, error) in
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

[DeviceId](../README.md#DeviceId), [ApiKeyAuth](../README.md#ApiKeyAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **logout**
```swift
    open class func logout(completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Logout

Logout

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat


// Logout
AuthAPI.logout() { (response, error) in
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

# **logoutOtherDevices**
```swift
    open class func logoutOtherDevices(completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Logout

logoutOtherDevices

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat


// Logout
AuthAPI.logoutOtherDevices() { (response, error) in
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

# **nftLogin**
```swift
    open class func nftLogin(nFTLoginInput: NFTLoginInput, completion: @escaping (_ data: Auth?, _ error: Error?) -> Void)
```

signup and login with NFT

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let nFTLoginInput = NFTLoginInput(address: "address_example", contract: "contract_example", signature: "signature_example", tokenID: "tokenID_example", username: "username_example", profilePicture: "profilePicture_example") // NFTLoginInput | array of eRTCUserIds of invitees

// signup and login with NFT
AuthAPI.nftLogin(nFTLoginInput: nFTLoginInput) { (response, error) in
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

[DeviceId](../README.md#DeviceId), [ApiKeyAuth](../README.md#ApiKeyAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **resetPassword**
```swift
    open class func resetPassword(resetPasswordInput: ResetPasswordInput, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Forgot Password

On calling this API, password gets reset and new password gets delivered on email

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let resetPasswordInput = ResetPasswordInput(loginType: "loginType_example", appUserId: "appUserId_example") // ResetPasswordInput | 

// Forgot Password
AuthAPI.resetPassword(resetPasswordInput: resetPasswordInput) { (response, error) in
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

[DeviceId](../README.md#DeviceId), [ApiKeyAuth](../README.md#ApiKeyAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)
