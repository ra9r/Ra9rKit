//
//  File.swift
//  
//
//  Created by Rodney Aiglstorfer on 12/20/23.
//

import SwiftUI

import FirebaseCore
import FirebaseAuth

import GoogleSignIn
import GoogleSignInSwift

extension AuthenticationManager {
    public var clientID: String? {
        FirebaseApp.app()?.options.clientID
    }
    
    public func signInWithGoogle() async throws {
        guard let clientID else { return }
        
        guard let credential = try await googleAuth(clientID: clientID) else { return }
        
        let result = try await Auth.auth().signIn(with: credential)
        self.profile = Profile(user: result.user)
        self.state = .authenticated
    }
    
    public func linkWithGoogle() async throws  {
        guard let clientID else { return }
        
        guard let credential = try await googleAuth(clientID: clientID) else { return }
        
        try await currentUser?.link(with: credential)
    }
    
    public func unlinkWithGoogle() {
        currentUser?.unlink(fromProvider: ProviderID.google.rawValue)
    }
    
    public var linkedWithGoogle: Binding<Bool> {
        Binding<Bool> {
            return self.altProviders.contains { provider in
                provider == .google
            }
        } set: { shouldLink in
            Task {
                do {
                    if shouldLink {
                        try await self.linkWithGoogle()
                    } else {
                        self.unlinkWithGoogle()
                    }
                } catch {
                    print("Binding Error: \(error)")
                }
            }
        }
    }
    
    private func googleAuth(clientID: String) async throws -> AuthCredential? {
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootViewController = window.rootViewController else {
            print("There is no root view controller")
            self.profile = nil
            self.state = .mustRegister
            return nil
        }
        
        let userAuthentication = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
        let user = userAuthentication.user
        guard let idToken = user.idToken else {
            print("** ERROR: ID token missing **")
            self.profile = nil
            self.state = .mustRegister
            return nil
        }
        let accessToken = user.accessToken
        return GoogleAuthProvider.credential(withIDToken: idToken.tokenString,
                                                       accessToken: accessToken.tokenString)
    }
}
