//
//  TravelOptionsView.swift
//  DriveNow
//
//  Created by Eduardo Regis Vieira on 12/12/24.
//

import SwiftUI
import MapKit

struct TravelOptionsView: View {
    
    @ObservedObject var viewModel: TravelOptionsViewModel
    var onConfirm: (() -> Void)
    
    @State private var selectedDetent: PresentationDetent = .medium
    
    var body: some View {
        ZStack {
            if let router = viewModel.router, let polyline = viewModel.routePolyline {
                RouteMapView(
                    region: $viewModel.region,
                    polyline: polyline,
                    origin: CLLocationCoordinate2D(latitude: router.origin.latitude, longitude: router.origin.longitude),
                    destination: CLLocationCoordinate2D(latitude: router.destination.latitude, longitude: router.destination.longitude)
                )
                .ignoresSafeArea()
            } else {
                Text("Loading map...")
                    .foregroundColor(.gray)
            }
            

        }
        // Existing sheet presentation
        .sheet(isPresented: $viewModel.isPresented) {
            DriversOptionsView(travelOptions: viewModel.ridesOptions.travels, onConfirm: { id in
                viewModel.selectedId = id
                viewModel.isPresented = false
                onConfirm()
            }, selectedDetent: $selectedDetent)
                .interactiveDismissDisabled()
                .presentationDetents([.fraction(0.1), .medium, .large], selection: $selectedDetent)
                .onAppear(perform: {viewModel.isPresented = true})
        }
        
        // Optional: Alert for errors
        .alert(isPresented: Binding<Bool>(
            get: { viewModel.errorMessage != nil },
            set: { _ in viewModel.errorMessage = nil }
        )) {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.errorMessage ?? "Unknown error."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

