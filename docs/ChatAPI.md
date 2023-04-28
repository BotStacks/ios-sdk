# ChatAPI

All URIs are relative to *https://chat.inappchat.io/v3*

Method | HTTP request | Description
------------- | ------------- | -------------
[**deleteChatHistory**](ChatAPI.md#deletechathistory) | **DELETE** /thread/{tid}/messages | Load chat history
[**deleteMessage**](ChatAPI.md#deletemessage) | **DELETE** /message/{mid} | Delete Message API
[**getFavorites**](ChatAPI.md#getfavorites) | **GET** /favorites | 
[**getMessage**](ChatAPI.md#getmessage) | **GET** /message/{mid} | 
[**getMessages**](ChatAPI.md#getmessages) | **GET** /thread/{tid}/messages | Load chat history
[**getReplies**](ChatAPI.md#getreplies) | **GET** /message/{mid}/replies | 
[**getReplyThreads**](ChatAPI.md#getreplythreads) | **GET** /reply-threads | List reply threads
[**react**](ChatAPI.md#react) | **PUT** /message/{mid}/reactions/{emoji} | Chat Reaction API
[**sendMessage**](ChatAPI.md#sendmessage) | **POST** /message | Send a chat message
[**unreact**](ChatAPI.md#unreact) | **DELETE** /message/{mid}/reactions/{emoji} | 
[**updateMessage**](ChatAPI.md#updatemessage) | **PUT** /message/{mid} | Edit Message API


# **deleteChatHistory**
```swift
    open class func deleteChatHistory(tid: String, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Load chat history

Clear chat history

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let tid = "tid_example" // String | The Thread ID

// Load chat history
ChatAPI.deleteChatHistory(tid: tid) { (response, error) in
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

[DeviceId](../README.md#DeviceId), [ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteMessage**
```swift
    open class func deleteMessage(mid: String, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Delete Message API

Delete particular message

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let mid = "mid_example" // String | The message ID

// Delete Message API
ChatAPI.deleteMessage(mid: mid) { (response, error) in
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

[DeviceId](../README.md#DeviceId), [ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getFavorites**
```swift
    open class func getFavorites(skip: Int? = nil, limit: Int? = nil, completion: @escaping (_ data: [APIMessage]?, _ error: Error?) -> Void)
```



Get users favorite messages

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let skip = 987 // Int | skip value for pagination. i.e. index. default 0 (optional) (default to 0)
let limit = 987 // Int | limit value for pagination. i.e. page-size. default 10 (optional) (default to 20)

ChatAPI.getFavorites(skip: skip, limit: limit) { (response, error) in
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
 **skip** | **Int** | skip value for pagination. i.e. index. default 0 | [optional] [default to 0]
 **limit** | **Int** | limit value for pagination. i.e. page-size. default 10 | [optional] [default to 20]

### Return type

[**[APIMessage]**](APIMessage.md)

### Authorization

[DeviceId](../README.md#DeviceId), [ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getMessage**
```swift
    open class func getMessage(mid: String, completion: @escaping (_ data: APIMessage?, _ error: Error?) -> Void)
```



Get a single message

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let mid = "mid_example" // String | The message ID

ChatAPI.getMessage(mid: mid) { (response, error) in
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

[**APIMessage**](APIMessage.md)

### Authorization

[DeviceId](../README.md#DeviceId), [ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getMessages**
```swift
    open class func getMessages(tid: String, msgType: String? = nil, currentMsgId: String? = nil, direction: Direction_getMessages? = nil, dateFrom: String? = nil, dateTo: String? = nil, pageSize: Int? = nil, inReplyTo: String? = nil, deep: Bool? = nil, completion: @escaping (_ data: [APIMessage]?, _ error: Error?) -> Void)
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
let direction = "direction_example" // String | future/past (optional) (default to .past)
let dateFrom = "dateFrom_example" // String | ISO string of start date (optional)
let dateTo = "dateTo_example" // String | ISO string of end date (optional)
let pageSize = 987 // Int | page size for pagination (optional)
let inReplyTo = "inReplyTo_example" // String | The ID of the message to list replies for (optional)
let deep = true // Bool | When true it returns messages from threads and main window both (optional)

// Load chat history
ChatAPI.getMessages(tid: tid, msgType: msgType, currentMsgId: currentMsgId, direction: direction, dateFrom: dateFrom, dateTo: dateTo, pageSize: pageSize, inReplyTo: inReplyTo, deep: deep) { (response, error) in
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
 **direction** | **String** | future/past | [optional] [default to .past]
 **dateFrom** | **String** | ISO string of start date | [optional] 
 **dateTo** | **String** | ISO string of end date | [optional] 
 **pageSize** | **Int** | page size for pagination | [optional] 
 **inReplyTo** | **String** | The ID of the message to list replies for | [optional] 
 **deep** | **Bool** | When true it returns messages from threads and main window both | [optional] 

### Return type

[**[APIMessage]**](APIMessage.md)

### Authorization

[DeviceId](../README.md#DeviceId), [ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getReplies**
```swift
    open class func getReplies(mid: String, skip: Int? = nil, limit: Int? = nil, completion: @escaping (_ data: [APIMessage]?, _ error: Error?) -> Void)
```



Get replies to a message

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let mid = "mid_example" // String | The message ID
let skip = 987 // Int | skip value for pagination. i.e. index. default 0 (optional) (default to 0)
let limit = 987 // Int | limit value for pagination. i.e. page-size. default 10 (optional) (default to 20)

ChatAPI.getReplies(mid: mid, skip: skip, limit: limit) { (response, error) in
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
 **skip** | **Int** | skip value for pagination. i.e. index. default 0 | [optional] [default to 0]
 **limit** | **Int** | limit value for pagination. i.e. page-size. default 10 | [optional] [default to 20]

### Return type

[**[APIMessage]**](APIMessage.md)

### Authorization

[DeviceId](../README.md#DeviceId), [ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getReplyThreads**
```swift
    open class func getReplyThreads(threadId: String? = nil, follow: Bool? = nil, starred: Bool? = nil, limit: Int? = nil, skip: Int? = nil, direction: Direction_getReplyThreads? = nil, deep: Bool? = nil, completion: @escaping (_ data: [APIMessage]?, _ error: Error?) -> Void)
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
let limit = 987 // Int | limit value for pagination. i.e. page-size. default 10 (optional) (default to 20)
let skip = 987 // Int | skip value for pagination. i.e. index. default 0 (optional) (default to 0)
let direction = "direction_example" // String | future/past (optional) (default to .past)
let deep = true // Bool | When true it returns messages from threads and main window both (optional) (default to true)

// List reply threads
ChatAPI.getReplyThreads(threadId: threadId, follow: follow, starred: starred, limit: limit, skip: skip, direction: direction, deep: deep) { (response, error) in
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
 **limit** | **Int** | limit value for pagination. i.e. page-size. default 10 | [optional] [default to 20]
 **skip** | **Int** | skip value for pagination. i.e. index. default 0 | [optional] [default to 0]
 **direction** | **String** | future/past | [optional] [default to .past]
 **deep** | **Bool** | When true it returns messages from threads and main window both | [optional] [default to true]

### Return type

[**[APIMessage]**](APIMessage.md)

### Authorization

[DeviceId](../README.md#DeviceId), [ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **react**
```swift
    open class func react(mid: String, emoji: String, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
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
ChatAPI.react(mid: mid, emoji: emoji) { (response, error) in
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

[DeviceId](../README.md#DeviceId), [ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **sendMessage**
```swift
    open class func sendMessage(senderTimeStampMs: Double, threadId: String? = nil, recipientAppUserId: String? = nil, message: String? = nil, msgType: MessageType? = nil, file: URL? = nil, replyThreadFeatureData: Reply? = nil, location: Location? = nil, contact: Contact? = nil, gif: String? = nil, mentions: [Mention]? = nil, forwardChatFeatureData: Forward? = nil, media: Media? = nil, msgCorrelationId: String? = nil, encryptedChatList: [EncryptedMessage]? = nil, completion: @escaping (_ data: MessageResponse?, _ error: Error?) -> Void)
```

Send a chat message

Send a chat message

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let senderTimeStampMs = 987 // Double | epoch timestamp (in ms) of message creation generated on sender device
let threadId = "threadId_example" // String | Thread ID which represents a user or a group. eg. 5c56c9a2218aec4b4a8a976f. This is mutually exclusive with recipientAppUserId. (optional)
let recipientAppUserId = "recipientAppUserId_example" // String | App user Id of receiver. eg. abc@def.com. This is mutually exclusive with threadId. (optional)
let message = "message_example" // String | message text. rg. 'hello' (optional)
let msgType = MessageType() // MessageType |  (optional)
let file = URL(string: "https://example.com")! // URL | File share (optional)
let replyThreadFeatureData = Reply(baseMsgUniqueId: "baseMsgUniqueId_example", replyMsgConfig: 123) // Reply |  (optional)
let location = Location(longitude: 123, latitude: 123, address: "address_example") // Location |  (optional)
let contact = Contact(name: "name_example", numbers: [PhoneNumber(type: "type_example", number: "number_example")], emails: [Email(type: "type_example", email: "email_example")]) // Contact |  (optional)
let gif = "gif_example" // String | gify url (optional)
let mentions = [Mention(type: "type_example", value: "value_example")] // [Mention] |  (optional)
let forwardChatFeatureData = Forward(originalMsgUniqueId: "originalMsgUniqueId_example", isForwarded: true) // Forward |  (optional)
let media = Media(path: "path_example", thumbnail: "thumbnail_example", name: "name_example") // Media |  (optional)
let msgCorrelationId = "msgCorrelationId_example" // String | Client generated unique identifier used to trace message delivery till receiver (optional)
let encryptedChatList = [EncryptedMessage(keyId: "keyId_example", deviceId: "deviceId_example", publicKey: "publicKey_example", eRTCUserId: "eRTCUserId_example", message: "message_example", contact: "contact_example", location: "location_example", gify: "gify_example", path: "path_example", thumbnail: "thumbnail_example")] // [EncryptedMessage] | List of user+device wise eencrypted chat objects. (optional)

// Send a chat message
ChatAPI.sendMessage(senderTimeStampMs: senderTimeStampMs, threadId: threadId, recipientAppUserId: recipientAppUserId, message: message, msgType: msgType, file: file, replyThreadFeatureData: replyThreadFeatureData, location: location, contact: contact, gif: gif, mentions: mentions, forwardChatFeatureData: forwardChatFeatureData, media: media, msgCorrelationId: msgCorrelationId, encryptedChatList: encryptedChatList) { (response, error) in
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
 **senderTimeStampMs** | **Double** | epoch timestamp (in ms) of message creation generated on sender device | 
 **threadId** | **String** | Thread ID which represents a user or a group. eg. 5c56c9a2218aec4b4a8a976f. This is mutually exclusive with recipientAppUserId. | [optional] 
 **recipientAppUserId** | **String** | App user Id of receiver. eg. abc@def.com. This is mutually exclusive with threadId. | [optional] 
 **message** | **String** | message text. rg. &#39;hello&#39; | [optional] 
 **msgType** | [**MessageType**](MessageType.md) |  | [optional] 
 **file** | **URL** | File share | [optional] 
 **replyThreadFeatureData** | [**Reply**](Reply.md) |  | [optional] 
 **location** | [**Location**](Location.md) |  | [optional] 
 **contact** | [**Contact**](Contact.md) |  | [optional] 
 **gif** | **String** | gify url | [optional] 
 **mentions** | [**[Mention]**](Mention.md) |  | [optional] 
 **forwardChatFeatureData** | [**Forward**](Forward.md) |  | [optional] 
 **media** | [**Media**](Media.md) |  | [optional] 
 **msgCorrelationId** | **String** | Client generated unique identifier used to trace message delivery till receiver | [optional] 
 **encryptedChatList** | [**[EncryptedMessage]**](EncryptedMessage.md) | List of user+device wise eencrypted chat objects. | [optional] 

### Return type

[**MessageResponse**](MessageResponse.md)

### Authorization

[DeviceId](../README.md#DeviceId), [ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: multipart/form-data
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **unreact**
```swift
    open class func unreact(mid: String, emoji: String, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```



Remove a message reaction

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let mid = "mid_example" // String | The message ID
let emoji = "emoji_example" // String | The emoji to react with

ChatAPI.unreact(mid: mid, emoji: emoji) { (response, error) in
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

[DeviceId](../README.md#DeviceId), [ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateMessage**
```swift
    open class func updateMessage(mid: String, updateMessageInput: UpdateMessageInput, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Edit Message API

Edit particular message

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let mid = "mid_example" // String | The message ID
let updateMessageInput = UpdateMessageInput(message: "message_example", isStarred: true, follow: true, status: MessageStatus()) // UpdateMessageInput | edit chat body

// Edit Message API
ChatAPI.updateMessage(mid: mid, updateMessageInput: updateMessageInput) { (response, error) in
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

[DeviceId](../README.md#DeviceId), [ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

