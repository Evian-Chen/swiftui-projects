//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Mac25 on 2025/2/27.
//

import SwiftUI

struct GameWonView: View {
    var restartGame: () -> Void
    
    var body: some View {
        VStack {
            Text("Congratulations!")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("You are a country master!")
                .font(.title2)
                .padding(.bottom, 20)
            
            Button("Restart Game") {
                restartGame()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .clipShape(Capsule())
        }
        .padding()
    }
}

struct ContentView: View {
    @State private var showAlert = false
    @State private var scoreTitle = ""
    @State var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    let colors: [Color] = [.red, .orange, .blue, .green, .purple, .black, .gray]
    @State var correctAnswer = Int.random(in: 0...2)
    @State private var score = 0
    let winningScore = 2
    @State private var endGame = false
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct :Db"
            score += 1
            print("current score: \(score), winningScore: \(winningScore)")
        } else {
            scoreTitle = "Wrong :("
        }
        
        // Check if the score reaches the winning score after every flag tap
        if score >= winningScore {
            endGame = true // Trigger the transition to the next screen
        } else {
            showAlert = true // Show the alert if the game is not yet won
        }
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    func restartGame() {
        score = 0
        endGame = false
        askQuestion()
    }
    
    var body: some View {
        NavigationStack {
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
                Button("OK") {
                    askQuestion()
                }
            } message: {
                Text("Your score is \(score)")
            }
            
            .navigationDestination(isPresented: $endGame) {
                GameWonView(restartGame: restartGame)
            }
        }
    }
}

#Preview {
    ContentView()
}
