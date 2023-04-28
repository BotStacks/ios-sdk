# UpdateUserRequest

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**deviceId** | **String** | Unique device id. For example, UDID for ios | [optional] 
**deviceType** | **String** | Type of device i.e. android or ios. Allowed valies android/ios | [optional] 
**fcmToken** | **String** | FCM regsitration token. Optional. | [optional] 
**fcmVersion** | **String** | FCM Version. Optional. default value is f1 | [optional] 
**availabilityStatus** | **String** | availability status to be over-riden on top of default behaviour. i.e. auto/away/invisible/dnd | [optional] 
**notificationSettings** | [**NotificationSettings**](NotificationSettings.md) |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


