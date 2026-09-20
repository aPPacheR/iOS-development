//
//  AstronautView.swift
//  Moonshot
//
//  Created by Павленко Павел on 22.11.2025.
//

import SwiftUI

struct AstronautView: View {
    let astronaut: Astronaut

    var body: some View {
        ScrollView {
            VStack {
                
                Image(astronaut.id)
                    .resizable()
                    .scaledToFit()
                
                Text(astronaut.name)
                    .font(.title.weight(.bold))
                    .padding()


                Text(astronaut.description)
                    .padding(.horizontal)
            }
        }
        .padding(.vertical)
        .background(.darkBackground)
        .navigationTitle(astronaut.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}


#Preview {
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")

    return AstronautView(astronaut: astronauts["aldrin"]!)
        .preferredColorScheme(.dark)
}
