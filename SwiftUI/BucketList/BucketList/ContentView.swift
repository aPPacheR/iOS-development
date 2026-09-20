//
//  ContentView.swift
//  BucketList
//
//  Created by Павленко Павел on 14.01.2026.
//

import MapKit
import SwiftUI

struct ContentView: View {
    let startPosition = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: 59.9343,
                longitude: 30.3351
            ),
            span: MKCoordinateSpan(
                latitudeDelta: 0.2,
                longitudeDelta: 0.2
            )
        )
    )
    
    @State private var viewModel = ViewModel()
    
    var body: some View {
        if viewModel.isUnlocked {
            ZStack{
                MapReader { proxy in
                    Map(initialPosition: startPosition) {
                        ForEach(viewModel.locations) { location in
                            Annotation(location.name, coordinate: location.coordinate) {
                                Image(systemName: "star.circle")
                                    .resizable()
                                    .foregroundStyle(.blue)
                                    .frame(width: 22, height: 22)
                                    .background(.white)
                                    .clipShape(.circle)
                                    .onLongPressGesture {
                                        viewModel.selectedPlace = location
                                    }
                            }
                        }
                    }
                    .mapStyle(viewModel.mapStyle)
                    .onTapGesture { position in
                        if let coordinate = proxy.convert(position, from: .local) {
                            viewModel.addLocation(at: coordinate)
                        }
                    }
                    .sheet(item: $viewModel.selectedPlace) { place in
                        EditView(
                            location: place,
                            onSave: {
                                viewModel.update(location: $0)
                            },
                            onDelete: {
                                viewModel.delete(location: place)
                            }
                        )
                    }
                }
                VStack {
                    Spacer()
                    
                    Button(viewModel.style == .standard ? "Hybrid map" : "Standart map", action: viewModel.toggleStyle)
                    .padding()
                    .background(.thinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.blue.opacity(0.6), lineWidth: 1.5)
                    )
                }
            }
        } else {
            Button("Unlock Places", action: viewModel.authenticate)
                .padding()
                .background(.blue)
                .foregroundStyle(.white)
                .clipShape(.capsule)
        }
    }
}

#Preview {
    ContentView()
}
