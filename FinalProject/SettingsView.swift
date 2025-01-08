//
//  SettingsView.swift
//  FinalProject
//
//  Created by Nikhil Devireddy on 12/1/24.
//

import FirebaseAuth
import SwiftUI

struct SettingsView: View {
//    @Binding var isLoggedIn: Bool // Binding to update login state
    @EnvironmentObject var userSettings: UserSettings
    @Environment(\.dismiss) var dismiss
    @State private var isDarkMode = false
    @State private var newBudget: String = ""
    @State private var isLoggedOut = false
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        VStack {
            Form {
                // Light/Dark mode toggle feature
                Toggle(isOn: $isDarkMode) {
                    Text("Dark Mode")
                }
                .onChange(of: isDarkMode) {
                    updateColorScheme()
                }
                // Allows user to update their monthly budget which dynamically updates their balance as well
                Section(header: Text("Update Budget")) {
                    TextField("New Monthly Budget", text: $newBudget)
                        .keyboardType(.decimalPad)

                    Button("Save") {
                        updateBudget()
                    }
                }
            }

            Spacer()

            // Signs user out
            Button(action: handleSignOut) {
                Text("Sign Out")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.red)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
        .navigationTitle("Settings")
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Budget Update"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
//         Navigates back to login screen if the user is signed out
        .fullScreenCover(isPresented: $isLoggedOut) {
            LoginView()
                .environmentObject(userSettings) // Pass environment object to LoginView
        }
    }

    private func updateBudget() {
        
        if let budget = Double(newBudget) {
            
            let currentMonthlyBudget = userSettings.monthlyBudget
            var currentBalance = userSettings.balance

            // Update the balance based on the logic provided
            if budget > currentMonthlyBudget {
                currentBalance += abs(budget - currentMonthlyBudget)
            } else {
                currentBalance -= abs(currentMonthlyBudget - budget)
            }
            userSettings.monthlyBudget = budget
            userSettings.balance = currentBalance
            // Save the updated values to UserDefaults

            alertMessage = "Budget successfully updated!"
            showAlert = true
        }
        
        
    }

    private func updateColorScheme() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        let style: UIUserInterfaceStyle = isDarkMode ? .dark : .light

        for window in windowScene.windows {
            window.overrideUserInterfaceStyle = style
        }
    }

    // Uses Firebase's sign out function to sign the user out
    private func handleSignOut() {
        do {
            try Auth.auth().signOut()
            isLoggedOut = true
//            dismiss()
        } catch {
            print("Sign out Error")
        }
    }
}


//#Preview {
//    SettingsView()
//}
