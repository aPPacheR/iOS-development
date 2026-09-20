
//CardView.swift

import SwiftData
import SwiftUI
import PhotosUI

struct CardView: View {
    
    var person: Person

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    if let photoData = person.photoData,
                       let uiImage = UIImage(data: photoData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 300, height: 300)
                            .clipped()
                            .clipShape(.circle)
                    } else {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 300, height: 300)
                            .foregroundColor(.gray)
                            .clipShape(.circle)
                    }
                    
                    Text("\(person.lastName) \(person.name)")
                        .font(.largeTitle.weight(.bold))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    VStack(spacing: 15) {
                        HStack {
                            Image(systemName: "phone.fill")
                                .foregroundColor(.blue)
                                .frame(width: 30)
                            Text("Телефон:")
                                .fontWeight(.bold)
                            Spacer()
                            Text(person.phone)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .background(.white)
                        .clipShape(.rect(cornerRadius: 10))
                        
                        HStack {
                            Image(systemName: "envelope.fill")
                                .foregroundColor(.blue)
                                .frame(width: 30)
                            Text("Почта:")
                                .fontWeight(.bold)
                            Spacer()
                            Text(person.mail)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .background(.white)
                        .clipShape(.rect(cornerRadius: 10))
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .padding(.top, 20)
            }
            .background(Color(.systemGroupedBackground))
        }

    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Person.self, configurations: config)
    
    let testPerson = Person(name: "Test", lastName: "User", phone: "", mail: "", photoData: nil)
    container.mainContext.insert(testPerson)

    return CardView(person: testPerson)
        .modelContainer(container)
}

