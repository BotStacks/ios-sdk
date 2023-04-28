# APIGroupAPI

All URIs are relative to *https://chat.inappchat.io/v3*

Method | HTTP request | Description
------------- | ------------- | -------------
[**acceptGroupInvite**](APIGroupAPI.md#acceptgroupinvite) | **POST** /group/{gid}/invites/accept | accept group invitation
[**addParticipant**](APIGroupAPI.md#addparticipant) | **PUT** /group/{gid}/participants/{uid} | Add participant to group
[**createGroup**](APIGroupAPI.md#creategroup) | **POST** /groups | Create or Update group
[**dismissGroupInvite**](APIGroupAPI.md#dismissgroupinvite) | **POST** /group/{gid}/invites/dismiss | dismiss group invitation
[**getGroup**](APIGroupAPI.md#getgroup) | **GET** /group/{gid} | Get group by groupId
[**getInvites**](APIGroupAPI.md#getinvites) | **GET** /group/invites | get group invitation
[**groupAddAdmin**](APIGroupAPI.md#groupaddadmin) | **PUT** /group/{gid}/admin/{uid} | Make a user an admin
[**groupDismissAdmin**](APIGroupAPI.md#groupdismissadmin) | **DELETE** /group/{gid}/admin/{uid} | Dismiss a group admin
[**inviteUser**](APIGroupAPI.md#inviteuser) | **POST** /group/{gid}/invite | create group invitation
[**listGroups**](APIGroupAPI.md#listgroups) | **GET** /groups | Get user groups
[**moderateGroup**](APIGroupAPI.md#moderategroup) | **POST** /group/{gid}/moderate | 
[**removeGroupImage**](APIGroupAPI.md#removegroupimage) | **DELETE** /group/{gid}/image | Remove group profile pic
[**removeParticipant**](APIGroupAPI.md#removeparticipant) | **DELETE** /group/{gid}/participants/{uid} | Remove participant from group


# **acceptGroupInvite**
```swift
    internal class func acceptGroupInvite(gid: String, completion: @escaping (_ data: Thread?, _ error: Error?) -> Void)
```

accept group invitation

Accept group invitation

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let gid = "gid_example" // String | Group ID

// accept group invitation
APIGroupAPI.acceptGroupInvite(gid: gid) { (response, error) in
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
 **gid** | **String** | Group ID | 

### Return type

[**Thread**](Thread.md)

### Authorization

[ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **addParticipant**
```swift
    internal class func addParticipant(gid: String, uid: String, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Add participant to group

Add participant to group

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let gid = "gid_example" // String | Group ID
let uid = "uid_example" // String | the user's id

// Add participant to group
APIGroupAPI.addParticipant(gid: gid, uid: uid) { (response, error) in
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
 **gid** | **String** | Group ID | 
 **uid** | **String** | the user&#39;s id | 

### Return type

Void (empty response body)

### Authorization

[ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createGroup**
```swift
    internal class func createGroup(uid: String, name: String, participants: [String], groupType: GroupType_createGroup? = nil, description: String? = nil, profilePic: URL? = nil, completion: @escaping (_ data: Group?, _ error: Error?) -> Void)
```

Create or Update group

Create a group. For profilePic use multipart/formdata and in this case stringify participants list.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let uid = "uid_example" // String | the user's id
let name = "name_example" // String | Group Name
let participants = ["inner_example"] // [String] | List of participants
let groupType = "groupType_example" // String | Type of group. for example privte/public. only private is supported as of now. (optional)
let description = "description_example" // String | Description of group. Optional. Min length 2. (optional)
let profilePic = URL(string: "https://example.com")! // URL | The image for the group (optional)

// Create or Update group
APIGroupAPI.createGroup(uid: uid, name: name, participants: participants, groupType: groupType, description: description, profilePic: profilePic) { (response, error) in
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
 **uid** | **String** | the user&#39;s id | 
 **name** | **String** | Group Name | 
 **participants** | [**[String]**](String.md) | List of participants | 
 **groupType** | **String** | Type of group. for example privte/public. only private is supported as of now. | [optional] 
 **description** | **String** | Description of group. Optional. Min length 2. | [optional] 
 **profilePic** | **URL** | The image for the group | [optional] 

### Return type

[**Group**](Group.md)

### Authorization

[ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: multipart/form-data
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **dismissGroupInvite**
```swift
    internal class func dismissGroupInvite(gid: String, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

dismiss group invitation

Dissmiss group invitation

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let gid = "gid_example" // String | Group ID

// dismiss group invitation
APIGroupAPI.dismissGroupInvite(gid: gid) { (response, error) in
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
 **gid** | **String** | Group ID | 

### Return type

Void (empty response body)

### Authorization

[ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getGroup**
```swift
    internal class func getGroup(gid: String, completion: @escaping (_ data: Group?, _ error: Error?) -> Void)
```

Get group by groupId

Get group by groupId

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let gid = "gid_example" // String | Group ID

// Get group by groupId
APIGroupAPI.getGroup(gid: gid) { (response, error) in
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
 **gid** | **String** | Group ID | 

### Return type

[**Group**](Group.md)

### Authorization

[ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getInvites**
```swift
    internal class func getInvites(completion: @escaping (_ data: [Invite]?, _ error: Error?) -> Void)
```

get group invitation

Get group invitations for user

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat


// get group invitation
APIGroupAPI.getInvites() { (response, error) in
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
This endpoint does not need any parameter.

### Return type

[**[Invite]**](Invite.md)

### Authorization

[ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **groupAddAdmin**
```swift
    internal class func groupAddAdmin(uid: String, gid: String, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Make a user an admin

Make a user an admin

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let uid = "uid_example" // String | the user's id
let gid = "gid_example" // String | Group ID

// Make a user an admin
APIGroupAPI.groupAddAdmin(uid: uid, gid: gid) { (response, error) in
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
 **uid** | **String** | the user&#39;s id | 
 **gid** | **String** | Group ID | 

### Return type

Void (empty response body)

### Authorization

[ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **groupDismissAdmin**
```swift
    internal class func groupDismissAdmin(uid: String, gid: String, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Dismiss a group admin

Dismiss a group admin

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let uid = "uid_example" // String | the user's id
let gid = "gid_example" // String | Group ID

// Dismiss a group admin
APIGroupAPI.groupDismissAdmin(uid: uid, gid: gid) { (response, error) in
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
 **uid** | **String** | the user&#39;s id | 
 **gid** | **String** | Group ID | 

### Return type

Void (empty response body)

### Authorization

[ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **inviteUser**
```swift
    internal class func inviteUser(gid: String, requestBody: [String], completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

create group invitation

Invite new participant to group

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let gid = "gid_example" // String | Group ID
let requestBody = ["property_example"] // [String] | array of user ids to invite

// create group invitation
APIGroupAPI.inviteUser(gid: gid, requestBody: requestBody) { (response, error) in
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
 **gid** | **String** | Group ID | 
 **requestBody** | [**[String]**](String.md) | array of user ids to invite | 

### Return type

Void (empty response body)

### Authorization

[ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listGroups**
```swift
    internal class func listGroups(uid: String, limit: String? = nil, skip: String? = nil, groupType: GroupType_listGroups? = nil, joined: Joined_listGroups? = nil, completion: @escaping (_ data: [Group]?, _ error: Error?) -> Void)
```

Get user groups

Get groups where user is participant or group is public

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let uid = "uid_example" // String | the user's id
let limit = "limit_example" // String | limit value for pagination. i.e. page-size. default 10 (optional)
let skip = "skip_example" // String | skip value for pagination. i.e. index. default 0 (optional)
let groupType = "groupType_example" // String | Filter by group type (optional)
let joined = "joined_example" // String | Get only joined/not joined groups (optional)

// Get user groups
APIGroupAPI.listGroups(uid: uid, limit: limit, skip: skip, groupType: groupType, joined: joined) { (response, error) in
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
 **uid** | **String** | the user&#39;s id | 
 **limit** | **String** | limit value for pagination. i.e. page-size. default 10 | [optional] 
 **skip** | **String** | skip value for pagination. i.e. index. default 0 | [optional] 
 **groupType** | **String** | Filter by group type | [optional] 
 **joined** | **String** | Get only joined/not joined groups | [optional] 

### Return type

[**[Group]**](Group.md)

### Authorization

[ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **moderateGroup**
```swift
    internal class func moderateGroup(gid: String, moderateGroupInput: ModerateGroupInput, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```



Moderate a group. Ban or mute users

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let gid = "gid_example" // String | Group ID
let moderateGroupInput = ModerateGroupInput(participants: ["participants_example"], type: "type_example", till: "till_example") // ModerateGroupInput | Unique AppID of the user to get

APIGroupAPI.moderateGroup(gid: gid, moderateGroupInput: moderateGroupInput) { (response, error) in
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
 **gid** | **String** | Group ID | 
 **moderateGroupInput** | [**ModerateGroupInput**](ModerateGroupInput.md) | Unique AppID of the user to get | 

### Return type

Void (empty response body)

### Authorization

[ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **removeGroupImage**
```swift
    internal class func removeGroupImage(gid: String, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Remove group profile pic

Remove group profile pic

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let gid = "gid_example" // String | Group ID

// Remove group profile pic
APIGroupAPI.removeGroupImage(gid: gid) { (response, error) in
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
 **gid** | **String** | Group ID | 

### Return type

Void (empty response body)

### Authorization

[ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **removeParticipant**
```swift
    internal class func removeParticipant(gid: String, uid: String, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Remove participant from group

Remove participant from group

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let gid = "gid_example" // String | Group ID
let uid = "uid_example" // String | the user's id

// Remove participant from group
APIGroupAPI.removeParticipant(gid: gid, uid: uid) { (response, error) in
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
 **gid** | **String** | Group ID | 
 **uid** | **String** | the user&#39;s id | 

### Return type

Void (empty response body)

### Authorization

[ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

