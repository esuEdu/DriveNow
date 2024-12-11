//
//  Untitled.swift
//  DriveNow
//
//  Created by Eduardo on 07/12/24.
//

import Foundation

enum Endpoints {
    static let baseURL: String = "https://xd5zl5kk2yltomvw5fb37y3bm40vsyrx.lambda-url.sa-east-1.on.aws"
    
    case rideEstimate
    case rideConfirm
    case rides(customerId: String, driverId: Int? = nil)
    
    var url: URL {
        switch self {
        case .rideEstimate:
            return URL(string: "\(Endpoints.baseURL)/ride/estimate")!
        case .rideConfirm:
            return URL(string: "\(Endpoints.baseURL)/ride/confirm")!
        case .rides(let customerId, let driverId):
            guard let driverId else {
                return URL(string: "\(Endpoints.baseURL)/ride/\(customerId)")!
            }
            return URL(string: "\(Endpoints.baseURL)/ride/\(customerId)?driver_id=\(driverId)")!
        }
    }
    
    var method: String {
        switch self {
        case .rideEstimate:
            return "POST"
        case .rideConfirm:
            return "PATCH"
        case .rides:
            return "GET"
            
        }
    }
}
