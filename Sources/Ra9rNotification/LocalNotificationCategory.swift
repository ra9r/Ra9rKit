//
//  File.swift
//  
//
//  Created by Rodney Aiglstorfer on 4/2/24.
//

import SwiftUI

/// A category is a collection of actions that is referenced by an identifier.  This information is use to setup
/// actions when supporting local notifications.
///
/// # Example Usage
/// ```swift
/// var defaultCategory = LocalNotificationCategory("snooze")
///     .addAction("snooze30", label: "Snooze 30 secons", systemImage: "powersleep")
///     .addAction("dismiss", label: "Dismiss", option: .destructive)
/// ```
public class LocalNotificationCategory {
    public var identifier: String
    public var actions: [LocalNotificationAction]
    
    public init(_ identifier: String) {
        self.identifier = identifier
        self.actions = []
    }
    
    public func addAction(_ identifier: String,
                   label: LocalizedStringKey,
                   option: LocalNotificationActionOption?) -> LocalNotificationCategory {
        let action = LocalNotificationAction(identifier,
                                             label: label,
                                             option: option)
        return self.addAction(action)
    }
    
    public func addAction(_ identifier: String,
                   label: LocalizedStringKey,
                   systemImage: String,
                   option: LocalNotificationActionOption?) -> LocalNotificationCategory {
        let action = LocalNotificationAction(identifier,
                                             label: label,
                                             systemImage: systemImage,
                                             option: option)
        return self.addAction(action)
    }
    
    public func addAction(_ action: LocalNotificationAction) -> LocalNotificationCategory  {
        actions.append(action)
        
        return self
    }
    
    func convert() -> UNNotificationCategory {
        var navtiveActions: [UNNotificationAction] = []
        for action in actions {
            navtiveActions.append(action.convert())
        }
        return UNNotificationCategory(identifier: identifier,
                                      actions: navtiveActions,
                                      intentIdentifiers: [])
    }
}
