//
//  ContentView.swift
//  MemoryFaces
//
//  Created by Павленко Павел on 26.01.2026.
//

import SwiftUI
import SwiftData
import PhotosUI

@Model
class Person: Identifiable {
    var id = UUID()
    var name: String
    var lastName: String
    var phone: String
    var mail: String
    @Attribute(.externalStorage) var photoData: Data?

    init(id: UUID = UUID(), name: String, lastName: String, phone: String, mail: String, photoData: Data? = nil) {
        self.id = id
        self.name = name
        self.lastName = lastName
        self.phone = phone
        self.mail = mail
        self.photoData = photoData
    }
    
    var photo: Image? {
        guard let photoData = photoData, let uiImage = UIImage(data: photoData) else {
            return nil
        }
        return Image(uiImage: uiImage)
    }
}


struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Person.name) private var people: [Person]
    
    @State private var showingAddCard = false
        
    var body: some View {
        NavigationStack {
            List {
                ForEach(people) { person in
                    NavigationLink {
                        CardView(person: person)
                    } label: {
                        HStack(spacing: 15) {
                            if (person.photo != nil) {
                                person.photo?
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 50, height: 50)
                                    .clipped()
                                    .clipShape(.circle)
                            } else {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 50, height: 50)
                                    .clipped()
                                    .clipShape(.circle)
                                    .foregroundColor(.gray)
                            }
                            Text(person.lastName + " " + person.name)
                                .font(.headline)
                        }
                    }
                }
                .onDelete(perform: removePeople)
            }
            .navigationTitle("MemoryFaces")
            .toolbar {
                Button("Add card", systemImage: "plus") { showingAddCard = true }
            }
            .sheet(isPresented: $showingAddCard) {
                AddCard()
            }
        }
    }
    
    private func removePeople(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(people[index])
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Person.self, configurations: config)

    let testPerson = Person(name: "Test", lastName: "User", phone: "", mail: "")
    container.mainContext.insert(testPerson)

    return ContentView()
        .modelContainer(container)
}
