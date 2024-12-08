//
//  NetworkError.swift
//  DriveNow
//
//  Created by Eduardo on 08/12/24.
//

enum NetworkError: Error {
    case requestFailed
    case invalidURL
    case invalidResponse
    case invalidData
}
