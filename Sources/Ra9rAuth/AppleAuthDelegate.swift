//
//  File.swift
//  
//
//  Created by Rodney Aiglstorfer on 12/23/23.
//

import Foundation
import CryptoKit
import AuthenticationServices
import FirebaseAuth

public class AppleAuthDelegate: NSObject, ASAuthorizationControllerDelegate {
    public typealias handleCredentialsType = (AuthCredential, ASAuthorizationAppleIDCredential) -> Void
    // Required for SignIn With Apple -> Firebase Auth
    internal var currentNonce: String?
    
    public var handleCredentials: handleCredentialsType
    
    init(_ handleCredentials: @escaping handleCredentialsType) {
        self.handleCredentials = handleCredentials
    }

    func authenticate() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        // Configure the request here, like requesting full name and email
        handleSignInWithAppleRequest(request)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }

    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        // Handle authorization success and extract credential
        handleSignInWithappleCompletion(Result.success(authorization))
    }
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error
        handleSignInWithappleCompletion(Result.failure(error))
    }
    
    private func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName, .email]
        let nonce = randomNonceString()
        currentNonce = nonce
        request.nonce = sha256(nonce)
    }
    
    private func handleSignInWithappleCompletion(_ result: Result<ASAuthorization, Error>) {
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
                
                self.handleCredentials(credential, appleIDCredential)
            }
        }
    }
    
}

extension AppleAuthDelegate {
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
}
