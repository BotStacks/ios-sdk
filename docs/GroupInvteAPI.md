# GroupInvteAPI

All URIs are relative to *https://virtserver.swaggerhub.com/RBN/Socket-Server/1.0.0*

Method | HTTP request | Description
------------- | ------------- | -------------
[**versionTenantsTenantIdERTCUserIdGroupGroupIdInvitePost**](GroupInvteAPI.md#versiontenantstenantidertcuseridgroupgroupidinvitepost) | **POST** /{version}/tenants/{tenantId}/{eRTCUserId}/group/{groupId}/invite | create group invitation
[**versionTenantsTenantIdERTCUserIdGroupGroupIdInvitesAcceptPost**](GroupInvteAPI.md#versiontenantstenantidertcuseridgroupgroupidinvitesacceptpost) | **POST** /{version}/tenants/{tenantId}/{eRTCUserId}/group/{groupId}/invites/accept | accept group invitation
[**versionTenantsTenantIdERTCUserIdGroupGroupIdInvitesDismissPost**](GroupInvteAPI.md#versiontenantstenantidertcuseridgroupgroupidinvitesdismisspost) | **POST** /{version}/tenants/{tenantId}/{eRTCUserId}/group/{groupId}/invites/dismiss | dismiss group invitation
[**versionTenantsTenantIdERTCUserIdGroupInvitesGet**](GroupInvteAPI.md#versiontenantstenantidertcuseridgroupinvitesget) | **GET** /{version}/tenants/{tenantId}/{eRTCUserId}/group/invites | get group invitation


# **versionTenantsTenantIdERTCUserIdGroupGroupIdInvitePost**
```swift
    internal class func versionTenantsTenantIdERTCUserIdGroupGroupIdInvitePost(version: String, tenantId: String, eRTCUserId: String, groupId: String, xRequestSignature: String, xNonce: String, body: [String], completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

create group invitation

Invite new participant to group

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let version = "version_example" // String | API version
let tenantId = "tenantId_example" // String | Tenant ID
let eRTCUserId = "eRTCUserId_example" // String | user mongo ID
let groupId = "groupId_example" // String | group ID
let xRequestSignature = "xRequestSignature_example" // String | sha256 of <chatServer apiKey>~<bundleId>~<epoch timeStamp>
let xNonce = "xNonce_example" // String | epoch timestamp
let body = ["property_example"] // [String] | array of eRTCUserIds of invitees

// create group invitation
GroupInvteAPI.versionTenantsTenantIdERTCUserIdGroupGroupIdInvitePost(version: version, tenantId: tenantId, eRTCUserId: eRTCUserId, groupId: groupId, xRequestSignature: xRequestSignature, xNonce: xNonce, body: body) { (response, error) in
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
 **version** | **String** | API version | 
 **tenantId** | **String** | Tenant ID | 
 **eRTCUserId** | **String** | user mongo ID | 
 **groupId** | **String** | group ID | 
 **xRequestSignature** | **String** | sha256 of &lt;chatServer apiKey&gt;~&lt;bundleId&gt;~&lt;epoch timeStamp&gt; | 
 **xNonce** | **String** | epoch timestamp | 
 **body** | [**[String]**](String.md) | array of eRTCUserIds of invitees | 

### Return type

Void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **versionTenantsTenantIdERTCUserIdGroupGroupIdInvitesAcceptPost**
```swift
    internal class func versionTenantsTenantIdERTCUserIdGroupGroupIdInvitesAcceptPost(version: String, tenantId: String, eRTCUserId: String, groupId: String, xRequestSignature: String, xNonce: String, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

accept group invitation

Accept group invitation

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let version = "version_example" // String | API version
let tenantId = "tenantId_example" // String | Tenant ID
let eRTCUserId = "eRTCUserId_example" // String | user mongo ID
let groupId = "groupId_example" // String | group ID
let xRequestSignature = "xRequestSignature_example" // String | sha256 of <chatServer apiKey>~<bundleId>~<epoch timeStamp>
let xNonce = "xNonce_example" // String | epoch timestamp

// accept group invitation
GroupInvteAPI.versionTenantsTenantIdERTCUserIdGroupGroupIdInvitesAcceptPost(version: version, tenantId: tenantId, eRTCUserId: eRTCUserId, groupId: groupId, xRequestSignature: xRequestSignature, xNonce: xNonce) { (response, error) in
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
 **version** | **String** | API version | 
 **tenantId** | **String** | Tenant ID | 
 **eRTCUserId** | **String** | user mongo ID | 
 **groupId** | **String** | group ID | 
 **xRequestSignature** | **String** | sha256 of &lt;chatServer apiKey&gt;~&lt;bundleId&gt;~&lt;epoch timeStamp&gt; | 
 **xNonce** | **String** | epoch timestamp | 

### Return type

Void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **versionTenantsTenantIdERTCUserIdGroupGroupIdInvitesDismissPost**
```swift
    internal class func versionTenantsTenantIdERTCUserIdGroupGroupIdInvitesDismissPost(version: String, tenantId: String, eRTCUserId: String, groupId: String, xRequestSignature: String, xNonce: String, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

dismiss group invitation

Dissmiss group invitation

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let version = "version_example" // String | API version
let tenantId = "tenantId_example" // String | Tenant ID
let eRTCUserId = "eRTCUserId_example" // String | user mongo ID
let groupId = "groupId_example" // String | group ID
let xRequestSignature = "xRequestSignature_example" // String | sha256 of <chatServer apiKey>~<bundleId>~<epoch timeStamp>
let xNonce = "xNonce_example" // String | epoch timestamp

// dismiss group invitation
GroupInvteAPI.versionTenantsTenantIdERTCUserIdGroupGroupIdInvitesDismissPost(version: version, tenantId: tenantId, eRTCUserId: eRTCUserId, groupId: groupId, xRequestSignature: xRequestSignature, xNonce: xNonce) { (response, error) in
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
 **version** | **String** | API version | 
 **tenantId** | **String** | Tenant ID | 
 **eRTCUserId** | **String** | user mongo ID | 
 **groupId** | **String** | group ID | 
 **xRequestSignature** | **String** | sha256 of &lt;chatServer apiKey&gt;~&lt;bundleId&gt;~&lt;epoch timeStamp&gt; | 
 **xNonce** | **String** | epoch timestamp | 

### Return type

Void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **versionTenantsTenantIdERTCUserIdGroupInvitesGet**
```swift
    internal class func versionTenantsTenantIdERTCUserIdGroupInvitesGet(version: String, tenantId: String, eRTCUserId: String, xRequestSignature: String, xNonce: String, completion: @escaping (_ data: VersionTenantsTenantIdERTCUserIdGroupInvitesGet200Response?, _ error: Error?) -> Void)
```

get group invitation

Get group invitations for user

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let version = "version_example" // String | API version
let tenantId = "tenantId_example" // String | Tenant ID
let eRTCUserId = "eRTCUserId_example" // String | user mongo ID
let xRequestSignature = "xRequestSignature_example" // String | sha256 of <chatServer apiKey>~<bundleId>~<epoch timeStamp>
let xNonce = "xNonce_example" // String | epoch timestamp

// get group invitation
GroupInvteAPI.versionTenantsTenantIdERTCUserIdGroupInvitesGet(version: version, tenantId: tenantId, eRTCUserId: eRTCUserId, xRequestSignature: xRequestSignature, xNonce: xNonce) { (response, error) in
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
 **version** | **String** | API version | 
 **tenantId** | **String** | Tenant ID | 
 **eRTCUserId** | **String** | user mongo ID | 
 **xRequestSignature** | **String** | sha256 of &lt;chatServer apiKey&gt;~&lt;bundleId&gt;~&lt;epoch timeStamp&gt; | 
 **xNonce** | **String** | epoch timestamp | 

### Return type

[**VersionTenantsTenantIdERTCUserIdGroupInvitesGet200Response**](VersionTenantsTenantIdERTCUserIdGroupInvitesGet200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

