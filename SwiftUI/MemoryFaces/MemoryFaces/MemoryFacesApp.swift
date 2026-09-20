//
//  MemoryFacesApp.swift
//  MemoryFaces
//
//  Created by Павленко Павел on 26.01.2026.
//

import SwiftUI
import SwiftData

@main
struct MemoryFacesApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: Person.self) // ← ДОБАВИТЬ эту строку
        }
    }
}
