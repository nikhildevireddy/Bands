//
//  TransactionsListView.swift
//  FinalProject
//
//  Created by Nikhil Devireddy on 12/1/24.
//

import SwiftUI

struct TransactionsListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Transaction.date, ascending: false)],
        animation: .default)
    private var transactions: FetchedResults<Transaction>
    @State private var selectedCategory: String? = nil
    // The available categories the users can label their transactions under
    let categories = ["All", "Food", "Entertainment", "Transportation", "Groceries", "Income"]

    // The list of transactions for the selected category
    var filteredTransactions: [Transaction] {
        if let selectedCategory = selectedCategory, selectedCategory != "All" {
            return transactions.filter { $0.category == selectedCategory }
        }
        return Array(transactions)
    }

    var body: some View {
        NavigationView {
            VStack {
                // Segmented Control
                Picker("Category", selection: $selectedCategory) {
                    ForEach(categories, id: \.self) { category in
                        Text(category).tag(category as String?)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                // List view of each transaction in the filtered transaction list. Clicking on a cell navigates to the Edit Transaction screen
                List {
                    ForEach(filteredTransactions, id: \.id) { transaction in
                        NavigationLink(destination: EditTransactionView(transactionID: transaction.objectID)) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(transaction.title ?? "Unknown Title")
                                        .font(.headline)
                                    Text(transaction.date ?? Date(), style: .date)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                Text(transaction.category ?? "Unknown")
                                    .padding(8)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(8)
                                Spacer()
                                Text("$\(transaction.amount, specifier: "%.2f")")
                                    .foregroundColor(transaction.amount > 0 ? .green : .red)
                            }
                        }
                    }
                    // Swipe to delete
                    .onDelete(perform: deleteTransaction)
                }
            }
            .navigationTitle("Transactions")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AddTransactionView()) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }

    // Function triggered when swiping a cell to delete it. Removes transaction from CoreData and updates the balance.
    private func deleteTransaction(at offsets: IndexSet) {
        for index in offsets {
            let transaction = transactions[index]
            var balance = UserDefaults.standard.double(forKey: "balance")

            // Adjust the balance based on the transaction's amount
            balance -= transaction.amount // Add back expense, deduct earning
            UserDefaults.standard.set(balance, forKey: "balance")

            // Delete the transaction from CoreData
            viewContext.delete(transaction)
        }

        // Save changes to CoreData
        do {
            try viewContext.save()
        } catch {
            print("Failed to delete transaction: \(error.localizedDescription)")
        }
//        offsets.map { transactions[$0] }.forEach(viewContext.delete)
//        try? viewContext.save()
    }
}

#Preview {
    TransactionsListView()
}
