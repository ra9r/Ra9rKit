//
//  AuthenticationView.swift
//  SwiftFireStudy
//
//  Created by Rodney Aiglstorfer on 12/16/23.
//

import SwiftUI
import AuthenticationServices


public struct AuthenticationView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    
    public init() {
        // Needed for access
    }
    
    public var body: some View {
        VStack {
            NavigationLink {
                RegisterEmailView()
            } label: {
                Text("Sign In with Email")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            
            Button {
                Task {
                    do {
                        try await authManager.signInWithGoogle()
                    } catch {
                        print("** ERROR: \(error.localizedDescription)")
                    }
                }
            } label: {
                Text("Sign In with Google")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            
            SignInWithAppleButton { request in
                authManager.handleSignInWithAppleRequest(request)
            } onCompletion: { result in
                authManager.handleSignInWithappleCompletion(result)
            }
            .font(.headline)
            .foregroundStyle(.white)
            .frame(height: 55)
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .cornerRadius(10)
            Spacer()
        }
        .padding()
        .navigationTitle("Sign In")
    }
}

#Preview {
    NavigationStack {
        AuthenticationView()
    }
}
