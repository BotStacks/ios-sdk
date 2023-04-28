# GroupAPI

All URIs are relative to *https://chat.inappchat.io/v3*

Method | HTTP request | Description
------------- | ------------- | -------------
[**acceptGroupInvite**](GroupAPI.md#acceptgroupinvite) | **POST** /group/{gid}/invites/accept | accept group invitation
[**addParticipant**](GroupAPI.md#addparticipant) | **PUT** /group/{gid}/participants/{uid} | Add participant to group
[**createGroup**](GroupAPI.md#creategroup) | **POST** /groups | Create or Update group
[**deleteGroup**](GroupAPI.md#deletegroup) | **DELETE** /group/{gid} | 
[**dismissGroupInvite**](GroupAPI.md#dismissgroupinvite) | **POST** /group/{gid}/invites/dismiss | dismiss group invitation
[**getGroup**](GroupAPI.md#getgroup) | **GET** /group/{gid} | Get group by groupId
[**getGroups**](GroupAPI.md#getgroups) | **GET** /groups | Get user groups
[**getInvites**](GroupAPI.md#getinvites) | **GET** /group/invites | get group invitation
[**groupAddAdmin**](GroupAPI.md#groupaddadmin) | **PUT** /group/{gid}/admin/{uid} | Make a user an admin
[**groupDismissAdmin**](GroupAPI.md#groupdismissadmin) | **DELETE** /group/{gid}/admin/{uid} | Dismiss a group admin
[**inviteUser**](GroupAPI.md#inviteuser) | **POST** /group/{gid}/invite | create group invitation
[**moderateGroup**](GroupAPI.md#moderategroup) | **POST** /group/{gid}/moderate | 
[**removeGroupImage**](GroupAPI.md#removegroupimage) | **DELETE** /group/{gid}/image | Remove group profile pic
[**removeParticipant**](GroupAPI.md#removeparticipant) | **DELETE** /group/{gid}/participants/{uid} | Remove participant from group
[**updateGroup**](GroupAPI.md#updategroup) | **PUT** /group/{gid} | 


# **acceptGroupInvite**
```swift
    open class func acceptGroupInvite(gid: String, completion: @escaping (_ data: APIThread?, _ error: Error?) -> Void)
```

accept group invitation

Accept group invitation

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let gid = "gid_example" // String | Group ID

// accept group invitation
GroupAPI.acceptGroupInvite(gid: gid) { (response, error) in
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

[**APIThread**](APIThread.md)

### Authorization

[DeviceId](../README.md#DeviceId), [ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **addParticipant**
```swift
    open class func addParticipant(gid: String, uid: String, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
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
GroupAPI.addParticipant(gid: gid, uid: uid) { (response, error) in
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

[DeviceId](../README.md#DeviceId), [ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createGroup**
```swift
    open class func createGroup(name: String, participants: [String], groupType: GroupType_createGroup? = nil, description: String? = nil, profilePic: URL? = nil, completion: @escaping (_ data: APIGroup?, _ error: Error?) -> Void)
```

Create or Update group

Create a group. For profilePic use multipart/formdata and in this case stringify participants list.

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let name = "name_example" // String | Group Name
let participants = ["inner_example"] // [String] | List of participants
let groupType = "groupType_example" // String | Type of group. for example privte/public. only private is supported as of now. (optional)
let description = "description_example" // String | Description of group. Optional. Min length 2. (optional)
let profilePic = URL(string: "https://example.com")! // URL | The image for the group (optional)

// Create or Update group
GroupAPI.createGroup(name: name, participants: participants, groupType: groupType, description: description, profilePic: profilePic) { (response, error) in
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
 **name** | **String** | Group Name | 
 **participants** | [**[String]**](String.md) | List of participants | 
 **groupType** | **String** | Type of group. for example privte/public. only private is supported as of now. | [optional] 
 **description** | **String** | Description of group. Optional. Min length 2. | [optional] 
 **profilePic** | **URL** | The image for the group | [optional] 

### Return type

[**APIGroup**](APIGroup.md)

### Authorization

[DeviceId](../README.md#DeviceId), [ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: multipart/form-data
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteGroup**
```swift
    open class func deleteGroup(gid: String, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```



Delete a group

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let gid = "gid_example" // String | Group ID

GroupAPI.deleteGroup(gid: gid) { (response, error) in
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

[DeviceId](../README.md#DeviceId), [ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **dismissGroupInvite**
```swift
    open class func dismissGroupInvite(gid: String, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

dismiss group invitation

Dissmiss group invitation

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let gid = "gid_example" // String | Group ID

// dismiss group invitation
GroupAPI.dismissGroupInvite(gid: gid) { (response, error) in
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

[DeviceId](../README.md#DeviceId), [ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getGroup**
```swift
    open class func getGroup(gid: String, completion: @escaping (_ data: APIGroup?, _ error: Error?) -> Void)
```

Get group by groupId

Get group by groupId

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let gid = "gid_example" // String | Group ID

// Get group by groupId
GroupAPI.getGroup(gid: gid) { (response, error) in
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

[**APIGroup**](APIGroup.md)

### Authorization

[DeviceId](../README.md#DeviceId), [ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getGroups**
```swift
    open class func getGroups(limit: Int? = nil, skip: Int? = nil, groupType: GroupType_getGroups? = nil, joined: Joined_getGroups? = nil, completion: @escaping (_ data: [APIGroup]?, _ error: Error?) -> Void)
```

Get user groups

Get groups where user is participant or group is public

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let limit = 987 // Int | limit value for pagination. i.e. page-size. default 10 (optional) (default to 20)
let skip = 987 // Int | skip value for pagination. i.e. index. default 0 (optional) (default to 0)
let groupType = "groupType_example" // String | Filter by group type (optional)
let joined = "joined_example" // String | Get only joined/not joined groups (optional)

// Get user groups
GroupAPI.getGroups(limit: limit, skip: skip, groupType: groupType, joined: joined) { (response, error) in
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
 **limit** | **Int** | limit value for pagination. i.e. page-size. default 10 | [optional] [default to 20]
 **skip** | **Int** | skip value for pagination. i.e. index. default 0 | [optional] [default to 0]
 **groupType** | **String** | Filter by group type | [optional] 
 **joined** | **String** | Get only joined/not joined groups | [optional] 

### Return type

[**[APIGroup]**](APIGroup.md)

### Authorization

[DeviceId](../README.md#DeviceId), [ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getInvites**
```swift
    open class func getInvites(completion: @escaping (_ data: [Invite]?, _ error: Error?) -> Void)
```

get group invitation

Get group invitations for user

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat


// get group invitation
GroupAPI.getInvites() { (response, error) in
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

[DeviceId](../README.md#DeviceId), [ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **groupAddAdmin**
```swift
    open class func groupAddAdmin(uid: String, gid: String, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
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
GroupAPI.groupAddAdmin(uid: uid, gid: gid) { (response, error) in
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

[DeviceId](../README.md#DeviceId), [ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **groupDismissAdmin**
```swift
    open class func groupDismissAdmin(uid: String, gid: String, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
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
GroupAPI.groupDismissAdmin(uid: uid, gid: gid) { (response, error) in
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

[DeviceId](../README.md#DeviceId), [ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **inviteUser**
```swift
    open class func inviteUser(gid: String, requestBody: [String], completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
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
GroupAPI.inviteUser(gid: gid, requestBody: requestBody) { (response, error) in
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

[DeviceId](../README.md#DeviceId), [ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **moderateGroup**
```swift
    open class func moderateGroup(gid: String, moderateGroupInput: ModerateGroupInput, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```



Moderate a group. Ban or mute users

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let gid = "gid_example" // String | Group ID
let moderateGroupInput = ModerateGroupInput(participants: ["participants_example"], type: "type_example", till: "till_example") // ModerateGroupInput | Unique AppID of the user to get

GroupAPI.moderateGroup(gid: gid, moderateGroupInput: moderateGroupInput) { (response, error) in
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

[DeviceId](../README.md#DeviceId), [ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **removeGroupImage**
```swift
    open class func removeGroupImage(gid: String, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
```

Remove group profile pic

Remove group profile pic

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let gid = "gid_example" // String | Group ID

// Remove group profile pic
GroupAPI.removeGroupImage(gid: gid) { (response, error) in
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

[DeviceId](../README.md#DeviceId), [ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **removeParticipant**
```swift
    open class func removeParticipant(gid: String, uid: String, completion: @escaping (_ data: Void?, _ error: Error?) -> Void)
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
GroupAPI.removeParticipant(gid: gid, uid: uid) { (response, error) in
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

[DeviceId](../README.md#DeviceId), [ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateGroup**
```swift
    open class func updateGroup(gid: String, updateGroupInput: UpdateGroupInput, completion: @escaping (_ data: APIGroup?, _ error: Error?) -> Void)
```



Update a group

### Example
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import InAppChat

let gid = "gid_example" // String | Group ID
let updateGroupInput = UpdateGroupInput(name: "name_example", groupType: "groupType_example", description: "description_example", profilePic: URL(string: "https://example.com")!) // UpdateGroupInput | 

GroupAPI.updateGroup(gid: gid, updateGroupInput: updateGroupInput) { (response, error) in
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
 **updateGroupInput** | [**UpdateGroupInput**](UpdateGroupInput.md) |  | 

### Return type

[**APIGroup**](APIGroup.md)

### Authorization

[DeviceId](../README.md#DeviceId), [ApiKeyAuth](../README.md#ApiKeyAuth), [BearerAuth](../README.md#BearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

