# GetOrUpdateUserRequest

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**appUserId** | **String** | User ID i.e. abc@def.com. Required. version&#x3D;1:N | [optional] 
**deviceId** | **String** | Unique device id. For example, UDID for ios. version&#x3D;1:N | [optional] 
**deviceType** | **String** | Type of device i.e. android or ios. Allowed valies android/ios. version&#x3D;1:N | [optional] 
**fcmToken** | **String** | FCM regsitration token. Optional. version&#x3D;1:N | [optional] 
**fcmVersion** | **String** | FCM Version. Optional. default value is f1. version&#x3D;1:N | [optional] 
**publicKey** | **String** | public key for end to end encryption. version&#x3D;1:N | [optional] 
**muteSetting** | **String** | Mute setting parameter. supported values - none / all / allbutmentions. version&#x3D;1:N | [optional] 
**authPayload** | [**UserAuthPayload**](UserAuthPayload.md) |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


