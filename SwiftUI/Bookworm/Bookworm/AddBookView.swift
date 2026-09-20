//
//  AddBookView.swift
//  Bookworm
//
//  Created by Павленко Павел on 28.11.2025.
//

import SwiftData
import SwiftUI

struct AddBookView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var author = ""
    @State private var genre = "Fantasy"
    @State private var review = ""
    @State private var rating = 3
    @State private var date = Date.now
    
    let genres = ["Fantasy", "Horror", "Kids", "Mystery", "Poetry", "Romance", "Thriller"]

    
    var body: some View {
        NavigationStack {
            Form  {
                Section {
                    TextField("Name of book", text: $title)
                    TextField("Author's name", text: $author)
                    
                    Picker("Genre", selection: $genre) {
                        ForEach(genres, id: \.self) {
                            Text($0)
                        }
                    }
                }
                
                Section("Write a review") {
                    TextEditor(text: $review)
                    RatingView(rating: $rating)
                }
                
                Section {
                    DatePicker(
                        "Date of reading",
                        selection: $date,
                        in: ...Date.now,
                        displayedComponents: .date)

                }
                
                Section {
                    Button("Save") {
                        let newBook = Book(title: title, author: author, genre: genre, review: review, rating: rating, date: date)
                        modelContext.insert(newBook)
                        dismiss()
                    }
                    .disabled(title.isEmpty)
                }
            }
            .navigationTitle("Add book")
        }
    }
    
}

#Preview {
    AddBookView()
        .modelContainer(for: Book.self, inMemory: true)

}
