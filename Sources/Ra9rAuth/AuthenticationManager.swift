//
//  AuthenticationManager.swift
//  SwiftFireStudy
//
//  Created by Rodney Aiglstorfer on 12/16/23.
//

import SwiftUI

import FirebaseCore
import FirebaseAuth

@Observable
public class Profile {
    public var uid: String
    public var email: String?
    public var photoUrl: String?
    public var phoneNumber: String?
    public var displayName: String?
    public var isAnonymous: Bool = false
    
    public init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.photoUrl = user.photoURL?.absoluteString
        self.phoneNumber = user.phoneNumber
        self.displayName = user.displayName
        self.isAnonymous = user.isAnonymous
    }
}

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
    
    private var currentUser: User? {
        return Auth.auth().currentUser
    }
    
    // Required for SignIn With Apple -> Firebase Auth
    private var currentNonce: String?
    
    public init() {
        guard let currentUser else {
            self.profile = nil
            return
        }
        
        self.profile = Profile(user: currentUser)
    }

}

// MARK: - Annonymous Support
extension AuthenticationManager {
    
    public func signInAnnonymously() async throws {
        let authDataResult = try await Auth.auth().signInAnonymously()
        self.profile = Profile(user: authDataResult.user)
    }
}

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

// MARK: - Google Auth Support
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

// MARK: - Apple Auth Support
import CryptoKit
import AuthenticationServices

extension AuthenticationManager {
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError(
                "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
        }
        
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        
        let nonce = randomBytes.map { byte in
            // Pick a random character from the set, wrapping around if needed.
            charset[Int(byte) % charset.count]
        }
        
        return String(nonce)
    }
    
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    public func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName, .email]
        let nonce = randomNonceString()
        currentNonce = nonce
        request.nonce = sha256(nonce)
    }
    
    public func handleSignInWithappleCompletion(_ result: Result<ASAuthorization, Error>) {
        if case .failure(let failure) = result {
            print("** Error: \(failure) **")
        }
        
        else if case .success(let success) = result {
            if let appleIDCredential = success.credential as? ASAuthorizationAppleIDCredential {
                guard let nonce = currentNonce else {
                    fatalError("** Invalid state: a login callback was received, but no login request was sent!")
                }
                guard let appleIDToken = appleIDCredential.identityToken else {
                    print("** Error: Unabled to fetch identify token **")
                    return
                }
                
                guard let idTokenString = String(data:appleIDToken, encoding: .utf8) else {
                    print("** Error: Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                    return
                }
                
                let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                          idToken: idTokenString,
                                                          rawNonce: nonce)
                
                Task {
                    do {
                        let result = try await Auth.auth().signIn(with: credential)
                        updateDisplayName(for: result.user, with: appleIDCredential)
                        self.profile = Profile(user: result.user)
                    } catch {
                        print("** Error: \(error)")
                    }
                }
            }
        }
    }
    
    public func updateDisplayName(for user: User, with appleIDCredential: ASAuthorizationAppleIDCredential, force: Bool = false) {
        if let currentDisplayName = currentUser?.displayName, !currentDisplayName.isEmpty {
            // current user is non-empty, don't overwrite it
        } else {
            let changeRequest = user.createProfileChangeRequest()
            if let fullName = appleIDCredential.fullName {
                changeRequest.displayName = "\(fullName.givenName) \(fullName.familyName)"
                changeRequest.commitChanges()
                profile?.displayName = Auth.auth().currentUser?.displayName ?? ""
            }
        }
    }
    
}
