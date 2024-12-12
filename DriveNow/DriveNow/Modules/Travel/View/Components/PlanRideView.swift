//
//  PlanRideView.swift
//  DriveNow
//
//  Created by Eduardo Regis Vieira on 12/12/24.
//
import SwiftUI

struct PlanRideView: View {
    
    @Binding var customerId: String
    @Binding var origin: String
    @Binding var destination: String
    @Binding var isLoading: Bool  // Added binding to track loading state

    @State private var showOriginSuggestions: Bool = false
    @State private var showDestinationSuggestions: Bool = false
    
    var onConfirm: (() -> Void)?
    
    let suggestions = [
        "Av. Pres. Kenedy, 2385 - Remédios, Osasco - SP, 02675-031",
        "Av. Paulista, 1538 - Bela Vista, São Paulo - SP, 01310-200",
        "Av. Thomas Edison, 365 - Barra Funda, São Paulo - SP, 01140-000"
    ]
    
    var body: some View {
        ZStack {
            VStack (spacing: 16) {
                Text("Plan your ride")
                    .font(.title)
                    .fontWeight(.semibold)
                    .padding(.top, 32)
                
                VStack(spacing: 12) {
                    // Customer text field
                    TextField("Customer", text: $customerId)
                        .padding()
                        .padding(.leading, 20)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                        .overlay(
                            HStack {
                                Image(systemName: "person")
                                    .foregroundColor(.gray)
                                    .padding(.leading, 8)
                                Spacer()
                            }
                        )

                    // Origin text field with suggestions
                    VStack(alignment: .leading, spacing: 0) {
                        TextField("Origin", text: $origin, onEditingChanged: { editing in
                            self.showOriginSuggestions = editing && !origin.isEmpty
                        }, onCommit: {
                            self.showOriginSuggestions = false
                        })
                        .onChange(of: origin) { _, newValue in
                            self.showOriginSuggestions = !newValue.isEmpty
                        }
                        .padding()
                        .padding(.leading, 20)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                        .overlay(
                            HStack {
                                Image(systemName: "mappin.and.ellipse")
                                    .foregroundColor(.gray)
                                    .padding(.leading, 8)
                                Spacer()
                            }
                        )
                        
                        if showOriginSuggestions {
                            suggestionList(for: $origin)
                        }
                    }

                    // Destination text field with suggestions
                    VStack(alignment: .leading, spacing: 0) {
                        TextField("Destination", text: $destination, onEditingChanged: { editing in
                            self.showDestinationSuggestions = editing && !destination.isEmpty
                        }, onCommit: {
                            self.showDestinationSuggestions = false
                        })
                        .onChange(of: destination) { _, newValue in
                            self.showDestinationSuggestions = !newValue.isEmpty
                        }
                        .padding()
                        .padding(.leading, 20)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                        .overlay(
                            HStack {
                                Image(systemName: "flag.checkered")
                                    .foregroundColor(.gray)
                                    .padding(.leading, 8)
                                Spacer()
                            }
                        )
                        
                        if showDestinationSuggestions {
                            suggestionList(for: $destination)
                        }
                    }
                }
                .padding(.horizontal)
                
                // Confirm Button
                Button(action: {
                    hideAllSuggestions()
                    isLoading = true
                    onConfirm?()
                }) {
                    HStack {
                        Text("Confirm")
                            .foregroundColor(.white)
                            .font(.headline)
                        Image(systemName: "arrow.right.circle.fill")
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray) // adjust color as desired
                    .cornerRadius(8)
                    .padding(.horizontal)
                }
                .disabled(isLoading) // Disable button while loading
                
                Spacer(minLength: 8)
            }
            
            // Overlay a loading indicator when isLoading is true
            if isLoading {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                
                ProgressView("Loading...")
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .foregroundColor(.white)
                    .padding(20)
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(10)
            }
        }
    }
    
    @ViewBuilder
    private func suggestionList(for binding: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(suggestions.filter { $0.lowercased().contains(binding.wrappedValue.lowercased()) }, id: \.self) { suggestion in
                Button(action: {
                    binding.wrappedValue = suggestion
                    hideAllSuggestions()
                }) {
                    HStack {
                        Image(systemName: "mappin")
                            .foregroundColor(.gray)
                        Text(suggestion)
                            .font(.subheadline)
                            .foregroundColor(.primary)
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        .padding(.top, 4)
    }
    
    private func hideAllSuggestions() {
        self.showOriginSuggestions = false
        self.showDestinationSuggestions = false
    }
}
