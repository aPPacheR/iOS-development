//
//  CardView.swift
//  Flashzilla
//
//  Created by Павленко Павел on 31.01.2026.
//

import SwiftData
import SwiftUI

struct CardView: View {
    var card: Card
    
    @State private var isShowingAnswer = false
    @State private var offset = CGSize.zero
    
    var removal: ((Bool) -> Void)? = nil
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 25)
                .fill(
                    .white
                        .opacity(1 - Double(abs(offset.width / 50)))
                )
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(offset.width > 0 ? .green : .red)
                )
                .shadow(radius: 10)
            
            VStack {
                Text(card.prompt)
                    .font(.largeTitle)
                    .foregroundColor(.black)
                
                if isShowingAnswer {
                    Text(card.answer)
                        .font(.title)
                        .foregroundColor(.secondary)
                }
            }
            .padding(20)
            .multilineTextAlignment(.center)
        }
        .frame(width: 450, height: 250)
        .rotationEffect(.degrees(offset.width / 5.0))
        .offset(x: offset.width * 5)
        .opacity(2 - Double(abs(offset.width / 50)))
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    offset = gesture.translation
                }
                .onEnded { _ in
                    if abs(offset.width) > 100 {
                        let isCorrect = offset.width > 0
                        removal?(isCorrect)
                    } else {
                        offset = .zero
                    }
                }
        )
        .onTapGesture {
            isShowingAnswer.toggle()
        }
        .animation(.default, value: offset)
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Card.self, configurations: config)
        
        let card = Card(prompt: "What is my name?", answer: "Pavel")
        return CardView(card: card)
            .modelContainer(container)
    } catch {
        return Text("Error: \(error.localizedDescription)")
    }
}
