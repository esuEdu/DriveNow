//
//  TravelModel.swift
//  DriveNow
//
//  Created by Eduardo Regis Vieira on 11/12/24.
//

import Foundation

enum TravelModel {
    
    struct Request: Codable {
        let customerId: String
        let origin: String
        let destination: String
        
        enum CodingKeys: String, CodingKey {
            case customerId = "customer_id"
            case origin
            case destination
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
    
    struct TravelOrigins {
        let origins: [String]
    }
    
    struct TravelDestinations {
        let destinations: [String]
    }
    
    struct Error {
        let message: String
    }
}
