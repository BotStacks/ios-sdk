# APIChatAPI

All URIs are relative to *https://chat.inappchat.io/v3*

Method | HTTP request | Description
------------- | ------------- | -------------
[**deleteChatHistory**](APIChatAPI.md#deletechathistory) | **DELETE** /thread/{tid}/messages | Load chat history
[**deleteMessage**](APIChatAPI.md#deletemessage) | **DELETE** /message/{mid} | Delete Message API
[**getReplyThreads**](APIChatAPI.md#getreplythreads) | **GET** /reply-threads | List reply threads
[**listMessages**](APIChatAPI.md#listmessages) | **GET** /thread/{tid}/messages | Load chat history
[**react**](APIChatAPI.md#react) | **PUT** /meessage/{mid}/reactions/{emoji} | Chat Reaction API
[**sendMessage**](APIChatAPI.md#sendmessage) | **POST** /message | Send a chat message
[**unreact**](APIChatAPI.md#unreact) | **DELETE** /meessage/{mid}/reactions/{emoji} | 
[**updateMessage**](APIChatAPI.md#updatemessage) | **PUT** /message/{mid} | Edit Message API


# **deleteChatHistory**
```swift
    internal class func deleteChatHistory(tid: String, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Load chat history

Clear chat history

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let tid = "tid_example" // String | The Thread ID

// Load chat history
APIChatAPI.deleteChatHistory(tid: tid) { (response, error) in
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
 **tid** | **String** | The Thread ID | 

### Return type

Void (empty response body)

### Authorization

[ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteMessage**
```swift
    internal class func deleteMessage(mid: String, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Delete Message API

Delete particular message

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let mid = "mid_example" // String | The message ID

// Delete Message API
APIChatAPI.deleteMessage(mid: mid) { (response, error) in
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

### Return type

Void (empty response body)

### Authorization

[ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getReplyThreads**
```swift
    internal class func getReplyThreads(threadId: String? = nil, follow: Bool? = nil, starred: Bool? = nil, msgType: String? = nil, currentMsgId: String? = nil, direction: String? = nil, pageSize: String? = nil, deep: Bool? = nil, completion: @escaping (_ data: [Message]?, _ error: Error?) -> Void)
```

List reply threads

List messages with reply threads

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let threadId = "threadId_example" // String | Thread ID (optional)
let follow = true // Bool | To get all threads user following, just send true (optional)
let starred = true // Bool | To get all starred messages, just send true (optional)
let msgType = "msgType_example" // String | Msg type, stringified array Example [\"text\".\"gif\"] (optional)
let currentMsgId = "currentMsgId_example" // String | message Id. Example 5fabd417f9e67f996ce84140 (optional)
let direction = "direction_example" // String | future/past (optional)
let pageSize = "pageSize_example" // String | page size for pagination (optional)
let deep = true // Bool | When true it returns messages from threads and main window both (optional)

// List reply threads
APIChatAPI.getReplyThreads(threadId: threadId, follow: follow, starred: starred, msgType: msgType, currentMsgId: currentMsgId, direction: direction, pageSize: pageSize, deep: deep) { (response, error) in
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
 **threadId** | **String** | Thread ID | [optional] 
 **follow** | **Bool** | To get all threads user following, just send true | [optional] 
 **starred** | **Bool** | To get all starred messages, just send true | [optional] 
 **msgType** | **String** | Msg type, stringified array Example [\&quot;text\&quot;.\&quot;gif\&quot;] | [optional] 
 **currentMsgId** | **String** | message Id. Example 5fabd417f9e67f996ce84140 | [optional] 
 **direction** | **String** | future/past | [optional] 
 **pageSize** | **String** | page size for pagination | [optional] 
 **deep** | **Bool** | When true it returns messages from threads and main window both | [optional] 

### Return type

[**[Message]**](Message.md)

### Authorization

[ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listMessages**
```swift
    internal class func listMessages(tid: String, msgType: String? = nil, currentMsgId: String? = nil, direction: String? = nil, dateFrom: String? = nil, dateTo: String? = nil, pageSize: String? = nil, inReplyTo: String? = nil, deep: Bool? = nil, completion: @escaping (_ data: [Message]?, _ error: Error?) -> Void)
```

Load chat history

List messages in any chat

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let tid = "tid_example" // String | The Thread ID
let msgType = "msgType_example" // String | Msg type, stringified array Example [\"text\".\"gif\"] (optional)
let currentMsgId = "currentMsgId_example" // String | THe message ID to paginate after or before (optional)
let direction = "direction_example" // String | future/past (optional)
let dateFrom = "dateFrom_example" // String | ISO string of start date (optional)
let dateTo = "dateTo_example" // String | ISO string of end date (optional)
let pageSize = "pageSize_example" // String | page size for pagination (optional)
let inReplyTo = "inReplyTo_example" // String | The ID of the message to list replies for (optional)
let deep = true // Bool | When true it returns messages from threads and main window both (optional)

// Load chat history
APIChatAPI.listMessages(tid: tid, msgType: msgType, currentMsgId: currentMsgId, direction: direction, dateFrom: dateFrom, dateTo: dateTo, pageSize: pageSize, inReplyTo: inReplyTo, deep: deep) { (response, error) in
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
 **tid** | **String** | The Thread ID | 
 **msgType** | **String** | Msg type, stringified array Example [\&quot;text\&quot;.\&quot;gif\&quot;] | [optional] 
 **currentMsgId** | **String** | THe message ID to paginate after or before | [optional] 
 **direction** | **String** | future/past | [optional] 
 **dateFrom** | **String** | ISO string of start date | [optional] 
 **dateTo** | **String** | ISO string of end date | [optional] 
 **pageSize** | **String** | page size for pagination | [optional] 
 **inReplyTo** | **String** | The ID of the message to list replies for | [optional] 
 **deep** | **Bool** | When true it returns messages from threads and main window both | [optional] 

### Return type

[**[Message]**](Message.md)

### Authorization

[ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **react**
```swift
    internal class func react(mid: String, emoji: String, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Chat Reaction API

Send message reaction

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let mid = "mid_example" // String | The message ID
let emoji = "emoji_example" // String | The emoji to react with

// Chat Reaction API
APIChatAPI.react(mid: mid, emoji: emoji) { (response, error) in
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
 **emoji** | **String** | The emoji to react with | 

### Return type

Void (empty response body)

### Authorization

[ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **sendMessage**
```swift
    internal class func sendMessage(deviceid: String, updateDraftRequest: UpdateDraftRequest, completion: @escaping (_ data: SendMessage200Response?, _ error: Error?) -> Void)
```

Send a chat message

Send a chat message

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let deviceid = "deviceid_example" // String | Source device ID
let updateDraftRequest = TODO // UpdateDraftRequest | 

// Send a chat message
APIChatAPI.sendMessage(deviceid: deviceid, updateDraftRequest: updateDraftRequest) { (response, error) in
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

[**SendMessage200Response**](SendMessage200Response.md)

### Authorization

[ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: multipart/form-data
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **unreact**
```swift
    internal class func unreact(mid: String, emoji: String, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```



Remove a message reaction

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let mid = "mid_example" // String | The message ID
let emoji = "emoji_example" // String | The emoji to react with

APIChatAPI.unreact(mid: mid, emoji: emoji) { (response, error) in
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
 **emoji** | **String** | The emoji to react with | 

### Return type

Void (empty response body)

### Authorization

[ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateMessage**
```swift
    internal class func updateMessage(mid: String, updateMessageInput: UpdateMessageInput, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Edit Message API

Edit particular message

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let mid = "mid_example" // String | The message ID
let updateMessageInput = UpdateMessageInput(message: "message_example", isStarred: true, follow: true) // UpdateMessageInput | edit chat body

// Edit Message API
APIChatAPI.updateMessage(mid: mid, updateMessageInput: updateMessageInput) { (response, error) in
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
 **updateMessageInput** | [**UpdateMessageInput**](UpdateMessageInput.md) | edit chat body | 

### Return type

Void (empty response body)

### Authorization

[ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

