//
//  FinalProjectApp.swift
//  FinalProject
//
//  Created by Nikhil Devireddy on 11/25/24.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

class UserSettings: ObservableObject {
    // A published property for the user's monthly budget.
    // Changes to this property will automatically trigger updates in SwiftUI views and save to UserDefaults
    @Published var monthlyBudget: Double {
        didSet {
            UserDefaults.standard.set(monthlyBudget, forKey: "monthlyBudget")
        }
    }
    // A published property for the user's current balance.
    // Changes to this property will automatically trigger updates in SwiftUI views and save to UserDefaults
    @Published var balance: Double {
        didSet {
            UserDefaults.standard.set(balance, forKey: "balance")
        }
    }
    // Initializer to load the saved values from UserDefaults into the properties.
    // If no values are saved, default values of 0.0 are used.
    init() {
        self.monthlyBudget = UserDefaults.standard.double(forKey: "monthlyBudget")
        self.balance = UserDefaults.standard.double(forKey: "balance")
    }
}


@main
struct FinalProjectApp: App {
    @StateObject private var userSettings = UserSettings()
    
    let persistenceController = PersistenceController.shared
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        // If there is an authenticated user, the root view in the Navigation Stack is the main screen; otherwise, the login screen
        WindowGroup {
                if Auth.auth().currentUser == nil {
                    LoginView()
                        .environment(\.managedObjectContext, persistenceController.container.viewContext)
                        .environmentObject(userSettings)
                } else {
                    MainView()
                        .environment(\.managedObjectContext, persistenceController.container.viewContext)
                        .environmentObject(userSettings)
//                        .toolbar {
//                            ToolbarItem(placement: .navigationBarLeading) { EmptyView() } // Disable back button
//                        }
                }
            }
            
        }
    }

