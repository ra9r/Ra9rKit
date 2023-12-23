//
//  File.swift
//  
//
//  Created by Rodney Aiglstorfer on 12/20/23.
//

import Foundation

import FirebaseCore
import FirebaseAuth

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
                        self.state = .authenticated
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
                changeRequest.displayName = "\(fullName.givenName ?? "") \(fullName.familyName ?? "")"
                changeRequest.commitChanges()
                profile?.displayName = Auth.auth().currentUser?.displayName ?? ""
            }
        }
    }
    
}
