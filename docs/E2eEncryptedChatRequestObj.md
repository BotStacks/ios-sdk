# E2eEncryptedChatRequestObj

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**threadId** | **String** | Thread Id. This is exclusive peer to recipientAppUserId. | [optional] 
**recipientAppUserId** | **String** | App user Id of receiver. This is exclusive peer to threadId. | [optional] 
**sendereRTCUserId** | **String** | eRTC user id of source user | [optional] 
**msgType** | **String** | message type. it can be text/image/audio/video/gif/file | [optional] 
**metadata** | [**AnyCodable**](.md) | JSON object which can be used for client reference in request/response context. Server will not do any processing on this object. eg. { \&quot;abc\&quot; : \&quot;def\&quot; } | [optional] 
**encryptedChatList** | [EncryptedChatObj] | List of user+device wise eencrypted chat objects. | [optional] 
**senderKeyDetails** | [**E2eEncryptedChatRequestObjSenderKeyDetails**](E2eEncryptedChatRequestObjSenderKeyDetails.md) |  | [optional] 
**replyThreadFeatureData** | [**ReplyThreadSchemaChatRequest**](ReplyThreadSchemaChatRequest.md) |  | [optional] 
**forwardChatFeatureData** | [**ForwardChatSchemaChatRequest**](ForwardChatSchemaChatRequest.md) |  | [optional] 
**media** | [**MediaSchema**](MediaSchema.md) |  | [optional] 
**mentions** | [MentionSchema] |  | [optional] 
**msgCorrelationId** | **String** | Client generated unique identifier used to trace message delivery till receiver. | [optional] 
**senderTimeStampMs** | **Double** | epoch timestamp (in ms) of message creation generated on sender device | [optional] 
**customData** | [**AnyCodable**](.md) | JSON object which can be used for customer specific data which is not supported in InAppChat chat model. eg. { \&quot;abc\&quot; : \&quot;def\&quot; } | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


