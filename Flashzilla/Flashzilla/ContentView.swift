//
//  ContentView.swift
//  Flashzilla
//
//  Created by Павленко Павел on 31.01.2026.
//

import SwiftData
import SwiftUI

extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = Double(total - position)
        return self.offset(y: offset * 10)
    }
}

struct ContentView: View {
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.modelContext) var modelContext
    @Query() var allCards: [Card]
    @State private var cards: [Card] = []
    @State private var wrongCards: [Card] = []
    
    @State private var offset = CGSize.zero
    @State private var timeRemaining = 120
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State private var isActive = true
    @State private var showinEditView = false
    
    var body: some View {
        ZStack {
            Image(.background)
                .resizable()
                .ignoresSafeArea()
            VStack {
                Text("Time: \(timeRemaining)")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 5)
                    .background(.black.opacity(0.75))
                    .clipShape(.capsule)
                ZStack {
                    ForEach(0..<cards.count, id: \.self) { index in
                        CardView(card: cards[index]) { isCorrect in
                            withAnimation {
                                removeCard(at: index, isCorrect: isCorrect)
                            }
                        }
                        .stacked(at: index, in: cards.count)
                        .allowsHitTesting(index == cards.count - 1)
                    }
                }
                .allowsHitTesting(timeRemaining > 0 )
                
                if cards.isEmpty && wrongCards.isEmpty || timeRemaining == 0 {
                    Button("Начать заново", action: resetCards)
                        .padding()
                        .font(.title.weight(.bold))
                        .background(.black.opacity(0.75))
                        .foregroundColor(.white)
                        .shadow(radius: 10)
                        .clipShape(.capsule)
                        .padding()
                } else if cards.isEmpty && wrongCards.isEmpty == false {
                    Button("Повторить неизученные карты", action: resetAgain)
                        .padding()
                        .font(.title)
                        .background(.white)
                        .foregroundColor(.black)
                        .shadow(radius: 10)
                        .clipShape(.capsule)
                }
            }
            
            VStack {
                HStack {
                    Spacer()
                    Button {
                        showinEditView = true
                    } label: {
                        Image(systemName: "plus.circle")
                            .padding()
                            .background(.black.opacity(0.7))
                            .clipShape(.circle)
                    }
                }
                Spacer()
            }
            .padding()
            .foregroundColor(.white)
            .font(.largeTitle)
        }
        .onReceive(timer) { time in
            guard isActive else { return }
            
            if timeRemaining > 0 {
                timeRemaining -= 1
            }
        }
        
        .onChange(of: scenePhase) {
            if scenePhase == .active {
                if cards.isEmpty == false {
                    isActive = true
                }
            } else {
                isActive = false
            }
        }
        
        .sheet(isPresented: $showinEditView, onDismiss: resetCards, content: EditView.init)
        
        .onAppear(perform: resetCards)
        
    }
    
    func removeCard(at index: Int, isCorrect: Bool) {
        guard index >= 0 else { return }
        
        if isCorrect {
            cards.remove(at: index)
        } else {
            let wrongCard = cards.remove(at: index)
             wrongCards.append(wrongCard)
        }
        
        if cards.isEmpty {
            isActive = false
        }
    }
    
    func resetCards() {
        timeRemaining = cards.count > 0 ? 10 * cards.count : 120
        cards = allCards.shuffled()
        isActive = true
    }
    
    func resetAgain() {
        cards = wrongCards
        wrongCards = []
        timeRemaining = cards.count > 0 ? 10 * cards.count : 120
        isActive = true
    }
}

#Preview {
    ContentView()
}
