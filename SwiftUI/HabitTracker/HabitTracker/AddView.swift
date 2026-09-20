//
//  AddView.swift
//  HabitTracker
//
//  Created by Павленко Павел on 25.11.2025.
//

import SwiftUI

struct AddView: View {
    @Environment(\.dismiss) var dismiss
        
    @State private var name = ""
    @State private var description = ""
    @State private var repetitions = 0
    
    var habitTrack: HabitTrack

    
    
    var body: some View {
        NavigationStack {
            ScrollView {
                Spacer()
                Spacer()

                Spacer()

                Text("Новая привычка")
                    .font(.title.weight(.heavy))
                    .foregroundStyle(.white)
                VStack(){
                    HStack() {
                        Text("Название:")
                            .font(.headline.weight(.bold))
                        TextField("...", text: $name)
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
                        TextField("...", text: $description)                        .font(.headline.weight(.heavy))
                        
                    }
                    .font(.headline.weight(.heavy))
                    .foregroundColor(.secondary)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.white)
                    .clipShape(.rect(cornerRadius: 15))
                    .padding(.horizontal)
                    
                    HStack() {
                        Text("Кол-во повторений: \(repetitions)")
                            .font(.headline.weight(.bold))
                        Spacer()
                        Stepper("\(repetitions)", value: $repetitions, in: 0...100)
                            .font(.headline.weight(.heavy))
                            .labelsHidden()
                        
                    }
                    .font(.headline.weight(.heavy))
                    .foregroundColor(.secondary)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.white)
                    .clipShape(.rect(cornerRadius: 15))
                    .padding(.horizontal)
                    
                    Button {
                        let habit = Habit(id: UUID(), name: name, description: description, repetitions: repetitions)
                        habitTrack.habits.append(habit)
                        dismiss()
                    } label: {
                        Text("Cохранить")
                            .font(.headline.weight(.bold))
                            .foregroundColor(.cyan)
                            .frame(maxWidth: 150)
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
}

#Preview {
    AddView(habitTrack: HabitTrack())
}
