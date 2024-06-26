//
//  LocalNotificationAction.swift
//  Chemo-Buddy
//
//  Created by Rodney Aiglstorfer on 3/30/24.
//

import Foundation
import UserNotifications

public struct LocalNotificationActionEvent : Identifiable {
    public var id: String
    public var actionIdentifier: String
    public var content: UNNotificationContent
}
