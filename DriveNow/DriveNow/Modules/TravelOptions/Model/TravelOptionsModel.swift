//
//  TravelModel.swift
//  DriveNow
//
//  Created by Eduardo Regis Vieira on 11/12/24.
//

import Foundation

enum TravelOptionsModel {
    
    struct Request: Codable {
        let customerId: String
        let origin: String
        let destination: String
        let distance: Int
        let duration: Int
        let driver: Driver
        let value: Double

        enum CodingKeys: String, CodingKey {
            case customerId = "customer_id"
            case origin
            case destination
            case distance
            case duration
            case driver
            case value
        }
    }
    
    struct Response {
        let data: RideEstimateModel
    }
    
    struct ViewModel {
        let origin: Coordinates
        let destination: Coordinates
        let distance: Int
        let duration: Int
        let options: [TravelOption]
        let routeResponse: AnyValue

    }
    
    struct DriverId {
        let driverId: Int
    }
    
    struct Router {
        let origin: Coordinates
        let destination: Coordinates
        let routerData: Data
    }
    
    struct TravelOptions {
        let travels: [TravelOption]
    }
    
    struct Error {
        let message: String
    }
}
