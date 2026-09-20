//
//  ContentView.swift
//  Guess the Flag
//
//  Created by Павленко Павел on 10.11.2025.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var totalScore = 0
    @State private var numberOfMoves = 0
    
    @State private var showingScore = false
    @State private var showingFinalScore = false
    @State private var scoreTitle = ""
    @State private var scoreMessage = ""
    
    var body: some View {
        ZStack{
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 400)
                .ignoresSafeArea()
            VStack{
                Spacer()
                Text("Guess the Flag")
                    .font(.largeTitle.weight(.bold))
                    .foregroundStyle(.white)
                
                
                VStack(spacing: 15){
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                        
                    }
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            Image(countries[number])
                                .clipShape(.capsule)
                                .shadow(radius: 5)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                Spacer()
                Spacer()
                
                Text("Score: \(totalScore)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                Spacer()
            }
            .padding()
        }
        
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text(scoreMessage)
        }
        
        .alert("End of the game!", isPresented: $showingFinalScore) {
            Button("Reset", action: resetGame)
        } message: {
            Text("Your final score - \(totalScore)")
        }
        
    }
    func flagTapped(_ number: Int){
        if number == correctAnswer{
            scoreTitle = "Correct!"
            totalScore += 1
            scoreMessage = "Yeah, you're right!"
        } else {
            scoreTitle = "Wrong!"
            scoreMessage = "No, it's - \(countries[number])"
        }
        numberOfMoves += 1
        showingScore = true
        if numberOfMoves == 8{
            showingFinalScore = true
        }
    }
    
    func askQuestion(){
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    func resetGame(){
        askQuestion()
        totalScore = 0
        numberOfMoves = 0
    }
}

#Preview {
    ContentView()
}
