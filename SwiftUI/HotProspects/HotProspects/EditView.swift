//
//  EditView.swift
//  HotProspects
//
//  Created by Павленко Павел on 29.01.2026.
//

import SwiftData
import SwiftUI

struct EditView: View {
    @Environment(\.dismiss) var dismiss
    @Bindable var prospect: Prospect
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $prospect.name)
                TextField("Mail", text: $prospect.emailAddress)
            }
            .navigationTitle("Edit user")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button("Save") {
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    do{
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let model = try ModelContainer(for: Prospect.self, configurations: config)
        
        let prospect = Prospect(name: "Pavlenko Pavel", emailAddress: "test@mail.ru", isContacted: false)
        return EditView(prospect: prospect)
            .modelContainer(model)
    } catch {
        return Text("Error - \(error.localizedDescription)")
    }
}
