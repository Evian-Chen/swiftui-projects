//
//  ContentView.swift
//  ViewPractice
//
//  Created by Mac25 on 2025/3/12.
//

import SwiftUI

// Identifiable: 可用 UUID
// Codable: 可用內建的 JSON 解碼編碼
struct ExpenseItem: Identifiable, Codable {
    var id = UUID()  // id 使用 '=' 而不是 ':'
    let name: String
    let type: String
    let amount: Double
}

@Observable
class Expenses {
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") { // 看之前儲存的資料
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                items = decodedItems
                return
            }
        }
        items = []
    }
    
    var items = [ExpenseItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
}

struct ContentView: View {
    @State private var showingAddExpense = false
    @State private var expenses = Expenses()  // class 的 Object
    
    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(expenses.items) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.name).font(.headline)
                            Text(item.type)
                        }
                        Spacer()
                        Text(item.amount, format: .currency(code: "USD"))
                    }
                }
                .onDelete(perform: removeItems)
            }
            .navigationTitle("iExpense")
            .toolbar {
                Button("Add Expense", systemImage: "plus") {
                    showingAddExpense = true
                }
                .sheet(isPresented: $showingAddExpense) {
                    AddView(expenses: expenses)  // 把 class 本身傳進去 (call by reference)
                } // 點擊 Button 就會跳出 AddView()
            }
        } // Navihgation
        
    }
}

#Preview {
    ContentView()
}
