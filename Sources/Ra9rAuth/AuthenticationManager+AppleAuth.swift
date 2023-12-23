//
//  File.swift
//  
//
//  Created by Rodney Aiglstorfer on 12/20/23.
//

import SwiftUI

import FirebaseCore
import FirebaseAuth

import CryptoKit
import AuthenticationServices

extension AuthenticationManager {
    
    public var linkedWithApple: Binding<Bool> {
        Binding<Bool> {
            return self.altProviders.contains { provider in
                provider == .apple
            }
        } set: { shouldLink in
            Task {
                do {
                    if shouldLink {
                        try await self.linkWithApple()
                    } else {
                        self.unlinkWithApple()
                    }
                } catch {
                    print("Binding Error: \(error)")
                }
            }
        }
    }
    
    public func signInWithApple() {
        let delegate = AppleAuthDelegate() { authCredential, appleIDCredential in
            Task {
                do {
                    let result = try await Auth.auth().signIn(with: authCredential)
                    self.updateDisplayName(for: result.user, with: appleIDCredential)
                    self.profile = Profile(user: result.user)
                    self.state = .authenticated
                } catch {
                    print("** Error: \(error)")
                }
            }
        }
        
        delegate.authenticate()
    }

    public func linkWithApple() {
        let delegate = AppleAuthDelegate() { authCredential, appleIDCredential in
            Task {
                do {
                    try await self.currentUser?.link(with: authCredential)
                    self.state = .authenticated
                } catch {
                    print("** Error: \(error)")
                }
            }
        }
        
        delegate.authenticate()
    }
    
    public func unlinkWithApple() {
        currentUser?.unlink(fromProvider: ProviderID.apple.rawValue)
    }

    private func updateDisplayName(for user: User, with appleIDCredential: ASAuthorizationAppleIDCredential, force: Bool = false) {
        if let currentDisplayName = currentUser?.displayName, !currentDisplayName.isEmpty {
            // current user is non-empty, don't overwrite it
        } else {
            let changeRequest = user.createProfileChangeRequest()
            if let fullName = appleIDCredential.fullName {
                changeRequest.displayName = "\(fullName.givenName ?? "") \(fullName.familyName ?? "")"
                changeRequest.commitChanges()
                profile?.displayName = Auth.auth().currentUser?.displayName ?? ""
            }
        }
    }
    
}
