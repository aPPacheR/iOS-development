//
//  ContentView.swift
//  MultiplyMaster
//
//  Created by Павленко Павел on 18.11.2025.
//

import SwiftUI

struct ContentView: View {
    @State private var countTables = 2
    @State private var countQuestons = [5, 10, 15, 20]
    @State private var finalCountQuestions = 5
    @State private var move = 0
    
    @State private var firstValue = 2
    @State private var secondValue = 2
    @State private var correctAnswer = 4
    @State private var answer: Int? = nil
    
    @State private var isGameStarted = false
    
    @State private var score = 0
    @State private var isCorrect = false
    @State private var showingAlert = false
    
    @FocusState private var amountIsFocused: Bool
    
    struct AnswerItem: Identifiable {
        let id = UUID()
        let text: String
        var color: Color = .clear
    }
    
    @State var answers: [AnswerItem] = []

    
    var body: some View {
        NavigationStack{
            ZStack{
                LinearGradient(colors: [.blue, .red], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                VStack{
                    if !isGameStarted {
                        Spacer()
                        Text("Multiply Master")
                            .font(.largeTitle.weight(.bold))
                            .foregroundStyle(.white)
                        
                        VStack(spacing: 20) {
                            VStack(spacing: 10) {
                                Text("Настройки игры")
                                    .font(.title2.weight(.bold))
                                    .foregroundStyle(.secondary)
                                
                                Stepper("Таблицы умножения До: \(countTables)", value: $countTables, in: 2...12)
                                    .padding()
                                    .font(.headline.weight(.bold))
                                    .foregroundStyle(.secondary)
                            }
                            
                            
                            VStack() {
                                Text("Количество вопросов:")
                                    .font(.headline.weight(.bold))
                                    .foregroundStyle(.secondary)
                                
                                Picker("", selection: $finalCountQuestions){
                                    ForEach(countQuestons, id: \.self){
                                        Text($0, format: .number)
                                    }
                                }
                                .pickerStyle(.segmented)
                                //.padding()
                            }
                        }
                        .padding()
                        .background(.regularMaterial)
                        .clipShape(.rect(cornerRadius: 20))
                        .padding()
                        
                        Button("Начать игру", action: startGame)
                            .font(.title.weight(.bold))
                            .foregroundStyle(.secondary)
                            .padding()
                            .background(.regularMaterial)
                            .clipShape(.rect(cornerRadius: 15))
                    }
                    
                    if isGameStarted{
                        HStack() {
                            Text("\(firstValue) * \(secondValue) =")
                                .font(.title.weight(.bold))
                                .foregroundStyle(.secondary)
                            
                            TextField("Ваш ответ", value: $answer, format: .number)
                                .keyboardType(.numberPad)
                                .focused($amountIsFocused)
                                .font(.title.weight(.bold))
                                .foregroundStyle(.secondary)
                        }
                        .padding()
                        .background(.regularMaterial)
                        .clipShape(.rect(cornerRadius: 20))
                        .padding()
                        
                        
                        ScrollView {
                            ForEach(Array(answers.enumerated()), id: \.offset) { index, item in
                                HStack {
                                    Image(systemName: "\(answers.count - index).circle")
                                        .foregroundStyle(.white)
                                    Text(item.text)
                                        .font(.title.weight(.bold))
                                        .foregroundStyle(.white)
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(item.color)
                                .clipShape(.rect(cornerRadius: 20))
                            }
                        }
                        .padding()
                    }
                    Spacer()
                    Spacer()
                }
                
            }
            .onSubmit(newQuestion)
            .toolbar{
                if isGameStarted{
                    Button("Новая игра"){
                        withAnimation{
                            isGameStarted = false
                        }
                    }
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.white)
                        
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    HStack{
                        if amountIsFocused {
                            Button("Готово") {
                                amountIsFocused = false
                                newQuestion()
                            }
                        }
                        
                        Spacer()
                        Button("Дальше", action: newQuestion)
                    }
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.secondary)
                }
            }
            .alert("Игра окончена", isPresented: $showingAlert){
                Button("Новая игра") {
                    withAnimation{
                        isGameStarted = false
                        showingAlert = false
                    }
                }
            } message: {
                Text("Твой результат - \(score) из \(finalCountQuestions) правильных ответов")
            }
        }
    }
    
    func startGame() {
        withAnimation {
            isGameStarted = true
        }

        answers = []
        score = 0
        move = 0

        firstValue = Int.random(in: 2...countTables)
        secondValue = Int.random(in: 1...12)
        correctAnswer = firstValue * secondValue
        answer = nil
    }

    
    func newQuestion(){
        let text = "\(firstValue) * \(secondValue) = \(answer ?? 0)"
        let isRight = (answer == correctAnswer)
        
        if isRight {
            score += 1
        }
        
        let color: Color = isRight ? .green : .red
        let newItem = AnswerItem(text: text, color: color)

        withAnimation{
            answers.insert(newItem, at: 0)
        }

        move += 1
        if move == finalCountQuestions{
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation {
                    showingAlert = true
                }
            }
        }
        firstValue = Int.random(in: 2...countTables)
        secondValue = Int.random(in: 1...9)
        correctAnswer = firstValue * secondValue
        answer = nil
    }

}

#Preview {
    ContentView()
}
