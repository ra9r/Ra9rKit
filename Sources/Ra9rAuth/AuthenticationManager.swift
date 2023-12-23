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
    @Published public var state: AuthState = .mustRegister
    @Published public var biometricsEnabled: Bool = false
    
    public var needsAuthentication: Binding<Bool> {
        Binding<Bool> {
            switch self.state {
                case .anonymous:
                    fallthrough
                case .authenticated:
                    return false
                case .mustRegister:
                    fallthrough
                case .mustSignIn:
                    return true
            }
        } set: { newShouldAuth in
            if newShouldAuth == true {
                self.profile = nil
            }
        }
    }
    
    internal var currentUser: User? {
        return Auth.auth().currentUser
    }
    
    
    
    public init() {
        guard let currentUser else {
            self.profile = nil
            return
        }
        
        self.profile = Profile(user: currentUser)
    }

    public var altProviders: [ProviderID] {
        guard let user = currentUser else {
            return []
        }
        return user.providerData.map { userInfo in
            return ProviderID(rawValue: userInfo.providerID)!
        }
    }
    
    public func signOut() throws {
        try Auth.auth().signOut()
        self.profile = nil
        self.state = .mustRegister
    }
}








