# APISearchAPI

All URIs are relative to *https://chat.inappchat.io/v3*

Method | HTTP request | Description
------------- | ------------- | -------------
[**search**](APISearchAPI.md#search) | **POST** /search | Unified search API


# **search**
```swift
    internal class func search(deviceid: String, searchInput: SearchInput, skip: String? = nil, limit: String? = nil, completion: @escaping (_ data: SearchResults?, _ error: Error?) -> Void)
```

Unified search API

One stop for all search APIs, can be used to search files, messages or groups.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let deviceid = "deviceid_example" // String | Source device ID
let searchInput = SearchInput(searchQuery: SearchQuery(text: "text_example", threadId: "threadId_example", channelQuery: ChannelQuery(joined: true, groupType: "groupType_example")), resultCategories: ["resultCategories_example"]) // SearchInput | Chat multiple request
let skip = "skip_example" // String | skip value for pagination. i.e. index. default 0 (optional)
let limit = "limit_example" // String | limit value for pagination. i.e. page-size. default 10 (optional)

// Unified search API
APISearchAPI.search(deviceid: deviceid, searchInput: searchInput, skip: skip, limit: limit) { (response, error) in
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
 **searchInput** | [**SearchInput**](SearchInput.md) | Chat multiple request | 
 **skip** | **String** | skip value for pagination. i.e. index. default 0 | [optional] 
 **limit** | **String** | limit value for pagination. i.e. page-size. default 10 | [optional] 

### Return type

[**SearchResults**](SearchResults.md)

### Authorization

[ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

