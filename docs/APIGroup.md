# APIGroup

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**groupId** | **String** | Group ID | 
**name** | **String** | Group Name | 
**groupType** | **String** | Type of group. for example privte/public. only private is supported as of now. | 
**description** | **String** | Description of group | [optional] 
**profilePic** | **String** | Profile pic url. use chatServer URL as prefix to generate complete URL | [optional] 
**profilePicThumb** | **String** | Profile pic thumbnail url. use chatServer URL as prefix to generate complete URL | [optional] 
**createdAt** | **Double** | Group creation epoch timeStamp | 
**creatorId** | **String** | appUserId of creator | [optional] 
**threadId** | **String** | ThreadId associated with group. To be used for chat | [optional] 
**participants** | [Participant] | List of participants | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


