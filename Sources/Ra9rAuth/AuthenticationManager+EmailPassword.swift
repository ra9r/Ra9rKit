//
//  File.swift
//  
//
//  Created by Rodney Aiglstorfer on 12/20/23.
//

import Foundation

import FirebaseCore
import FirebaseAuth

// MARK: - Email & Passwork Auth Support
extension AuthenticationManager {
    
    public func createUser(withEmail email: String, password: String) async throws {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        self.profile = Profile(user: authDataResult.user)
    }
    
    public func signOut() throws {
        try Auth.auth().signOut()
        self.profile = nil
    }
    
    public func signIn(withEmail email: String, password: String) async throws {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        
        self.profile = Profile(user: authDataResult.user)
    }
    
}
