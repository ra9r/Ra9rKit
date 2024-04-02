//
//  File.swift
//  
//
//  Created by Rodney Aiglstorfer on 4/2/24.
//
import SwiftUI

public struct LocalNotificationAction {
    /// The value that will be used as the `actionIdentifier` for the ``UNNotificationAction```
    var identifier: String
    /// The localized string key value that will be used as the `title` for the ``UNNotificationAction``
    var label: String
    
    var option: LocalNotificationActionOption?
    
    
    /// Creates an action icon by using a system symbol image.
    var systemImage: String?
    
    /// Creates an action icon based on an image in your app’s bundle, preferably in an asset catalog.
    var templateImage: String?
    
    /// Creates an basic action item
    /// - Parameters:
    ///   - identifier: The value that will be used as the `actionIdentifier`
    ///   - label: The localized string key value that will be used as the `title`
    ///   - requireAuth: If `true` the action can be performed only on an unlocked device.
    ///   - destructive: If `true` the action performs a destructive task.
    ///   - foreground: If `true` the action causes the app to launch in the foreground.
    public init(_ identifier: String,
                label: String,
                option: LocalNotificationActionOption? = nil) {
        self.identifier = identifier
        self.label = label
        self.option = option
        self.systemImage = nil
        self.templateImage = nil
    }
    
    /// Creates an action item that includes an system image as an icon
    /// - Parameters:
    ///   - identifier: The value that will be used as the `actionIdentifier`
    ///   - label: The localized string key value that will be used as the `title`
    ///   - systemImage: Icon using a system symbol image.
    ///   - requireAuth: If `true` the action can be performed only on an unlocked device.
    ///   - destructive: If `true` the action performs a destructive task.
    ///   - foreground: If `true` the action causes the app to launch in the foreground.
    public init(_ identifier: String,
                label: String,
                systemImage: String,
                option: LocalNotificationActionOption? = nil) {
        self.init(identifier, label: label, option: option)
        self.systemImage = systemImage
    }
    
    /// Creates an action item that includes an icon from an image in your app’s bundle, preferably in an asset catalog.
    /// - Parameters:
    ///   - identifier: The value that will be used as the `actionIdentifier`
    ///   - label: The localized string key value that will be used as the `title`
    ///   - templateImage: Icon based on an image in your app’s bundle, preferably in an asset catalog.
    ///   - requireAuth: If `true` the action can be performed only on an unlocked device.
    ///   - destructive: If `true` the action performs a destructive task.
    ///   - foreground: If `true` the action causes the app to launch in the foreground.
    public init(_ identifier: String,
                label: String,
                templateImage: String,
                option: LocalNotificationActionOption? = nil) {
        self.init(identifier, label: label, option: option)
        self.templateImage = templateImage
    }
    
    func convert() -> UNNotificationAction {
        if let systemImage {
            if let options {
                return UNNotificationAction(
                    identifier: identifier,
                    title: label,
                    options: options,
                    icon: UNNotificationActionIcon(systemImageName: systemImage))
            }
            return UNNotificationAction(
                identifier: identifier,
                title: label,
                icon: UNNotificationActionIcon(systemImageName: systemImage)
            )
           
        } else if let templateImage {
            if let options {
                return UNNotificationAction(
                    identifier: identifier,
                    title: label,
                    options: options,
                    icon: UNNotificationActionIcon(templateImageName: templateImage))
            }
            return UNNotificationAction(
                identifier: identifier,
                title: label,
                icon: UNNotificationActionIcon(templateImageName: templateImage))
        } else {
            if let options {
                return UNNotificationAction(
                    identifier: identifier,
                    title: label,
                    options: options)
            }
            return UNNotificationAction(
                identifier: identifier,
                title: label)
        }
    }
    
    var options: UNNotificationActionOptions? {
        if let option {
            switch option {
                case .authenticationRequired:
                    return .authenticationRequired
                case .destructive:
                    return .destructive
                case .foreground:
                    return .foreground
            }
        }
        return nil
    }
}
