//
//  ContentView.swift
//  iExpense
//
//  Created by Павленко Павел on 21.11.2025.
//

import SwiftUI

struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}

@Observable
class Expenses {
    var items = [ExpenseItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "items")
            }
        }
    }
    
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "items") {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                items = decodedItems
                return
            }
        }
        items = []
    }
    
}

struct ContentView: View {
    @State private var expenses = Expenses()
    
    @State private var showingAddExpense = false
    
    var body: some View {
        NavigationStack {
            List {
                Section("Personal") {
                    ForEach(expenses.items) { item in
                        if item.type == "Personal" {
                            HStack {
                                VStack(alignment: .leading){
                                    Text(item.name)
                                        .font(.title2.weight(.bold))
                                    
                                    Text(item.type)
                                }
                                
                                Spacer()
                                
                                Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                    .font(.title)
                            }
                        }
                    }
                    .onDelete(perform: removeItems)
                }
                
                Section("Business") {
                    ForEach(expenses.items) { item in
                        if item.type == "Business" {
                            HStack {
                                VStack(alignment: .leading){
                                    Text(item.name)
                                        .font(.title2.weight(.bold))

                                    Text(item.type)
                                }
                                
                                Spacer()
                                
                                Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                    .font(.title)

                            }
                        }
                    }
                    .onDelete(perform: removeItems)
                        
                }
            }
            .navigationTitle("iExpense")
            .toolbar{
                Button("Add expense", systemImage: "plus") { showingAddExpense = true }
            }
            .sheet(isPresented: $showingAddExpense) {
                AddView(expenses: expenses)
            }
        }
    }
    
    func removeItems(at offset: IndexSet) {
        expenses.items.remove(atOffsets: offset)
    }
}

#Preview {
    ContentView()
}
