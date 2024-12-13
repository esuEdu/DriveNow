//
//  RideModel.swift
//  DriveNow
//
//  Created by Eduardo Regis Vieira on 11/12/24.
//

struct RidesModel: Codable {
    let customerID: String
    let rides: [Ride]

    enum CodingKeys: String, CodingKey {
        case customerID = "customer_id"
        case rides
    }
}

// Model for each ride
struct Ride: Codable {
    let id: Int
    let date: String
    let origin: String
    let destination: String
    let distance: Double
    let duration: String
    let driver: Driver
    let value: Double
}

struct Driver: Codable {
    let id: Int
    let name: String
}
