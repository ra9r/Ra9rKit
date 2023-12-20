//
//  File.swift
//  
//
//  Created by Rodney Aiglstorfer on 12/20/23.
//

import Foundation

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
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootViewController = window.rootViewController else {
            print("There is no root view controller")
            self.profile = nil
            return
        }
        
        let userAuthentication = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
        let user = userAuthentication.user
        guard let idToken = user.idToken else {
            print("** ERROR: ID token missing **")
            self.profile = nil
            return
        }
        let accessToken = user.accessToken
        let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString,
                                                       accessToken: accessToken.tokenString)
        
        let result = try await Auth.auth().signIn(with: credential)
        self.profile = Profile(user: result.user)
        
    }
}
