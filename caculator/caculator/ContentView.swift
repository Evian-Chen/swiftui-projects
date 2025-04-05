//
//  ContentView.swift
//  caculator
//
//  Created by Evian-Chen on 2025/2/20.
//

import SwiftUI

struct operatorBtnStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 20))
            .fontWeight(.heavy)
            .frame(width: 50, height: 50, alignment: .center)
            .foregroundColor(.white) // Text color
            .background(Color.orange) // Background color of the square
            .cornerRadius(10) // Optional: Round the corners of the square
    }
}

struct numberBtnStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 40))
            .fontWeight(.heavy)
            .frame(width: 50, height: 50, alignment: .center)
            .foregroundColor(.white) // Text color
            .background(Color.blue) // Background color of the square
            .cornerRadius(10) // Optional: Round the corners of the square
    }
}

struct ContentView: View {
    @State private var result : String = "0.0"
    @State private var operator0 = false  // if operator is clicked
    @State private var operatorType = ""  // current using operator
    @State private var isFloating = false // if it's floating (if . is clicked)
    
    @State private var op1 = 0.0  // first number
    @State private var op2 = 0.0  // second number
    {}
    var body: some View {
        VStack {
            Text(result)
                .fontWeight(.heavy)
                .font(.system(size: 25))
                .padding()
            HStack {
                Button("÷") {
                    op1 = Double(result)!
                    operator0 = true
                    operatorType = "÷"
                }
                .buttonStyle(operatorBtnStyle())

                Button("x") {
                    op1 = Double(result)!
                    operator0 = true
                    operatorType = "x"
                }
                .buttonStyle(operatorBtnStyle())
                Button("+") {
                    op1 = Double(result)!
                    operator0 = true
                    operatorType = "+"
                }
                .buttonStyle(operatorBtnStyle())
                Button("-") {
                    op1 = Double(result)!
                    operator0 = true
                    operatorType = "-"
                }
                .buttonStyle(operatorBtnStyle())
            }
            HStack {
                Button("%") {
                    /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/
                }
                .buttonStyle(operatorBtnStyle())
                Button("1") {
                    if (result == "0.0" || operator0) {
                        result = "1"
                        operator0 = false
                    } else {
                        result += "1"
                    }
                }
                .buttonStyle(numberBtnStyle())
                Button("2") {
                    if (result == "0.0" || operator0) {
                        result = "2"
                        operator0 = false
                    } else {
                        result += "2"
                    }
                }
                .buttonStyle(numberBtnStyle())
                Button("3") {
                    if (result == "0.0" || operator0) {
                        result = "3"
                        operator0 = false
                    } else {
                        result += "3"
                    }
                }
                .buttonStyle(numberBtnStyle())
            }
            HStack {
                Button("√") {
                    op1 = Double(result)!
                    result = String(sqrt(op1))
                }
                .buttonStyle(operatorBtnStyle())
                Button("4") {
                    if (result == "0.0" || operator0) {
                        result = "4"
                        operator0 = false
                    } else {
                        result += "4"
                    }
                }
                .buttonStyle(numberBtnStyle())
                Button("5") {
                    if (result == "0.0" || operator0) {
                        result = "5"
                        operator0 = false
                    } else {
                        result += "5"
                    }
                }
                .buttonStyle(numberBtnStyle())
                Button("6") {
                    if (result == "0.0" || operator0) {
                        result = "6"
                        operator0 = false
                    } else {
                        result += "6"
                    }
                }
                .buttonStyle(numberBtnStyle())
            }
            HStack {
                Button("±") {
                    op1 = Double(result)!
                    result = String(-op1)
                }
                .buttonStyle(operatorBtnStyle())
                Button("7") {
                    if (result == "0.0" || operator0) {
                        result = "7"
                        operator0 = false
                    } else {
                        result += "7"
                    }
                }
                .buttonStyle(numberBtnStyle())
                Button("8") {
                    if (result == "0.0" || operator0) {
                        result = "8"
                        operator0 = false
                    } else {
                        result += "8"
                    }
                }
                .buttonStyle(numberBtnStyle())
                Button("9") {
                    if (result == "0.0" || operator0) {
                        result = "9"
                        operator0 = false
                    } else {
                        result += "9"
                    }
                }
                .buttonStyle(numberBtnStyle())
            }
            HStack {
                Button("AC") {
                    result = "0.0"
                    operator0 = false
                    isFloating = false
                }
                .buttonStyle(operatorBtnStyle())
                Button(".") {
                    if (!isFloating || operator0) {
                        result += "."
                        isFloating = true
                    }
                }
                .buttonStyle(numberBtnStyle())
                Button("0") {
                    if (result == "0.0" || operator0) {
                        result = "0"
                        operator0 = false
                    } else {
                        result += "0"
                    }
                }
                .buttonStyle(numberBtnStyle())
                Button("=") {
                    op2 = Double(result)!
                    switch(operatorType) {
                    case "+":
                        result = String(op1 + op2)
                    case "-":
                        result = String(op1 - op2)
                    case "x":
                        result = String(op1 * op2)
                    case "÷":
                        result = String(op1 / op2)
                    case "%":
                        result = String(Double(Int(op1) % Int(op2)))
                    default:
                        break
                    }
                    
                    operator0 = false
                    operatorType = ""
                    
                }
                .buttonStyle(operatorBtnStyle())
            }
        }
        .padding(.top, 2.0)
    }
}

#Preview {
    ContentView()
}
