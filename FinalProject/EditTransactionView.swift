//
//  EditTransactionView.swift
//  FinalProject
//
//  Created by Nikhil Devireddy on 12/2/24.
//

import SwiftUI
import CoreData

struct EditTransactionView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject var userSettings: UserSettings

    @State private var title: String = ""
    @State private var category: String = "Food"
    @State private var amount: Double = 0.0
    @State private var date: Date = Date()
    @State private var type: String = "Expense"

    let transactionID: NSManagedObjectID
    let categories = ["Food", "Entertainment", "Transportation", "Groceries", "Income"]
    let types = ["Expense", "Earning"]

    var body: some View {
        Form {
            Section(header: Text("Details")) {
                TextField("Title", text: $title)

                Picker("Category", selection: $category) {
                    ForEach(categories, id: \.self) { Text($0) }
                }

                TextField("Amount", value: $amount, formatter: NumberFormatter())
                    .keyboardType(.decimalPad)

                DatePicker("Date", selection: $date, displayedComponents: .date)

                Picker("Type", selection: $type) {
                    ForEach(types, id: \.self) { Text($0) }
                }
                .pickerStyle(SegmentedPickerStyle())
            }

            Button(action: saveTransaction) {
                Text("Save")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .navigationTitle("Edit Transaction")
        .onAppear(perform: loadTransaction)
    }

    // Preloads the input fields with the existing data for that transaction
    private func loadTransaction() {
        do {
            if let transaction = try viewContext.existingObject(with: transactionID) as? Transaction {
                title = transaction.title ?? ""
                category = transaction.category ?? "Food"
//                amount = transaction.amount
                date = transaction.date ?? Date()
                type = transaction.amount >= 0 ? "Earning" : "Expense"
            }
        } catch {
            print("Failed to load transaction: \(error.localizedDescription)")
        }
    }
    // Retrieves the existing Transaction object in CoreData by its id and updates its attributes' values
    private func saveTransaction() {
        do {
            if let transaction = try viewContext.existingObject(with: transactionID) as? Transaction {
                // Adjust balance for the difference
                let originalAmount = transaction.amount
                userSettings.balance -= originalAmount // Undo the previous value
                userSettings.balance += type == "Earning" ? amount : -amount // Apply the new value

                transaction.title = title
                transaction.category = category
                transaction.amount = type == "Earning" ? amount : -amount
                transaction.date = date

                try viewContext.save()
                presentationMode.wrappedValue.dismiss()
            }
        } catch {
            print("Failed to save transaction: \(error.localizedDescription)")
        }
    }
}

#Preview {
    // Pass a valid transactionID for testing
    EditTransactionView(transactionID: NSManagedObjectID())
}


