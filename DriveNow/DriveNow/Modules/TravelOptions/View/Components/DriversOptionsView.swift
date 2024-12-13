//
//  PlanRideView.swift
//  DriveNow
//
//  Created by Eduardo Regis Vieira on 12/12/24.
//

import SwiftUI

struct DriversOptionsView: View {
    @State private var selectedOptionId: Int? = nil
    var travelOptions: [TravelOption]
    var onConfirm: ((Int) -> Void)
    
    @Binding var selectedDetent: PresentationDetent  // Receive the currently selected detent
    
    var body: some View {
        VStack {
            // Modal title
            Text("Ride Options")
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.top, 32)
            
            // Show the rest of the UI only if we're not in the smallest detent
            if selectedDetent != .fraction(0.1) {
                // List of travel options
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(travelOptions, id: \.id) { option in
                            TravelOptionCard(option: option, isSelected: selectedOptionId == option.id)
                                .onTapGesture {
                                    selectedOptionId = option.id
                                }
                        }
                    }
                    .padding()
                    Button(action: {
                        
                        if let id = selectedOptionId {
                            onConfirm(id)
                        }
                    }) {
                        Text("Confirm")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .padding([.leading, .trailing], 16)
                    }
                    .padding(.bottom)
                }
            }
        }
    }
}
