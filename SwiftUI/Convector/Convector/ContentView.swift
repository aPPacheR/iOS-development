//
//  ContentView.swift
//  Convector
//
//  Created by Павленко Павел on 09.11.2025.
//

import SwiftUI

struct ContentView: View {
    @State private var startingUnit = "seconds"
    @State private var theLastUnit = "minutes"
    @State private var value = 0

    // массив
    let unitsOfMeasurement = ["seconds", "minutes", "hours", "days"]
    
    
    var theResult: String{
        var valueInSeconds = 0.0
        var result = 0.0
        if startingUnit == "seconds"{
            valueInSeconds = Double(value)
        } else if startingUnit == "minutes"{
            valueInSeconds = Double(value) * 60
        } else if startingUnit == "hours"{
            valueInSeconds = Double(value) * 3600
        } else if startingUnit == "days"{
            valueInSeconds = Double(value) * 86400
        } else {
            valueInSeconds = Double(value)
        }
        
        if theLastUnit == "seconds"{
            result = valueInSeconds
        } else if theLastUnit == "minutes"{
            result = valueInSeconds / 60
        } else if theLastUnit == "hours"{
            result = valueInSeconds / 3600
        } else if theLastUnit == "days"{
            result = valueInSeconds / 86400
        } else {
            result = valueInSeconds
        }
        
        if result == Double(Int(result)) {
            return "\(Int(result))"
        } else {
            return String(format: "%.2f", result)
        }
        
    }
    
    var body: some View {
        NavigationStack{
            Form{
                Section("Enter your details"){
                    TextField("Amount", value: $value, format: .number)
                        .keyboardType(.decimalPad)
                }
                Section("Select the initial data"){
                    Picker("The first", selection: $startingUnit){
                        ForEach(unitsOfMeasurement, id: \.self){
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                Section("Select the final data"){
                    Picker("The first", selection: $theLastUnit){
                        ForEach(unitsOfMeasurement, id: \.self){
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                Section("Results"){
                    Text("\(value) \(startingUnit) = \(theResult) \(theLastUnit)")
                }
            }
            .navigationTitle("Convector")
        }
    }
}

#Preview {
    ContentView()
}
