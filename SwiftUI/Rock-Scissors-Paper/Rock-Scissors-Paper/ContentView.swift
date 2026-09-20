//
//  ContentView.swift
//  Rock-Scissors-Paper
//
//  Created by Павленко Павел on 14.11.2025.
//

import SwiftUI

struct ContentView: View {
    
    @State private var statesOfGame = ["Rock", "Scissors", "Paper"]
    @State private var programSelection = Int.random(in: 0..<3)
    @State private var programBoolFinal = Bool.random()
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var scoreMessage = ""
    @State private var totalScore = 0
    
    @State private var showingFinalScore = false
    @State private var numberOfMoves = 0


    
    var programFinal: String{
        if programBoolFinal {
            return "Win"
        } else {
            return "Lose"
        }
    }
    
    var body: some View {
        ZStack{
            LinearGradient(colors: [.indigo, .black], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack(spacing: 30){
                Spacer()
                Spacer()

                Text("Rock-Scissors-Paper")
                    .font(.largeTitle.weight(.bold))
                    .foregroundColor(.white)
                    .shadow(color: .black, radius: 2, x: 2, y: 2)
                
                Spacer()
                
                VStack(spacing: 20){
                    Text("App's move:")
                        .font(.title2.weight(.semibold))
                        .foregroundColor(.secondary)
                    
                    Text("\(statesOfGame[programSelection])")
                        .font(.system(size: 50, weight: .heavy))
                        .foregroundColor(.primary)

                    Text("and")
                        .font(.title2.weight(.semibold))
                        .foregroundColor(.secondary)
                    
                    Text("\(programFinal)")
                        .font(.system(size: 40, weight: .black))
                        .padding()
                        .background(programBoolFinal ? .green : .red)
                        .clipShape(RoundedRectangle(cornerRadius: 25))

                }
                .padding()
                .padding()
                .frame(maxWidth: .infinity)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                .padding(.horizontal)
                
                
                VStack(spacing: 20){
                    Text("Select your move:")
                        .font(.title2.weight(.semibold))
                        .foregroundColor(.white)

                    HStack(spacing: 10){
                        ForEach(0..<3){ number in
                            Button {
                                buttonTapped(number)
                            } label: {
                                VStack{
                                    Text("\(statesOfGame[number])")
                                        .font(.title3.weight(.medium))
                                        .foregroundColor(.primary)
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(.regularMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                            }
                        }
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                VStack{
                    Text("Score: \(totalScore)")
                        .font(.title2.weight(.bold))
                        .foregroundColor(.white)
                        .padding()
                        .background(Capsule().fill(.ultraThinMaterial))

                }
                Spacer()

            }
        }
        .alert(scoreTitle, isPresented: $showingScore){
            Button("Continue", action: continueGame)
        } message: {
            Text(scoreMessage)
        }
        
        .alert("The game is over", isPresented: $showingFinalScore){
            Button("Reset"){
                totalScore = 0
                continueGame()
            }
        } message: {
            Text("Your final score: \(totalScore)")
        }
    }
    
    func buttonTapped(_ number: Int) {
        if statesOfGame[programSelection] == "Rock"{
            if programBoolFinal == true && statesOfGame[number] == "Scissors"{
                scoreTitle = "Correct!"
                totalScore += 1
                scoreMessage = "Yeah, you're right!"
            } else if programBoolFinal == false && statesOfGame[number] == "Paper"{
                scoreTitle = "Correct!"
                totalScore += 1
                scoreMessage = "Yeah, you're right!"
            } else {
                scoreTitle = "Wrong!"
                scoreMessage = "You made the wrong choice."
            }
        } else if statesOfGame[programSelection] == "Scissors"{
            if programBoolFinal == true && statesOfGame[number] == "Paper"{
                scoreTitle = "Correct!"
                totalScore += 1
                scoreMessage = "Yeah, you're right!"
            } else if programBoolFinal == false && statesOfGame[number] == "Rock"{
                scoreTitle = "Correct!"
                totalScore += 1
                scoreMessage = "Yeah, you're right!"
            } else {
                scoreTitle = "Wrong!"
                scoreMessage = "You made the wrong choice."
            }
        } else {
            if programBoolFinal == true && statesOfGame[number] == "Rock"{
                scoreTitle = "Correct!"
                totalScore += 1
                scoreMessage = "Yeah, you're right!"
            } else if programBoolFinal == false && statesOfGame[number] == "Scissors"{
                scoreTitle = "Correct!"
                totalScore += 1
                scoreMessage = "Yeah, you're right!"
            } else {
                scoreTitle = "Wrong!"
                scoreMessage = "You made the wrong choice."
            }
        }
        numberOfMoves += 1
        showingScore = true
        
        if numberOfMoves == 10 {
            showingFinalScore = true
            numberOfMoves = 0
        }
    }
    
    func continueGame() {
        programSelection = Int.random(in: 0..<3)
        programBoolFinal = Bool.random()
    }
}

#Preview {
    ContentView()
}
