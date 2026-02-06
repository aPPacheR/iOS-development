//
//  ContentView.swift
//  DiceRoll
//
//  Created by Павленко Павел on 06.02.2026.
//

import SwiftUI

struct ContentView: View {
    @State private var diceFirst = Int.random(in: 1...6)
    @State private var diceSecond = Int.random(in: 1...6)
    
    @State private var isRolling = false
    @State private var currentDelay = 0.05
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.clear, .teal], startPoint: .bottom, endPoint: .top)
                .ignoresSafeArea()
            VStack {
                Spacer()
                Spacer()
                                
                HStack(spacing: 10) {
                    Text("\(diceFirst)")
                        .font(.largeTitle.weight(.bold))
                        .frame(width: 70, height: 70)
                        .background(.white)
                        .clipShape(.rect(cornerRadius: 10))
                        .shadow(radius: 10)
                    
                    Text("\(diceSecond)")
                        .font(.largeTitle.weight(.bold))
                        .frame(width: 70, height: 70)
                        .background(.white)
                        .clipShape(.rect(cornerRadius: 10))
                        .shadow(radius: 10)
                    
                }
                
                HStack {
                    Text("Total:")
                    if isRolling == true {
                        Text("...")
                    } else {
                        Text("\(diceFirst + diceSecond)")
                    }
                }
                .font(.title.weight(.bold))

                Spacer()
                
                Button("Roll the dice", action: rollDice)
                    .font(.title2.weight(.bold))
                    .foregroundColor(.white)
                    .padding()
                    .background(isRolling == false ? .teal : .gray)
                    .clipShape(.rect(cornerRadius: 10))
                    .allowsHitTesting(!isRolling)
                Spacer()
                Spacer()
                
            }
            .toolbar {
                Button("hello") {
                    
                }
                .foregroundColor(.white)
            }
        }
    }
    
    func rollDice() {
        isRolling = true
        currentDelay = 0.05
        continueRolling()
    }
    
    func continueRolling() {
        diceFirst = Int.random(in: 1...6)
        diceSecond = Int.random(in: 1...6)
        
        let impact = UIImpactFeedbackGenerator(style: .heavy)
        impact.impactOccurred()
        
        currentDelay += 0.075
        
        if currentDelay < 0.75 {
            DispatchQueue.main.asyncAfter(deadline: .now() + currentDelay) {
                continueRolling()
            }
        } else {
            let finalImpact = UIImpactFeedbackGenerator(style: .rigid)
            finalImpact.impactOccurred()
            isRolling = false
        }
    }

}

#Preview {
    ContentView()
}
