//
//  TravelView.swift
//  DriveNow
//
//  Created by Eduardo Regis Vieira on 12/12/24.
//

import SwiftUI
import MapKit

struct TravelView: View {
    @ObservedObject var viewModel: TravelViewModel
    var onConfirm: ( () -> Void)?
    
    var body: some View {
        Map()
            .mapStyle(.hybrid)
            .ignoresSafeArea()
            .sheet(isPresented: $viewModel.isPresented) {
                PlanRideView(
                    customerId: $viewModel.customerId,
                    origin: $viewModel.origin,
                    destination: $viewModel.destination,
                    isLoading: $viewModel.isLoading,
                    onConfirm: {
                       
                    }
                )
                .interactiveDismissDisabled()
                .presentationDetents([.medium, .large])
            }
    }
}
