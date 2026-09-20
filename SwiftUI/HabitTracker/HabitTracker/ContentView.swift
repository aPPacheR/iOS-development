//
//  ContentView.swift
//  HabitTracker
//
//  Created by Павленко Павел on 25.11.2025.
//

import SwiftUI

struct Habit: Codable, Identifiable {
    var id: UUID
    let name: String
    let description: String
    var repetitions: Int
}

@Observable
class HabitTrack {
    var habits = [Habit]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(habits) {
                UserDefaults.standard.setValue(encoded, forKey: "habits")
            }
        }
    }
    
    init() {
        if let savedHabits = UserDefaults.standard.data(forKey: "habits") {
            if let decodedHabits = try? JSONDecoder().decode([Habit].self, from: savedHabits) {
                habits = decodedHabits
                return
            }
        }
        habits = []
    }
}


struct ContentView: View {
    
    @State private var habitTrack = HabitTrack()
        
    @State private var showingAddView = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                Text("Трекер привычек")
                    .font(.title.weight(.heavy))
                    .foregroundStyle(.white)
                ForEach($habitTrack.habits) { $habit in
                    VStack{
                        NavigationLink{
                            HabitView(habitTrack: habitTrack, habit: habit)
                        } label: {
                            VStack{
                                Text(habit.name)
                            }
                            .frame(maxWidth: .infinity)
                            .font(.title2.weight(.heavy))
                        }
                        Stepper("Кол-во повторений: \(habit.repetitions)", value: $habit.repetitions, in: 0...100)
                            .font(.headline.weight(.heavy))
                    }
                    .foregroundColor(.secondary)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.white)
                    .clipShape(.rect(cornerRadius: 15))
                    .padding()

                }

            }
            .frame(maxWidth: .infinity)
            .background(LinearGradient(gradient: Gradient(colors: [.indigo,.mint]), startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea())
            .preferredColorScheme(.light)
            .toolbar {
                Button() {
                    showingAddView = true
                } label: {
                    Image(systemName: "plus")
                        .font(.title2)
                        .foregroundColor(.white)
                }
            }
            
            .sheet(isPresented: $showingAddView) {
                AddView(habitTrack: habitTrack)
            }
        }
    }
    
}

#Preview {
    ContentView()
}
