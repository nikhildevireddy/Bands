//
//  LoginView.swift
//  FinalProject
//
//  Created by Nikhil Devireddy on 12/1/24.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?
    // Authentication status state variable
    @State private var isAuthenticated = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Bands")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                TextField("Email", text: $email)
                    .textFieldStyle(.roundedBorder)
                    .autocapitalization(.none)

                SecureField("Password", text: $password)
                    .textFieldStyle(.roundedBorder)

                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                }

                Button(action: loginUser) {
                    Text("Login")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }

                NavigationLink(destination: CreateAccountView()) {
                    Text("Create Account")
                        .foregroundColor(.green)
                }
            }
            .padding()
            // Triggers navigation if user is logged in
            .navigationDestination(isPresented: $isAuthenticated) {
                MainView()
            }
        }
    }

    private func loginUser() {
        // Uses Firebase's sign in function to authenticate the user
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                errorMessage = error.localizedDescription
                return
            }
            isAuthenticated = true
        }
    }
}




//#Preview {
//    LoginView()
//}
