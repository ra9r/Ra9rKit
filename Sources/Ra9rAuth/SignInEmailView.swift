//
//  SignInEmailView.swift
//  SwiftFireStudy
//
//  Created by Rodney Aiglstorfer on 12/16/23.
//

import SwiftUI

public struct SignInEmailView: View {
    @EnvironmentObject private var authManager: AuthenticationManager
    @State var email: String = ""
    @State var password: String = ""
    
    public var body: some View {
        VStack {
            TextField("Email...", text: $email)
                .keyboardType(.emailAddress)
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10)
            
            SecureField("Password...", text: $password)
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10)
            
            Button {
                Task {
                    do {
                        try await authManager.signIn(withEmail: email, password: password)
                    } catch {
                        print("** Error: \(error) **")
                    }
                }
            } label: {
                Text("Sign In")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            Spacer()
        }
        .padding()
        .navigationTitle("Sign In")
    }
}

#Preview {
    NavigationStack {
        SignInEmailView()
            .environmentObject(AuthenticationManager())
    }
    
}
