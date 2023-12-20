//
//  AuthenticationManager.swift
//  SwiftFireStudy
//
//  Created by Rodney Aiglstorfer on 12/16/23.
//

import SwiftUI

import FirebaseCore
import FirebaseAuth

@MainActor
public final class AuthenticationManager : ObservableObject {
    
    @Published public var profile: Profile?
    
    public var needsAuthentication: Binding<Bool> {
        Binding<Bool> {
            self.profile == nil
        } set: { newShouldAuth in
            if newShouldAuth == true {
                self.profile = nil
            }
        }
    }
    
    internal var currentUser: User? {
        return Auth.auth().currentUser
    }
    
    // Required for SignIn With Apple -> Firebase Auth
    internal var currentNonce: String?
    
    public init() {
        guard let currentUser else {
            self.profile = nil
            return
        }
        
        self.profile = Profile(user: currentUser)
    }

}








