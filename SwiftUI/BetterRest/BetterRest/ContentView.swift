//
//  ContentView.swift
//  BetterRest
//
//  Created by Павленко Павел on 17.11.2025.
//

import CoreML
import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 0
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? .now
    }
    
    var idealSleepTime: String {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)

            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            
            return sleepTime.formatted(date: .omitted, time: .shortened)
            
        } catch {
            return "Sorry, there was a problem calculating your bedtime."
        }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("When do you want to wake up?"){
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
                
                Section("Desired amount of sleep") {
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 1...15, step: 0.25)
                }
                
                Section("Daile coffee intake") {
                    Picker("Amount coffee", selection: $coffeeAmount){
                        ForEach(0..<10) { number in
                            Text("^[\(number) cup](inflect: true)")
                        }
                    }
                }
                VStack(alignment: .leading, spacing: 0){
                    Text("Your ideal bedtime is ") +
                    
                    Text("\(idealSleepTime)")
                        .font(.title2.weight(.bold))
                }
            }
            .navigationTitle("BetterRest")
        }
    }
}

#Preview {
    ContentView()
}
