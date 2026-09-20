//
//  HabitView.swift
//  HabitTracker
//
//  Created by Павленко Павел on 25.11.2025.
//

import SwiftUI

struct HabitView: View {
    @Environment(\.dismiss) var dismiss

    var habitTrack: HabitTrack
    var habit: Habit

    
    var body: some View {
        ScrollView {
            Text("Подробное описание")
                .font(.title.weight(.heavy))
                .foregroundStyle(.white)
            VStack(){
                HStack() {
                    Text("Название:")
                        .font(.headline.weight(.bold))
                    Text(habit.name)
                        .font(.headline.weight(.heavy))
                }
                .foregroundColor(.secondary)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.white)
                .clipShape(.rect(cornerRadius: 15))
                .padding(.horizontal)
                
                HStack() {
                    Text("Описание:")
                        .font(.headline.weight(.bold))
                    Text(habit.description)
                        .font(.headline.weight(.heavy))

                }
                .font(.headline.weight(.heavy))
                .foregroundColor(.secondary)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.white)
                .clipShape(.rect(cornerRadius: 15))
                .padding(.horizontal)
                
                HStack() {
                    Text("Кол-во повторений:")
                        .font(.headline.weight(.bold))
                    Text(String(habit.repetitions))
                        .font(.headline.weight(.heavy))

                }
                .font(.headline.weight(.heavy))
                .foregroundColor(.secondary)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.white)
                .clipShape(.rect(cornerRadius: 15))
                .padding(.horizontal)
                
                Button(role: .destructive) {
                    if let index = habitTrack.habits.firstIndex(where: { $0.id == habit.id }){
                        habitTrack.habits.remove(at: index)
                    }
                    dismiss()
                } label: {
                    Text("Удалить привычку")
                        .font(.headline.weight(.bold))
                        .foregroundColor(.red)
                        .frame(maxWidth: 200)
                        .padding()
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .padding()
                }

                
            }
        }
        .background(LinearGradient(gradient: Gradient(colors: [.indigo,.mint]), startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea())
        .preferredColorScheme(.light)
    }
    
}

#Preview {
    let habitTest = Habit(id: UUID(), name: "Play sports", description: "Exercise every day", repetitions: 5)
    let habitTrackTest = HabitTrack()
    habitTrackTest.habits = [habitTest] // добавляем тестовую привычку
    return HabitView(habitTrack: habitTrackTest, habit: habitTest)
}
