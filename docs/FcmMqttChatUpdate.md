# FcmMqttChatUpdate

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**eRTCUserId** | **String** | User unique Identifier | [optional] 
**chats** | [ChatObjIndeleteChatResponse] | List of deleted chats | [optional] 
**msgUniqueId** | **String** | Chat unique Identifier | [optional] 
**updateType** | **String** | Type of update. eg. delete/edit | [optional] 
**threadId** | **String** | Thread unique identifier | [optional] 
**tenantId** | **String** | Tenant unique identifier | [optional] 
**msgCorrelationId** | **String** | Client generated unique identifier used to trace message delivery till receiver. | [optional] 
**deleteType** | **String** | in case of delete updateType, it specifies sub-type of delete such as self/everyone | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


