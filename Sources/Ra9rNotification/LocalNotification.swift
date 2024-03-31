//
//  LocatNotification.swift
//  Chemo-Buddy
//
//  Created by Rodney Aiglstorfer on 3/28/24.
//

import Foundation

public struct LocalNotification {
    typealias LocalNotificationCompletion = (LocalNotification) -> Void
    
    /// Unique id for the notification
    public var identifier: String = UUID().uuidString
    /// The type of notification `.time` or `.calendar`
    public var scheduleType: NotificationType
    /// The title for the notification
    public var title: String
    /// (Optional) subtitle for the notification
    public var subtitle: String?
    /// (Optioonal) image name as it appears in the bundle (must include suffix e.g. `MyImage.png`)
    public var bundleImageName: String?
    /// The main body content for the notification
    public var body: String
    /// The interval of time to wait before triggering the notification (only used if `scheduleType == .time`)
    public var timeInterval: Double?
    /// The date on which to trigger the notification (only used if `scheduleType == .calendar`)
    public var dateComponents: DateComponents?
    /// The notification will repeat if `true` default is `false`
    public var repeats: Bool
    /// Any custom data that you want passed along with the notification
    public var userInfo: [AnyHashable : Any]?
    /// The notification category (used when actions are associated with the notification)
    public var categoryIdentifier: String?
    
    public enum NotificationType {
        case time, calendar
    }
    
    public init(identifier: String = UUID().uuidString,
                  title: String,
                  subtitle: String? = nil,
                  body: String,
                  timeInterval: Double,
                  repeats: Bool = false) {
        self.identifier = identifier
        self.scheduleType = .time
        self.title = title
        self.subtitle = subtitle
        self.body = body
        self.timeInterval = timeInterval
        self.dateComponents = nil
        self.repeats = repeats
    }
    
    public init(identifier: String = UUID().uuidString, 
                  title: String,
                  subtitle: String? = nil,
                  body: String,
                  dateComponents: DateComponents,
                  repeats: Bool = false) {
        self.identifier = identifier
        self.scheduleType = .calendar
        self.title = title
        self.subtitle = subtitle
        self.body = body
        self.timeInterval = nil
        self.dateComponents = dateComponents
        self.repeats = repeats
    }

}
