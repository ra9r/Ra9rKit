//
//  RegisterEmailView.swift
//  SwiftFireStudy
//
//  Created by Rodney Aiglstorfer on 12/16/23.
//

import SwiftUI

public struct RegisterEmailView: View {
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
                        try await authManager.createUser(withEmail: email, password: password)
                    } catch {
                        print("** Error: \(error) **")
                    }
                }
            } label: {
                Text("Register")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            
            NavigationLink ("Already have an account?") {
                SignInEmailView()
            }
            Spacer()
        }
        .padding()
        .navigationTitle("Register")
    }
}
