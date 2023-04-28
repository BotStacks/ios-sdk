# UsersAPI

All URIs are relative to *https://chat.inappchat.io/v3*

Method | HTTP request | Description
------------- | ------------- | -------------
[**syncContacts**](UsersAPI.md#synccontacts) | **POST** /contacts | Sync Contacts


# **syncContacts**
```swift
    internal class func syncContacts(syncContactsInput: SyncContactsInput? = nil, completion: @escaping (_ data: SyncContacts200Response?, _ error: Error?) -> Void)
```

Sync Contacts

Sync contacts

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let syncContactsInput = SyncContactsInput(contacts: ["contacts_example"]) // SyncContactsInput |  (optional)

// Sync Contacts
UsersAPI.syncContacts(syncContactsInput: syncContactsInput) { (response, error) in
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
 **syncContactsInput** | [**SyncContactsInput**](SyncContactsInput.md) |  | [optional] 

### Return type

[**SyncContacts200Response**](SyncContacts200Response.md)

### Authorization

[ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

