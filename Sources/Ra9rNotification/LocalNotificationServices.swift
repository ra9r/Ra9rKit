//
//  NotificationServices.swift
//  Chemo-Buddy
//
//  Created by Rodney Aiglstorfer on 3/28/24.
//

import SwiftUI
import UserNotifications

typealias LocalNotificationActionHandler = (String, UNNotificationContent) -> Void

/// Service provider for Local Notifications.
///
/// # Example Setup
/// ```swift
/// @State var lnServices = LocalNotificationServices(category: [
///         LocalNotificationCategory("snooze")
///             .addAction("snooze30", label: "Snooze 30 secons", systemImage: "powersleep")
///             .addAction("dismiss", label: "Dismiss", option: .destructive),
///         LocalNotificationCategory("severity")
///             .addAction("mild", label: "Mild", option: .authenticationRequired)
///             .addAction("moderate", label: "Moderate", option: .authenticationRequired)
///             .addAction("severe", label: "Severe", option: .authenticationRequired)
///             .addAction("notPresent", label: "Not Present", option: .destructive)
/// ])
/// ```
///
/// > Don't forget to add ``LocalNotificationServices`` to your environment using `.environmentObject()`
@MainActor
public class LocalNotificationServices : NSObject, ObservableObject {
    private let notificationCenter = UNUserNotificationCenter.current()

    @Published public var pendingRequests: [UNNotificationRequest] = []
    
    /// State property is set to `true` if user has granted permissions, `false` otherwise.
    /// Update this value by calling the `getCurrentSettings()` functions.
    @Published public var isGranted = false
    
    
    /// This property is set each time a local notification is clicked on
    @Published public var notificationEvent: LocalNotificationActionEvent?
    
    public override init() {
        super.init()
        notificationCenter.delegate = self
    }
    
    public convenience init(categories: [LocalNotificationCategory]) {
        self.init()
        var nativeCategories: Set<UNNotificationCategory> = []
        for category in categories {
            nativeCategories.insert(category.convert())
        }
        notificationCenter.setNotificationCategories(nativeCategories)
    }
    
    /// Ask for user's permission to issue local notifications
    public func requestPermission() async throws {
        try await notificationCenter.requestAuthorization(options: [.sound, .badge, .alert])
        await getCurrentSettings()
    }
    
    /// Updates the `isGranted` state property to `true` if user has granted permissions, `false` otherwise.
    public func getCurrentSettings() async {
        let currentSettings = await notificationCenter.notificationSettings()
        isGranted = (currentSettings.authorizationStatus == .authorized)
    }
    
    /// Opens the notificaiton settings page in Settings
    public func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(url) {
                Task {
                    await UIApplication.shared.open(url)
                }
            }
        }
    }
    
    /// Schedule a notification
    /// - Parameters:
    ///   - localNotification: The notification details and schedule info (see ``LocalNotification``)
    ///   - sound: Optional sound to play when notification appears, default is ``UNNotificationSound.default``
    public func schedule(_ localNotification: LocalNotification, sound: UNNotificationSound? = nil) async {
        let content = UNMutableNotificationContent()
        content.title = localNotification.title
        content.body = localNotification.body
        content.sound = sound ?? .default
        
        if let badge = localNotification.badge {
            content.badge = NSNumber(integerLiteral: badge)
        }
        
        if let subtitle = localNotification.subtitle {
            content.subtitle = subtitle
        }
        
        if let bundleImageName = localNotification.bundleImageName {
            if let url = Bundle.main.url(forResource: bundleImageName, withExtension: "") {
                if let attachment = try? UNNotificationAttachment(identifier: bundleImageName, url: url) {
                    content.attachments = [attachment]
                }
            }
        }
        
        if let userInfo = localNotification.userInfo {
            content.userInfo = userInfo
        }
        
        if let categoryIdentifier = localNotification.categoryIdentifier {
            content.categoryIdentifier = categoryIdentifier
        }
        
        if localNotification.scheduleType == .time {
            guard let timeInterval = localNotification.timeInterval else { return }
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: localNotification.repeats)
            let request = UNNotificationRequest(identifier: localNotification.identifier, content: content, trigger: trigger)
            try? await notificationCenter.add(request)
        } else {
            guard let dateComponents = localNotification.dateComponents else { return }
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: localNotification.repeats)
            let request = UNNotificationRequest(identifier: localNotification.identifier, content: content, trigger: trigger)
            try? await notificationCenter.add(request)
        }
        
        await getPendingRequests()
    }
    
    /// Updates the `pendingRequests` state variable
    public func getPendingRequests() async {
        pendingRequests = await notificationCenter.pendingNotificationRequests()
//        print("Pending: \(pendingRequests.count)")
    }
    
    /// Cancels a pending notification request
    public func removeRequest(withIdentifier identifier: String) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
        if let index = pendingRequests.firstIndex(where: {$0.identifier == identifier}) {
            pendingRequests.remove(at: index)
//            print("Pending: \(pendingRequests.count)")
        }
    }
    
    /// Clears all pending notifications requests
    public func clearRequests() {
        notificationCenter.removeAllPendingNotificationRequests()
        pendingRequests.removeAll()
//        print("Pending: \(pendingRequests.count)")
    }
    
    /// This will "snooze" a notification by scheduling a duplicate notification using the specified `interval` and optional `repeat`
    public func snooze(_ content: UNNotificationContent, interval: Double, repeats: Bool = false) async {
        let newContent = content.mutableCopy() as! UNMutableNotificationContent
        let newTrigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: repeats)
        let request = UNNotificationRequest(identifier: UUID().uuidString,
                                            content: newContent,
                                            trigger: newTrigger)
        
        do {
            try await notificationCenter.add(request)
        } catch {
            print(error.localizedDescription)
        }
        
        await getPendingRequests()
    }
}

extension LocalNotificationServices : UNUserNotificationCenterDelegate {
    
    /// This method is called when a notification arrives while the app is in the foreground.
    /// It allows your app to determine how to handle the notification — whether to show it t
    /// o the user, and with what type of presentation style.
    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        await getPendingRequests()
        return [.sound, .banner]
    }
    
    /// This method is called in response to a user interacting with a notification 
    public func userNotificationCenter(_ center: UNUserNotificationCenter, 
                                       didReceive response: UNNotificationResponse) async {
        
        let request = response.notification.request
        self.notificationEvent = LocalNotificationActionEvent(id: request.identifier,
                                                        actionIdentifier: response.actionIdentifier,
                                                        content: request.content)
    }
}


