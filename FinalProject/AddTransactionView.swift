//
//  AddTransactionView.swift
//  FinalProject
//
//  Created by Nikhil Devireddy on 12/1/24.
//

import SwiftUI

struct AddTransactionView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject var userSettings: UserSettings
    @State private var title = ""
    @State private var category = "Food"
    @State private var amount: Double = 0.0
    @State private var date = Date()
    @State private var type = "Expense"

    let categories = ["Food", "Entertainment", "Transportation", "Groceries", "Income"]
    let types = ["Expense", "Earning"]

    var body: some View {
        // Form view that contains labels and input fields for each property of Transaction
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
        .navigationTitle("Add Transaction")
    }

    // Creates new Transaction object and adds it to CoreData and updates balance.
    private func saveTransaction() {
        let newTransaction = Transaction(context: viewContext)
        newTransaction.id = UUID() // Assign a unique identifier
        newTransaction.title = title
        newTransaction.category = category
        newTransaction.amount = type == "Earning" ? amount : -amount
        newTransaction.date = date

        // Update balance
        userSettings.balance += (type == "Earning" ? amount : -amount)

        do {
            try viewContext.save()
            presentationMode.wrappedValue.dismiss()
        } catch {
            print("Failed to save transaction: \(error.localizedDescription)")
        }
    }
}

#Preview {
    AddTransactionView()
}
