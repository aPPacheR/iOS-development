
//AddCard.swift

import PhotosUI
import SwiftUI
import SwiftData

struct AddCard: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var phone = ""
    @State private var lastName = ""
    @State private var mail = ""
    
    @State private var photo: Image?
    @State private var selectedItem: PhotosPickerItem?
    
    @State private var photoData: Data?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                PhotosPicker(selection: $selectedItem, matching: .images) {
                    if let photo {
                        photo
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 300, height: 300)
                            .clipped()
                            .clipShape(.circle)
                    } else {
                        ContentUnavailableView("Нет фотографии", systemImage: "photo.badge.plus", description: Text("Нажмите для импорта фотографии"))
                    }
                }
                .buttonStyle(.plain)
                .onChange(of: selectedItem, loadImage)
                
                VStack {
                    TextField("Имя", text: $name)
                    Divider()
                    TextField("Фамилия", text: $lastName)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.white)
                .clipShape(.rect(cornerRadius: 10))
                .padding()
                
                VStack {
                    TextField("Номер", text: $phone)
                        .keyboardType(.phonePad)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(.white)
                        .clipShape(.rect(cornerRadius: 10))
                        .padding(.horizontal)
                }
                
                VStack {
                    TextField("Почта", text: $mail)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(.white)
                        .clipShape(.rect(cornerRadius: 10))
                        .padding(.horizontal)
                }
                .padding(.bottom)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Новая запись")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Назад") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Сохранить") {
                        saveToSwiftData()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
    
    func loadImage() {
        Task {
            guard let imageData = try await selectedItem?.loadTransferable(type: Data.self) else { return }
            guard let inputImage = UIImage(data: imageData) else { return }
            
            photoData = imageData
            photo = Image(uiImage: inputImage)
        }
    }
    
    func saveToSwiftData() {
        let newPerson = Person(
            name: name,
            lastName: lastName,
            phone: phone,
            mail: mail,
            photoData: photoData
        )
        
        modelContext.insert(newPerson)
        dismiss()
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Person.self, configurations: config)
    
    return AddCard()
        .modelContainer(container)
}
