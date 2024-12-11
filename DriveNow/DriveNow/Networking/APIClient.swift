//
//  APIClient.swift
//  DriveNow
//
//  Created by Eduardo on 08/12/24.
//

import Foundation

protocol APIClientProtocol {
    func constructURL(from endpoint: Endpoints, data: Data?) -> URLRequest
    func performRequest(url: URLRequest) async throws -> Data
}

class APIClient: APIClientProtocol {
    
    func constructURL(from endpoint: Endpoints, data: Data?) -> URLRequest {
        var urlRequest = URLRequest(url: endpoint.url)
        
        urlRequest.httpMethod = endpoint.method
        urlRequest.httpBody = data
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
        return urlRequest
    }
    
    func performRequest(url: URLRequest) async throws -> Data {
        
        let (data, response) = try await URLSession.shared.data(for: url)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidData
        }
        
        return data
    }
}
