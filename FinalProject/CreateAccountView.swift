//
//  CreateAccountView.swift
//  FinalProject
//
//  Created by Nikhil Devireddy on 12/1/24.
//

import SwiftUI
import FirebaseAuth

struct CreateAccountView: View {
    @Environment(\.dismiss) var dismiss
    @State private var email = ""
    @State private var password = ""
    @State private var monthBudget: Double = 0.0
    @State private var errorMessage: String?
    @State private var isRegistered = false

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

                TextField("Monthly Budget", value: $monthBudget, format: .currency(code: "USD"))
                    .textFieldStyle(.roundedBorder)

                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                }

                Button(action: registerUser) {
                    Text("Register")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding()
        }
    }

    private func registerUser() {
        // Uses Firebase's create account function to register a user into the Firebase project
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                errorMessage = error.localizedDescription
                return
            }

            // Store monthly budget and initial balance in UserDefaults
            UserDefaults.standard.set(monthBudget, forKey: "monthlyBudget")
            UserDefaults.standard.set(monthBudget, forKey: "balance")
            isRegistered = true
            dismiss()
            
        }
    }
}




//#Preview {
//    CreateAccountView()
//}
