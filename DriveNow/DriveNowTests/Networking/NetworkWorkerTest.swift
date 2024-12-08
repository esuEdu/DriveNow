//
//  NetworkWorkerTest.swift
//  DriveNow
//
//  Created by Eduardo on 08/12/24.
//

import XCTest
@testable import DriveNow

class MockAPIClient: APIClientProtocol {
    
    
    var shouldReturnError: Bool = false
    var mockData: Data?
    
    func constructURL(from endpoint: Endpoints, data: Data?) -> URLRequest {
        var urlRequest = URLRequest(url: endpoint.url)
        
        urlRequest.httpMethod = endpoint.method
        urlRequest.httpBody = data
        
        return urlRequest
    }
    
    func performRequest(url: URLRequest) async throws -> Data {
        guard !shouldReturnError else { throw NetworkError.requestFailed }
        
        guard let data = mockData else { throw NetworkError.invalidData }
        
        return data
    }
}

final class NetworkWorkerTest: XCTestCase {
    var networkWorker: NetworkWorker!
    
    var mockAPIClient: MockAPIClient!
    
    override func setUp() {
        mockAPIClient = MockAPIClient()
        networkWorker = NetworkWorker(apiClient: mockAPIClient)
    }
    
    override func tearDown() {
        networkWorker = nil
        mockAPIClient = nil
        super.tearDown()
    }
    
    func testFetchData_Success() async throws {
        
        let mockJSON = """
        {
            "origin": {
                "latitude": 37.7749,
                "longitude": -122.4194
            },
            "destination": {
                "latitude": 34.0522,
                "longitude": -118.2437
            },
            "distance": 600.5,
            "duration": "5 hours",
            "options": [
                {
                    "id": 1,
                    "name": "Economy",
                    "description": "Affordable ride",
                    "vehicle": "Compact Car",
                    "review": {
                        "rating": 4,
                        "comment": "Comfortable and clean."
                    },
                    "value": 45.99
                },
                {
                    "id": 2,
                    "name": "Premium",
                    "description": "Luxury ride",
                    "vehicle": "Sedan",
                    "review": {
                        "rating": 5,
                        "comment": "Excellent service."
                    },
                    "value": 89.99
                }
            ]
        }
        """
        mockAPIClient.mockData = mockJSON.data(using: .utf8)
        
        do {
            let result: RideEstimateModel = try await networkWorker.fetchData(from: .postRideEstimate)
            
            // Assertions
            XCTAssertEqual(result.origin.latitude, 37.7749)
            XCTAssertEqual(result.origin.longitude, -122.4194)
            XCTAssertEqual(result.destination.latitude, 34.0522)
            XCTAssertEqual(result.destination.longitude, -118.2437)
            XCTAssertEqual(result.distance, 600.5)
            XCTAssertEqual(result.options.count, 2)
            
        } catch {
            XCTFail("Expected success, but got error: \(error)")
        }
    }
    
    func testFetchRideEstimate_InvalidData() async throws {
        
        let invalidJSON = "Invalid JSON"
        
        mockAPIClient.mockData = invalidJSON.data(using: .utf8)
        
        do {
            let _ : RideEstimateModel = try await networkWorker.fetchData(from: .postRideEstimate)

            XCTFail("Expected decoding error, but succeded.")
        } catch {
            XCTAssertEqual(error as? NetworkError, NetworkError.invalidData)
        }
    }
}
