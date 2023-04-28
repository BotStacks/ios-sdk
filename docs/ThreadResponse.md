# ThreadResponse

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**recipientAppUserId** | **String** | App user Id of receiver | [optional] 
**threadId** | **String** | Thread ID | [optional] 
**threadType** | **String** | Type of thread - single/group | [optional] 
**tenantId** | **String** | Tenant ID | [optional] 
**createdAt** | **Double** | Therad object creation time | [optional] 
**participants** | [ThreadMemberSchema] | array of read timestamps | [optional] 
**e2eEncryptionKeys** | [E2eKeyObj] | List of e2e public keys of user on different devices. ONLY APPLICABLE IF E2E EENCRYPTION IS ENABLED FOR TENANT | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


