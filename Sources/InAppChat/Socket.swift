//
//  File.swift
//
//
//  Created by Zaid Daghestani on 3/1/23.
//

import CocoaMQTT
import Foundation
import SwiftyJSON

class Socket {

  var client: CocoaMQTT?
  var host = "mqtt.inappchat.io"
  var port: UInt16 = 1883
  var apiKey: String? = nil

  struct Topics {
    static let chat = "chat"
    static let typing = "typingStatus"
    static let read = "msgReadStatus"
    static let availability = "availabilityStatus"
  }

  public func connect() {
    DispatchQueue.global(qos: .utility).async {
      self._connect()
    }
  }

  private func _connect() {
    if let client = client {
      if client.connect() {
        print("client connected!")
      } else {
        print("client failed to connect")
      }
      return
    }
    guard let authToken = api.authToken, let uid = User.current?.id else {
      print("No auth token, can't connect to MQTT")
      return
    }
    let clientId = "\(uid):\(api.deviceId):ios"
    let mqtt = CocoaMQTT(clientID: clientId, host: host, port: port)
    mqtt.username = InAppChat.shared.namespace
    let ts = Date().timeIntervalSince1970
    let signature = "\(apiKey ?? InAppChat.shared.apiKey)~\(Bundle.main.bundleIdentifier!)~\(ts)"
      .sha256
    mqtt.password = "\(signature):\(ts):\(authToken)"
    mqtt.willMessage = CocoaMQTTMessage(
      topic: "disconnect/clients", payload: Array(clientId.data(using: .utf8)!), qos: .qos2,
      retained: true)
    mqtt.enableSSL = true
    self.client = mqtt
    mqtt.didReceiveMessage = { mqtt, message, id in
      DispatchQueue.main.async {
        Socket.on(message: message)
      }
    }
    if mqtt.connect() {
      print("MQTT Connected")
      mqtt.subscribe([
        ("\(Topics.chat):\(clientId)", .qos2),
        ("\(Topics.typing):\(clientId)", .qos2),
        ("\(Topics.availability):\(clientId)", .qos2),
        ("\(Topics.read):\(clientId)", .qos2),
        ("groupUpdated:\(clientId)", .qos2),
        ("chatReaction:\(clientId)", .qos2),
        ("userSelfUpdated:\(clientId)", .qos2),
        ("tenantConfigUpdated:\(clientId)", .qos2),
        ("chatSettingUpdated:\(clientId)", .qos2),
        ("announcement:\(clientId)", .qos2),
        ("chatUpdate:\(clientId)", .qos2),
        ("userDbUpdated:\(clientId)", .qos2),
        ("chatReportUpdated:\(clientId)", .qos2),
      ])
    } else {
      print("MQTT connection failed")
    }
  }

  func disconnect() {
    client?.disconnect()
    client = nil
  }

  func sendTyping(to group: Group, typing: Bool) {
    self.publish(
      topic: Topics.typing,
      json: ["groupId": group.id, "eRTCUserId": User.current!.id, "typing": typing ? "on" : "off"])
  }

  func sendTyping(to user: User, typing: Bool) {
    self.publish(
      topic: Topics.typing,
      json: [
        "appUserId": user.email, "eRTCUserId": User.current!.id, "typing": typing ? "on" : "off",
      ])
  }

  func sendAvailability(status: AvailabilityStatus) {
    self.publish(
      topic: Topics.availability,
      json: ["eRTCUserId": User.current!.id, "availabilityStatus": status.rawValue])
  }

  func sendMsgRead(_ id: String, status: Message.Status) {
    self.publish(topic: Topics.read, json: ["msgUniqueId": id, "msgReadStatus": status.rawValue])
  }

  func publish(topic: String, json: [String: Any]) {
    let data = try! Array(JSON(json).rawData())
    self.client?.publish(
      CocoaMQTTMessage(topic: Topics.typing, payload: data, qos: .qos2, retained: false))
  }

