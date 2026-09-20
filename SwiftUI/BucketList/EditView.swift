//
//  EditView.swift
//  BucketList
//
//  Created by Павленко Павел on 19.01.2026.
//

import SwiftUI

struct EditView: View {
    enum LoadingState {
        case loading, loaded, failed
    }
    
    @Environment(\.dismiss) var dismiss
    var location: Location
    
    @State private var name: String
    @State private var description: String
    
    var onSave: (Location) -> Void
    var onDelete: () -> Void
    
    @State private var showingAlert = false
    
    @State private var loadingState = LoadingState.loading
    @State private var pages = [Page]()
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Place name", text: $name)
                    TextField("Description", text: $description)
                }
                
                Section("Nearby") {
                    switch loadingState {
                    case .loading:
                        Text("Loading...")
                        
                    case .loaded:
                        ForEach(pages, id: \.pageid) { page in
                            Text(page.title)
                                .font(.headline)
                            + Text(": ") +
                            Text(page.description)
                                .italic()
                        }
                        
                    case .failed:
                        Text("Please, try again later")
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        var newLocation = location
                        newLocation.id = UUID()
                        newLocation.name = name
                        newLocation.description = description
                        
                        onSave(newLocation)
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Delete", role: .destructive) {
                        showingAlert = true
                    }
                }
            }

            .navigationTitle("Place details")
            .alert("Are you sure?", isPresented: $showingAlert){
                Button("Delete", role: .destructive) {
                    onDelete()
                    dismiss()
                }
                Button("Cancel", role: .cancel) { }
            }
            .task {
                await fetchNearbyPlaces()
            }
        }
    }
    
    init(
        location: Location,
        onSave: @escaping (Location) -> Void,
        onDelete: @escaping () -> Void
    ) {
        self.location = location
        self.onSave = onSave
        self.onDelete = onDelete

        _name = State(initialValue: location.name)
        _description = State(initialValue: location.description)
    }

    
    func fetchNearbyPlaces() async { 
        let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(location.latitude)%7C\(location.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"
        
        guard let url = URL(string: urlString) else {
            print("Bad URL: \(urlString)")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let items = try JSONDecoder().decode(Result.self, from: data)
            pages = items.query.pages.values.sorted()
            loadingState = .loaded
        } catch {
            loadingState = .failed }
    }
}

#Preview {
    EditView(
        location: .example,
        onSave: { _ in },
        onDelete: { }
    )
}

