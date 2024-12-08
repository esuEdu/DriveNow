//
//  Untitled.swift
//  DriveNow
//
//  Created by Eduardo on 07/12/24.
//

import Foundation

enum Endpoints {
    static let baseURL: String = "https://xd5zl5kk2yltomvw5fb37y3bm40vsyrx.lambda-url.sa-east-1.on.aws"
    
    case postRideEstimate
    case patchRideConfirm
    case getRide(customerId: String, driverId: String)
    
    var url: URL {
        switch self {
            case .postRideEstimate:
                return URL(string: "\(Endpoints.baseURL)/ride/estimate")!
            case .patchRideConfirm:
                return URL(string: "\(Endpoints.baseURL)/ride/confirm")!
            case .getRide(let customerId, let driverId):
                return URL(string: "\(Endpoints.baseURL)/ride/\(customerId)?driver_id=\(driverId)")!
        }
    }
    
    var method: String {
        switch self {
            case .postRideEstimate:
                return "POST"
            case .patchRideConfirm:
                return "PATCH"
            case .getRide:
                return "GET"
                
        }
    }
}
