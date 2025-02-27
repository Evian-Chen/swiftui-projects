//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Mac25 on 2025/2/27.
//

import SwiftUI

struct GameWonView: View {
    var body: some View {
        VStack {
            Text("Congratulation!")
            Text("You are a country master!")
        }
        .padding()
    }
}

struct ContentView: View {
    @State private var showAlert = false
    @State private var scoreTitle = ""
    @State var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    var colors: [Color] = [.red, .orange, .blue, .green, .purple, .black, .gray]
    @State var correctAnswer = Int.random(in: 0...2)
    @State private var score = 0
    var winningScore = 2
    @State private var endGame = false
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct :Db"
            score += 1
            print("current score: \(score), winningScore: \(winningScore)")
        } else {
            scoreTitle = "Wrong :("
        }
        
        askQuestion()
        
        // Check if the score reaches the winning score after every flag tap
        if score == winningScore {
            endGame = true // Trigger the transition to the next screen
        } else {
            showAlert = true // Show the alert if the game is not yet won
        }
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 30) {
                // text stack
                VStack {
                    Text("Tap the flag of")
                    Text(countries[correctAnswer])
                        .font(.title)
                        .fontWeight(.black)
                        .foregroundColor(colors[correctAnswer % colors.count])
                }
                
                // flag buttons
                ForEach(0..<3) { number in
                    Button {
                        print(number, "tapped")
                        flagTapped(number)
                    } label: {
                        // button's look
                        Image(countries[number]).clipShape(.buttonBorder).shadow(radius: 7)
                    }
                }
            }
        }
        .alert(scoreTitle, isPresented: $showAlert) {
            Button(action: {
                if score == winningScore {
                    endGame = true
                }
            }) {}
        } message: {
            // Conditional message based on endGame
            Text(endGame ? "You win!" : "Your score is \(score)")
        }
        
        NavigationLink(destination: GameWonView(), isActive: $endGame) {
            EmptyView()
        }
    }
}

#Preview {
    ContentView()
}

