//
//  TravelOptionRow.swift
//  DriveNow
//
//  Created by Eduardo Regis Vieira on 12/12/24.
//

import SwiftUI

struct TravelOptionCard: View {
    let option: TravelOption
    let isSelected: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(option.name)
                    .font(.headline)
                Spacer()
                Text("★ \(option.review.rating)")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            
            Text(option.description)
                .font(.subheadline)
                .foregroundColor(.gray)
            Text(option.vehicle)
                .font(.caption)
                .foregroundColor(.gray)
            
            HStack {
                Spacer()
                Text("R$ \(option.value, specifier: "%.2f")")
                    .font(.headline)
            }
        }
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(isSelected ? Color.black : Color.clear, lineWidth: 2)
        )
        .shadow(radius: 2)
    }
}
