//
//  FinalProjectApp.swift
//  FinalProject
//
//  Created by Nikhil Devireddy on 11/25/24.
//

import SwiftUI

@main
struct FinalProjectApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