  static func on(message: CocoaMQTTMessage) {
    guard
      let eventName = message.topic.split(separator: ":").first.map({
        Event.EventType(rawValue: String($0))
      })
    else {
      print("Unknown socket event topic \(message.topic)")
      return
    }
    switch eventName {
    case .availabilitystatus:
      let r = CodableHelper.decode(AvailabilityEvent.self, from: Data(message.payload))
      switch r {
      case let .success(event):
        on(event: event)
      case let .failure(err):
        Monitoring.error(err)
      }
    case .chat:
      let r = CodableHelper.decode(NewMessageEvent.self, from: Data(message.payload))
      switch r {
      case let .success(event):
        on(event: event)
      case let .failure(err):
        Monitoring.error(err)
      }
    case .chatreaction:
      let r = CodableHelper.decode(ReactionEvent.self, from: Data(message.payload))
      switch r {
      case let .success(event):
        on(event: event)
      case let .failure(err):
        Monitoring.error(err)
      }
    case .chatreportupdated:
      break
    case .groupupdated:
      let r = CodableHelper.decode(GroupUpdateEvent.self, from: Data(message.payload))
      switch r {
      case let .success(event):
        on(event: event)
      case let .failure(err):
        Monitoring.error(err)
      }
    case .msgreadstatus:
      let r = CodableHelper.decode(MsgReadEvent.self, from: Data(message.payload))
      switch r {
      case let .success(event):
        on(event: event)
      case let .failure(err):
        Monitoring.error(err)
      }
    case .typingstatus:
      let r = CodableHelper.decode(TypingEvent.self, from: Data(message.payload))
      switch r {
      case let .success(event):
        on(event: event)
      case let .failure(err):
        Monitoring.error(err)
      }
    case .updatemessage:
      let r = CodableHelper.decode(UpdateMessageEvent.self, from: Data(message.payload))
      switch r {
      case let .success(event):
        on(event: event)
      case let .failure(err):
        Monitoring.error(err)
      }
    case .userselfupdate:
      let r = CodableHelper.decode(UserSelfUpdateEvent.self, from: Data(message.payload))
      switch r {
      case let .success(event):
        on(event: event)
      case let .failure(err):
        Monitoring.error(err)
      }
    default:
      print("Unknown event name \(eventName?.rawValue ?? "") \(JSON(message.payload).rawString()!)")
    }
  }

  static func on(event: AvailabilityEvent) {
    User.get(event.eRTCUserId)?.status = event.availabilityStatus
  }

  static func on(event: NewMessageEvent) {
    let m = Message.get(event.message)
    if let thread = m.thread {
      if !thread.items.contains(m) {
        thread.items.insert(m, at: 0)
      }
    }
  }

  static func on(event: ReactionEvent) {
    if let message = Message.get(event.msgUniqueId) {
      if let reactions = message.reactions,
        let i = reactions.firstIndex(where: { event.emojiCode == $0.emojiCode })
      {
        var users = reactions[i].users
        if event.action == "set" {
          users.append(event.eRTCUserId)
          users = users.unique()
        } else {
          users = users.filter { $0 != event.eRTCUserId }
        }
        message.reactions![i] = Reaction(
          emojiCode: event.emojiCode, count: Int(event.totalCount), users: users)
      } else {
        message.reactions = message.reactions ?? []
        message.reactions?.append(
          Reaction(emojiCode: event.emojiCode, count: 1, users: [event.eRTCUserId]))
      }
    }
  }

