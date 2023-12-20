//
//  File.swift
//  
//
//  Created by Rodney Aiglstorfer on 12/20/23.
//

import Foundation

import FirebaseCore
import FirebaseAuth

// MARK: - Annonymous Support
extension AuthenticationManager {
    
    public func signInAnnonymously() async throws {
        let authDataResult = try await Auth.auth().signInAnonymously()
        self.profile = Profile(user: authDataResult.user)
    }
}
