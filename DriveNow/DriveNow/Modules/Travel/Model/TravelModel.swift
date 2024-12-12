//
//  TravelModel.swift
//  DriveNow
//
//  Created by Eduardo Regis Vieira on 11/12/24.
//

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
    
    struct Error {
        let message: String
    }
}