  static func on(event: GroupUpdateEvent) {
    if let group = Group.get(event.groupId) {
      for ev in event.eventList {
        switch ev.eventType {
        case .admindismissed, .adminmade:
          if let users = ev.eventData.eventTriggeredOnUserList {
            for u in users {
              if let i = group.participants.firstIndex(where: { $0.eRTCUserId == u.eRTCUserId }) {
                let p = group.participants[i]
                group.participants[i] = Participant(
                  appUserId: p.appUserId, eRTCUserId: p.eRTCUserId,
                  role: ev.eventType == .adminmade ? .admin : .user, joinedAtDate: p.joinedAtDate)
              } else {
                group.participants.append(
                  Participant(
                    appUserId: u.appUserId, eRTCUserId: u.eRTCUserId,
                    role: ev.eventType == .adminmade ? .admin : .user, joinedAtDate: Date()))
              }
            }
          }
        case .participantsadded:
          if let users = ev.eventData.eventTriggeredOnUserList {
            for u in users {
              group.participants.append(
                Participant(
                  appUserId: u.appUserId, eRTCUserId: u.eRTCUserId, role: .user,
                  joinedAtDate: Date()))
            }
          }
        case .participantsremoved:
          if let users = ev.eventData.eventTriggeredOnUserList {
            for u in users {
              group.participants.removeAll(where: { $0.eRTCUserId == u.eRTCUserId })
            }
          }
        case .created:
          if let change = ev.eventData.changeData {
            let _ = Group(
              id: change.groupId!.new, name: change.name!.new, description: change.description?.new,
              image: change.profilePic?.new, _private: change.groupType?.new == ._private,
              invites: [])
          }
          break
        case .descriptionchanged:
          if let description = ev.eventData.changeData?.description {
            group.description = description.new
          }
        case .grouptypechanged:
          if let change = ev.eventData.changeData?.groupType {
            group._private = change.new == ._private
          }
        case .namechange:
          if let change = ev.eventData.changeData?.name {
            group.name = change.new
          }
        case .profilepicchanged:
          if let change = ev.eventData.changeData?.profilePic {
            group.image = change.new
          }
        case .profilepicremoved:
          group.image = nil
        }
      }
    }
  }

  static func on(event: MsgReadEvent) {
    if let m = Message.get(event.msgUniqueId) {
      m.status = Message.Status(rawValue: event.msgReadStatus.rawValue)
    }
  }

  static func on(event: TypingEvent) {
    if event.appUserId == User.current?.email,
      let thread = Thread.get(uid: event.eRTCUserId)
    {
      if event.typingStatusEvent == .on {
        thread.typingUsers = [event.eRTCUserId]
      } else {
        thread.typingUsers = []
      }
    } else if let gid = event.groupId, let thread = Thread.get(group: gid) {
      if event.typingStatusEvent == .on {
        var typing = thread.typingUsers
        typing.append(event.eRTCUserId)
        typing = typing.unique()
        thread.typingUsers = typing
      } else {
        thread.typingUsers.remove(element: event.eRTCUserId)
      }
    }
  }

  static func on(event: UserSelfUpdateEvent) {
    if event.eRTCUserId == User.current?.id {
      for ev in event.eventList {
        switch ev.eventType {
        case .availabilitystatuschanged:
          if let availability = ev.eventData.availabilityStatus {
            Chats.current.settings.setAvailability(availability, isSync: true)
          }
        case .notificationsettingchangedglobal:
          if let setting = ev.eventData.notificationSettings {
            Chats.current.settings.setNotification(setting.allowFrom, isSync: true)
          }
        case .notificationsettingschangedthread:
          if let setting = ev.eventData.notificationSettings,
            let thread = ev.eventData.threadId.flatMap({ Thread.get($0) })
          {
            thread.set(notifications: setting.allowFrom, isSync: true)
          }
        case .userblockedstatuschanged:
          if let uid = ev.eventData.targetUser?.eRTCUserId {
            let blocked = ev.eventData.blockedStatus == .blocked
            Chats.current.settings.setBlock(uid, blocked)
            if let user = User.get(uid) {
              user.blocked = blocked
            }
          }
        }
      }
    }
  }

  static func on(event: UpdateMessageEvent) {
    if let message = Message.get(event.msgUniqueId) {
      Chats.current.cache.messages.removeValue(forKey: event.msgUniqueId)
      message.thread?.items.remove(element: message)
      if let replies = RepliesPager.pagers[event.msgUniqueId] {
        replies.items.remove(element: message)
      }
    }
  }

  static let shared = Socket()
}
