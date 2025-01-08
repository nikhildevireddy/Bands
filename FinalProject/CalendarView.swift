//
//  CalendarView.swift
//  FinalProject
//
//  Created by Nikhil Devireddy on 12/1/24.
//

import SwiftUI

struct CalendarView: View {
    // Fetches the Transactions from CoreData by their date in ascending order
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Transaction.date, ascending: true)],
        animation: .default)
    private var transactions: FetchedResults<Transaction>

    @State private var selectedDate = Date()

    var body: some View {
        VStack {
            // Calendar view
            DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()

            List {
                // In a list, retrieves transactions whose date matches the current date picked in the calendar above
                ForEach(transactions.filter { Calendar.current.isDate($0.date ?? Date(), inSameDayAs: selectedDate) }) { transaction in
                    HStack {
                        Text(transaction.title ?? "Unknown")
                        Spacer()
                        Text("$\(transaction.amount, specifier: "%.2f")")
                            .foregroundColor(transaction.amount > 0 ? .green : .red)
                    }
                }
            }
        }
        .navigationTitle("Calendar")
    }
}


#Preview {
    CalendarView()
}
