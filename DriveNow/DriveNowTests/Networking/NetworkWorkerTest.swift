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
    
    func testFetchDataSuccess() async throws {
        
        let mockJSON = """
        {
            "origin": { "latitude": 12.34, "longitude": 56.78 },
            "destination": { "latitude": 98.76, "longitude": 54.32 },
            "distance": 12345,
            "duration": 678,
            "options": [
                {
                    "id": 1,
                    "name": "Standard",
                    "description": "A standard ride option",
                    "vehicle": "Car",
                    "review": { "rating": 5, "comment": "Great ride!" },
                    "value": 25.50
                },
                {
                    "id": 2,
                    "name": "Premium",
                    "description": "A premium ride option",
                    "vehicle": "SUV",
                    "review": { "rating": 4, "comment": "Comfortable but expensive." },
                    "value": 45.75
                }
            ],
            "routeResponse": {
                "routes": [
                    { "id": 1, "path": "route path 1" },
                    { "id": 2, "path": "route path 2" }
                ]
            }
        }
        """
        mockAPIClient.mockData = mockJSON.data(using: .utf8)
        
        do {
            let result: RideEstimateModel = try await networkWorker.fetchData(from: .rideEstimate)
            
            // Assertions
            XCTAssertEqual(result.origin.latitude, 12.34)
            XCTAssertEqual(result.origin.longitude, 56.78)
            XCTAssertEqual(result.destination.latitude, 98.76)
            XCTAssertEqual(result.destination.longitude, 54.32)
            XCTAssertEqual(result.distance, 12345)
            XCTAssertEqual(result.duration, 678)
            XCTAssertEqual(result.options.count, 2)
            
        } catch {
            XCTFail("Expected success, but got error: \(error)")
        }
    }
    
    func testFetchRideEstimate_InvalidData() async throws {
        
        let invalidJSON = "Invalid JSON"
        
        mockAPIClient.mockData = invalidJSON.data(using: .utf8)
        
        do {
            let _ : RideEstimateModel = try await networkWorker.fetchData(from: .rideEstimate)

            XCTFail("Expected decoding error, but succeded.")
        } catch {
            XCTAssertEqual(error as? NetworkError, NetworkError.invalidData)
        }
    }
}
