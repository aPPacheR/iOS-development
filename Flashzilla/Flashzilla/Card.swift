//
//  Card.swift
//  Flashzilla
//
//  Created by Павленко Павел on 31.01.2026.
//

import SwiftData
import Foundation

@Model
class Card: Identifiable {
    var id: UUID
    var prompt: String
    var answer: String
    
    init(prompt: String, answer: String) {
        self.id = UUID()
        self.prompt = prompt
        self.answer = answer
    }
}
