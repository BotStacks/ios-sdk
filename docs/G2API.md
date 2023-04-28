# G2API

All URIs are relative to *https://virtserver.swaggerhub.com/RBN/Socket-Server/1.0.0*

Method | HTTP request | Description
------------- | ------------- | -------------
[**nFTLoginPOST**](G2API.md#nftloginpost) | **POST** /{version}/tenants/{tenantId}/nft-login | Posion POG NFT based Login


# **nFTLoginPOST**
```swift
    internal class func nFTLoginPOST(version: String, tenantId: String, authorization: String, completion: @escaping (_ data: NFTLoginPOST200Response?, _ error: Error?) -> Void)
```

Posion POG NFT based Login

This api verify auth0 token and add user to dtabase

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let version = "version_example" // String | API versiion
let tenantId = "tenantId_example" // String | Tenant Id. Example 5f61c2c3fee2af1f303a16d7
let authorization = "authorization_example" // String | Auth0 id_token

// Posion POG NFT based Login
G2API.nFTLoginPOST(version: version, tenantId: tenantId, authorization: authorization) { (response, error) in
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
 **version** | **String** | API versiion | 
 **tenantId** | **String** | Tenant Id. Example 5f61c2c3fee2af1f303a16d7 | 
 **authorization** | **String** | Auth0 id_token | 

### Return type

[**NFTLoginPOST200Response**](NFTLoginPOST200Response.md)

### Authorization

[sdk_key](../README.md#sdk_key)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

