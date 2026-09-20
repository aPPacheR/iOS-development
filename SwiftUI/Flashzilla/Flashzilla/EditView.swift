//
//  EditView.swift
//  Flashzilla
//
//  Created by Павленко Павел on 01.02.2026.
//

import SwiftData
import SwiftUI

struct EditView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @Query(sort: \Card.prompt, order: .forward) var cards: [Card]
    
    @State private var newPrompt = ""
    @State private var newAnswer = ""
    
    var body: some View {
        NavigationStack {
            List {
                Section("Новая карточка") {
                    TextField("Вопрос", text: $newPrompt)
                    TextField("Ответ", text: $newAnswer)
                    Button("Добавить карточку", action: addCard)
                }
                
                Section("Карточки") {
                    ForEach(cards, id: \.id) { card in
                        VStack(alignment: .leading) {
                            Text(card.prompt)
                                .font(.headline)
                            Text(card.answer)
                                .foregroundColor(.secondary)
                        }
                    }
                    .onDelete(perform: removeCards)
                }
            }
            .navigationTitle("Редактирование карточек")
            .toolbar {
                Button("Сохранить", action: done)
            }
        }
        .ignoresSafeArea(.all) // Игнорируем ограничения
    }
    
    func done() {
        dismiss()
    }
    

    func addCard() {
        let trimmedPrompt = newPrompt.trimmingCharacters(in: .whitespaces)
        let trimmedAnswer = newAnswer.trimmingCharacters(in: .whitespaces)
        guard trimmedPrompt.isEmpty == false && trimmedAnswer.isEmpty == false else { return }

        let card = Card(prompt: trimmedPrompt, answer: trimmedAnswer)
        modelContext.insert(card)
        
        do {
            try modelContext.save()
        } catch {
            print("Ошибка сохранения: \(error)")
        }
        
        newPrompt = ""
        newAnswer = ""
    }

    func removeCards(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(cards[index])
        }
    }

    
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Card.self, configurations: config)
        
        let card = Card(prompt: "Тест", answer: "Ответ")
        container.mainContext.insert(card)
        
        return EditView()
            .modelContainer(container)
    } catch {
        return Text("Ошибка создания превью: \(error.localizedDescription)")
    }
}
