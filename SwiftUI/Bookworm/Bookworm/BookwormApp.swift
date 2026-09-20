//
//  BookwormApp.swift
//  Bookworm
//
//  Created by Павленко Павел on 28.11.2025.
//

import SwiftData
import SwiftUI

@main
struct BookwormApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: Book.self)
        }
    }
}



