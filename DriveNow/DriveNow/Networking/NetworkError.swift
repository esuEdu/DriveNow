//
//  NetworkError.swift
//  DriveNow
//
//  Created by Eduardo on 08/12/24.
//


enum NetworkError: Error {
    case invalidData
    case apiError(String)
    
    var errorMessage: String {
        switch self {
        case .invalidData:
            return "Something went wrong. Please try again."
        case .apiError(let message):
            return message
        }
    }
}

struct APIErrorResponse: Codable {
    let code: String
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case code = "error_code"
        case message = "error_description"
    }
}
