# ChatStatusSchema

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**returnCode** | **String** | return code for e2e encrypted chat request. It can be senderKeyValidityExpired (new key to be provided in keyList, also new device key if there) / receiverKeyValidationError / senderNewDeviceKeyAvailable (new device key to be provided in keyList, also same device key if validity expired) / success | [optional] 
**retryRequired** | **Bool** | Boolean parameter which indicates if same chat needs to be re-sent after resolving issues based on returnCode | [optional] 
**keyList** | [E2eKeyObjWithReturnCodee] | list of key details based on returnCode. Details of this list depends on returnCode. | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


