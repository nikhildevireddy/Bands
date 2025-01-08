//
//  MainView.swift
//  FinalProject
//
//  Created by Nikhil Devireddy on 12/1/24.
//

import SwiftUI

struct MainView: View {
//    @Binding var isLoggedIn: Bool
    @EnvironmentObject var userSettings: UserSettings
    @Environment(\.managedObjectContext) private var viewContext
    // Fetches the Transaction objects from CoreData
    @FetchRequest(
        entity: Transaction.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Transaction.date, ascending: false)],
        animation: .default
    ) private var transactions: FetchedResults<Transaction>

    @State private var navigateToTransactions = false
    @State private var navigateToCalendar = false
    @State private var navigateToSettings = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                HStack {
                    Button(action: { navigateToSettings = true }) {
                        Image(systemName: "gearshape")
                            .font(.title)
                    }
                    Spacer()
                    Button(action: { navigateToCalendar = true }) {
                        Image(systemName: "calendar")
                            .font(.title)
                    }
                }
                .padding()

                // Balance View
                VStack {
                    Text("Balance")
                        .font(.headline)
                    Text("$\(userSettings.balance, specifier: "%.2f")")
                        .font(.largeTitle)
                        .bold()
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1)
                        .shadow(radius: 5)
                )
                .padding(.bottom, 20)

                // Transactions View (Three most recent transactions)
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Transactions")
                            .font(.headline)

                        Spacer()

                        Button(action: { navigateToTransactions = true }) {
                            HStack {
                                Text("View All")
                                Image(systemName: "chevron.right")
                            }
                            .font(.subheadline)
                            .foregroundColor(.blue)
                        }
                    }

                    ForEach(transactions.prefix(3)) { transaction in
                        TransactionCellView(transaction: transaction)
                            .padding(.vertical, 5)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(uiColor: .systemBackground))
                        .shadow(color: .gray.opacity(0.4), radius: 5, x: 0, y: 3)
                )

                Spacer()
            }
            .padding()
            .navigationDestination(isPresented: $navigateToTransactions) {
                TransactionsListView()
            }
            .navigationDestination(isPresented: $navigateToCalendar) {
                CalendarView()
            }
            .navigationDestination(isPresented: $navigateToSettings) {
                SettingsView(/*isLoggedIn: $isLoggedIn*/)
            }
        }
    }
}

// Reusable Transaction Cell View
struct TransactionCellView: View {
    var transaction: Transaction
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(transaction.title ?? "Unknown")
                    .font(.headline)
                Text(transaction.date ?? Date(), style: .date)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            Text("$\(transaction.amount, specifier: "%.2f")")
                .font(.subheadline)
                .foregroundColor(transaction.amount < 0 ? .red : .green)
        }
    }
}
