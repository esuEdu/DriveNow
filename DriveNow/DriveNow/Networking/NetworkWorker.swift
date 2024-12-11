//
//  NetworkWorker.swift
//  DriveNow
//
//  Created by Eduardo on 07/12/24.
//

import Foundation

protocol NetworkWorkerProtocol {
    func fetchData<T: Codable> (from endpoint: Endpoints, data: Data?) async throws -> T
}

class NetworkWorker: NetworkWorkerProtocol {

    private let apiClient: APIClientProtocol
    
    // Dependecy injection
    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }
    
    func fetchData<T: Codable>(from endpoint: Endpoints, data: Data? = nil) async throws -> T {
        
        let urlRequest = apiClient.constructURL(from: endpoint, data: data)

        do {
            let data = try await apiClient.performRequest(url: urlRequest)
            
            let decodeData = try JSONDecoder().decode(T.self, from: data)
            return decodeData
            
        } catch {
            throw NetworkError.invalidData
        }
    }
}
