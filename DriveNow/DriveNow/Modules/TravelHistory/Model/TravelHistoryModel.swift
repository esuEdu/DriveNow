//
//  TravelHistoryModel.swift
//  DriveNow
//
//  Created by Eduardo Regis Vieira on 12/12/24.
//

import Foundation

enum TravelHistoryModel {
    
    struct FilterRequest {
        let userId: String
        let driverId: Int?
    }
    
    struct Response {
        let results: RidesModel
    }
    
    struct DriversResponse {
        let drivers: [Int : String]
    }
    
    struct ViewModel {
        let results: RidesModel
    }
    
    struct Error {
        let message: String
    }
}

