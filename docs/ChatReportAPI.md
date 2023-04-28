# ChatReportAPI

All URIs are relative to *https://chat.inappchat.io/v3*

Method | HTTP request | Description
------------- | ------------- | -------------
[**approveChatReport**](ChatReportAPI.md#approvechatreport) | **PUT** /reports/{chatReportId}/approve | 
[**createChatReport**](ChatReportAPI.md#createchatreport) | **POST** /message/{mid}/report | 
[**deleteChatReportDelete**](ChatReportAPI.md#deletechatreportdelete) | **DELETE** /reports/{chatReportId} | Delete Chat Report
[**getChatReport**](ChatReportAPI.md#getchatreport) | **GET** /reports/{chatReportId} | Get Chat Report Details
[**getChatReportList**](ChatReportAPI.md#getchatreportlist) | **GET** /reports | Get Chat Report List
[**ignoreChatReport**](ChatReportAPI.md#ignorechatreport) | **PUT** /reports/{chatReportId}/ignore | 
[**updateChatReport**](ChatReportAPI.md#updatechatreport) | **PUT** /reports/{chatReportId} | 


# **approveChatReport**
```swift
    open class func approveChatReport(chatReportId: String, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```



Approve Chat Report Action.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let chatReportId = "chatReportId_example" // String | chat Report ID

ChatReportAPI.approveChatReport(chatReportId: chatReportId) { (response, error) in
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
 **chatReportId** | **String** | chat Report ID | 

### Return type

Void (empty response body)

### Authorization

[DeviceId](../README.md#DeviceId), [ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createChatReport**
```swift
    open class func createChatReport(mid: String, createChatReport: CreateChatReport, completion: @escaping (_ data: Report?, _ error: Error?) -> Void)
```



Create Chat Report.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let mid = "mid_example" // String | The message ID
let createChatReport = CreateChatReport(category: "category_example", reason: "reason_example") // CreateChatReport | 

ChatReportAPI.createChatReport(mid: mid, createChatReport: createChatReport) { (response, error) in
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
 **mid** | **String** | The message ID | 
 **createChatReport** | [**CreateChatReport**](CreateChatReport.md) |  | 

### Return type

[**Report**](Report.md)

### Authorization

[DeviceId](../README.md#DeviceId), [ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteChatReportDelete**
```swift
    open class func deleteChatReportDelete(chatReportId: String, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Delete Chat Report

Delete Chat Report.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let chatReportId = "chatReportId_example" // String | chat Report ID

// Delete Chat Report
ChatReportAPI.deleteChatReportDelete(chatReportId: chatReportId) { (response, error) in
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
 **chatReportId** | **String** | chat Report ID | 

### Return type

Void (empty response body)

### Authorization

[DeviceId](../README.md#DeviceId), [ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getChatReport**
```swift
    open class func getChatReport(chatReportId: String, completion: @escaping (_ data: Report?, _ error: Error?) -> Void)
```

Get Chat Report Details

Get Chat Report Details.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let chatReportId = "chatReportId_example" // String | chat Report ID

// Get Chat Report Details
ChatReportAPI.getChatReport(chatReportId: chatReportId) { (response, error) in
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
 **chatReportId** | **String** | chat Report ID | 

### Return type

[**Report**](Report.md)

### Authorization

[DeviceId](../README.md#DeviceId), [ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getChatReportList**
```swift
    open class func getChatReportList(uid: String, skip: Int? = nil, limit: Int? = nil, threadId: String? = nil, category: ReportCategory? = nil, status: ReportStatus? = nil, msgType: String? = nil, completion: @escaping (_ data: [Report]?, _ error: Error?) -> Void)
```

Get Chat Report List

Get Chat Report List.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let uid = "uid_example" // String | the user's id
let skip = 987 // Int | skip value for pagination. i.e. index. default 0 (optional) (default to 0)
let limit = 987 // Int | limit value for pagination. i.e. page-size. default 10 (optional) (default to 20)
let threadId = "threadId_example" // String | thread ID to filter chat Reports (optional)
let category = ReportCategory() // ReportCategory |  (optional)
let status = ReportStatus() // ReportStatus |  (optional)
let msgType = "msgType_example" // String | chat report msgType to filter chat Reports(Possible values : text, image, audio, video, file, gif, location, contact, sticker, gify) (optional)

// Get Chat Report List
ChatReportAPI.getChatReportList(uid: uid, skip: skip, limit: limit, threadId: threadId, category: category, status: status, msgType: msgType) { (response, error) in
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
 **threadId** | **String** | thread ID to filter chat Reports | [optional] 
 **category** | [**ReportCategory**](.md) |  | [optional] 
 **status** | [**ReportStatus**](.md) |  | [optional] 
 **msgType** | **String** | chat report msgType to filter chat Reports(Possible values : text, image, audio, video, file, gif, location, contact, sticker, gify) | [optional] 

### Return type

[**[Report]**](Report.md)

### Authorization

[DeviceId](../README.md#DeviceId), [ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **ignoreChatReport**
```swift
    open class func ignoreChatReport(chatReportId: String, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```



Ignore Chat Report Action.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let chatReportId = "chatReportId_example" // String | chat Report ID

ChatReportAPI.ignoreChatReport(chatReportId: chatReportId) { (response, error) in
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
 **chatReportId** | **String** | chat Report ID | 

### Return type

Void (empty response body)

### Authorization

[DeviceId](../README.md#DeviceId), [ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateChatReport**
```swift
    open class func updateChatReport(chatReportId: String, createChatReport: CreateChatReport, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```



Update Chat Report.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let chatReportId = "chatReportId_example" // String | chat Report ID
let createChatReport = CreateChatReport(category: "category_example", reason: "reason_example") // CreateChatReport | 

ChatReportAPI.updateChatReport(chatReportId: chatReportId, createChatReport: createChatReport) { (response, error) in
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
 **chatReportId** | **String** | chat Report ID | 
 **createChatReport** | [**CreateChatReport**](CreateChatReport.md) |  | 

### Return type

Void (empty response body)

### Authorization

[DeviceId](../README.md#DeviceId), [ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

