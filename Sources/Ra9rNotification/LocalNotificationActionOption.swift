//
//  LocalNotificationActionOption.swift
//  
//
//  Created by Rodney Aiglstorfer on 4/2/24.
//

import Foundation


public enum LocalNotificationActionOption {
    /// the action can be performed only on an unlocked device.
    case authenticationRequired
    /// the action performs a destructive task.
    case destructive
    /// the action causes the app to launch in the foreground.
    case foreground
}
