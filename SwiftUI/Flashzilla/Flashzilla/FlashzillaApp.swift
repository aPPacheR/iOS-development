//
//  FlashzillaApp.swift
//  Flashzilla
//
//  Created by Павленко Павел on 31.01.2026.
//

import SwiftData
import SwiftUI

@main
struct FlashzillaApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Card.self)
    }
}
