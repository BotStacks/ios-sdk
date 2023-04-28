# ThreadObject

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**threadId** | **String** | Thread ID | [optional] 
**threadType** | **String** | Type of thread - single/group | [optional] 
**tenantId** | **String** | Tenant ID | [optional] 
**createdAt** | **Double** | Therad object creation time | [optional] 
**participants** | [ThreadMemberInHistorySchema] | array of read timestamps | [optional] 
**user** | [**UserInThreadHistorySchema**](UserInThreadHistorySchema.md) |  | [optional] 
**group** | [**GroupHighLevelDetails**](GroupHighLevelDetails.md) |  | [optional] 
**lastMessage** | [**LastMessageSchema**](LastMessageSchema.md) |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


