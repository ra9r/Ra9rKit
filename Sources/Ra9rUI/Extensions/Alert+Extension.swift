//
//  Alert+Extension.swift
//
//
//  Created by Rodney Aiglstorfer on 4/15/24.
//

import SwiftUI

extension Alert {
    // MARK: - Alert
    public init(localizedError: LocalizedError) {
        self = Alert(nsError: localizedError as NSError)
    }
    
    public init(nsError: NSError) {
        let message: Text? = {
            let message = [nsError.localizedFailureReason, nsError.localizedRecoverySuggestion].compactMap({ $0 }).joined(separator: "\n\n")
            return message.isEmpty ? nil : Text(message)
        }()
        self = Alert(title: Text(nsError.localizedDescription),
                     message: message,
                     dismissButton: .default(Text("OK")))
    }
}
