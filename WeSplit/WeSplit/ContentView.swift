//
//  ContentView.swift
//  WeSplit
//
//  Created by Mac25 on 2025/2/26.
//

import SwiftUI

struct ContentView: View {
    @State private var checkAmount = 0.0
    @FocusState private var amountIsFocused: Bool
    @State private var numOfPeople = 2  // index
    @State private var tipPercentage = 20
    let tipPercentages = [10, 15, 20, 25, 0]
    
    var totalPerPerson: Double {
        let numPeople = Double(numOfPeople + 2)  // index 0 represents 2 people
        let tip = Double(tipPercentage)
        
        let tipAmount = checkAmount * (tip / 100)
        let total = checkAmount + tipAmount
        let amountPerPerson = total / numPeople
        
        return amountPerPerson
    }
    
    var body: some View {
        NavigationStack {
            Form {
                // Section for entering the amount and selecting the number of people
                Section(header: Text("Enter Amount")) {
                    TextField("Amount", value: $checkAmount, format:
                            .currency(code: Locale.current.currency?.identifier ?? "USD"))
                    Picker("Number of People", selection: $numOfPeople) {
                        ForEach(2..<10) {
                            Text("\($0) people")
                        }
                    }
                }
                .keyboardType(.decimalPad)  // only number can be input
                .focused($amountIsFocused)
                
                // Section for selecting the tip percentage
                Section("How much tip do you want to leave") {
                    Picker("Tip Percentage", selection: $tipPercentage) {
                        ForEach(tipPercentages, id: \.self) { percentage in
                            Text("\(percentage)%")
                        }
                    }
                }
                .pickerStyle(.segmented)
                .textCase(nil)
                
                // Section for displaying the formatted total amount
                Section {
                    Text(totalPerPerson, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                }
            }
            .navigationTitle("WeSplit")
            .toolbar {
                if amountIsFocused {
                    Button("Done") {
                        amountIsFocused = false
                    }
                }
            }
        }
        .padding(.bottom)
    }
}

#Preview {
    ContentView()
}
