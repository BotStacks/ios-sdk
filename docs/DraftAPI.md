# DraftAPI

All URIs are relative to *https://chat.inappchat.io/v3*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getDrafts**](DraftAPI.md#getdrafts) | **GET** /draft | Draft API
[**updateDraft**](DraftAPI.md#updatedraft) | **POST** /draft | Draft API


# **getDrafts**
```swift
    open class func getDrafts(threadId: String? = nil, baseMsgUniqueId: String? = nil, completion: @escaping (_ data: APIMessage?, _ error: Error?) -> Void)
```

Draft API

Send chat over a thread

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let threadId = "threadId_example" // String | Get draft for a particular thread (optional)
let baseMsgUniqueId = "baseMsgUniqueId_example" // String | Get thread for a reply thread, this is base message id (optional)

// Draft API
DraftAPI.getDrafts(threadId: threadId, baseMsgUniqueId: baseMsgUniqueId) { (response, error) in
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
 **threadId** | **String** | Get draft for a particular thread | [optional] 
 **baseMsgUniqueId** | **String** | Get thread for a reply thread, this is base message id | [optional] 

### Return type

[**APIMessage**](APIMessage.md)

### Authorization

[DeviceId](../README.md#DeviceId), [ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateDraft**
```swift
    open class func updateDraft(senderTimeStampMs: Double, threadId: String? = nil, recipientAppUserId: String? = nil, message: String? = nil, msgType: MessageType? = nil, file: URL? = nil, replyThreadFeatureData: Reply? = nil, location: Location? = nil, contact: Contact? = nil, gif: String? = nil, mentions: [Mention]? = nil, forwardChatFeatureData: Forward? = nil, media: Media? = nil, msgCorrelationId: String? = nil, encryptedChatList: [EncryptedMessage]? = nil, completion: @escaping (_ data: APIMessage?, _ error: Error?) -> Void)
```

Draft API

Send chat over a thread

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

// Draft API
DraftAPI.updateDraft(senderTimeStampMs: senderTimeStampMs, threadId: threadId, recipientAppUserId: recipientAppUserId, message: message, msgType: msgType, file: file, replyThreadFeatureData: replyThreadFeatureData, location: location, contact: contact, gif: gif, mentions: mentions, forwardChatFeatureData: forwardChatFeatureData, media: media, msgCorrelationId: msgCorrelationId, encryptedChatList: encryptedChatList) { (response, error) in
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

[**APIMessage**](APIMessage.md)

### Authorization

[DeviceId](../README.md#DeviceId), [ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: multipart/form-data
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

