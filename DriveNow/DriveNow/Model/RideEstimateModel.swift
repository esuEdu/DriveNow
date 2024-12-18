//
//  RideEstimateModel.swift
//  DriveNow
//
//  Created by Eduardo on 08/12/24.
//

import Foundation

struct RideEstimateModel: Codable {
    let origin: Coordinates
    let destination: Coordinates
    let distance: Int
    let duration: Int
    let options: [TravelOption]
    let routeResponse: AnyValue
}

struct Coordinates: Codable {
    let latitude: Double
    let longitude: Double
}

struct TravelOption: Codable {
    let id: Int
    let name: String
    let description: String
    let vehicle: String
    let review: Review
    let value: Double
}

struct Review: Codable {
    let rating: Int
    let comment: String
}
