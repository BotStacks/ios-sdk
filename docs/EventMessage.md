# EventMessage

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**eRTCUserId** | **String** | The user ID | 
**eventList** | [GroupUpdateEventItem] |  | 
**eventTriggeredByUser** | [**APIUser**](APIUser.md) |  | 
**groupId** | **String** | The group receiving the typing status | 
**threadId** | **String** | Thread ID of associated group | 
**chatReportId** | **String** |  | [optional] 
**event** | [**ChatReportEventEvent**](ChatReportEventEvent.md) |  | [optional] 
**msgUniqueId** | **String** | The ID of the message | 
**emojiCode** | **String** | Emoje code string | 
**action** | **String** | Reaction actionType. It can be set/clear | 
**totalCount** | **Double** | Total count of particular reaction with emojiCode | 
**updateType** | **String** | Type of update.  | 
**deleteType** | **String** | in case of delete updateType, it specifies sub-type of delete such as self/everyone | 
**appUserId** | **String** | The user receiving the typing status | [optional] 
**typingStatusEvent** | **String** | Whether or not the user is typing | 
**msgReadStatus** | **String** | The status of the message | 
**availabilityStatus** | [**AvailabilityStatus**](AvailabilityStatus.md) |  | 
**message** | [**APIMessage**](APIMessage.md) |  | 
**tenantId** | **String** |  | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


