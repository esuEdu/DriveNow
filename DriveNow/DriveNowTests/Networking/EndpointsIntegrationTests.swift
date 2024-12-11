//
//  RequestTest.swift
//  DriveNow
//
//  Created by Eduardo Regis Vieira on 10/12/24.
//

import XCTest
@testable import DriveNow

final class EndpointsIntegrationTests: XCTestCase {
    
    var networkWorker: NetworkWorker!
    var mockApiClient: APIClient!
    
    override func setUpWithError() throws {
        
        mockApiClient = APIClient()
        networkWorker = NetworkWorker(apiClient: mockApiClient)
    }
    
    override func tearDownWithError() throws {
        networkWorker = nil
        mockApiClient = nil
    }
    
    func testRideEstimateReturnData() async throws {
        let rideEstimate = RequestModels.RideEstimate(
            customer_id: "customer_id",
            origin: "Av. Pres. Kenedy, 2385 - Remédios, Osasco - SP, 02675-031",
            destination: "Av. Paulista, 1538 - Bela Vista, São Paulo - SP, 01310-200"
        )

        let rideEstimateData = encode(rideEstimate)

        do {
            let data: RideEstimateModel = try await networkWorker.fetchData(from: Endpoints.rideEstimate, data: rideEstimateData)
            XCTAssertNotNil(data, "Expected valid response, but got nil")
        } catch {
            XCTFail("Request failed with error: \(error)")
        }
    }
    
    func testRideConfirmationReturnData() async throws {
        
        let rideConfirmation = RequestModels.RideConfirmation(
            customer_id: "customer_id",
            origin: "Av. Pres. Kenedy, 2385 - Remédios, Osasco - SP, 02675-031",
            destination: "Av. Paulista, 1538 - Bela Vista, São Paulo - SP, 01310-200",
            distance: 20018,
            duration: 1920,
            driver: Driver(id: 1, name: "Homer Simpson"),
            value: 50.05
        )
        
        let rideConfirmationData = encode(rideConfirmation)
        
        do {
            let data: RideConfirmationModel = try await networkWorker.fetchData(from: Endpoints.rideConfirm, data: rideConfirmationData)
            XCTAssertNotNil(data, "Expected valid response, but got nil")
        } catch {
            XCTFail("Request failed with error: \(error)")
        }
    }
    
    func testRidesReturnData() async throws {
        
        do {
            let data: RidesModel = try await networkWorker.fetchData(from: Endpoints.rides(customerId: "CT01", driverId: 1))
            XCTAssertNotNil(data, "Expected valid response, but got nil")
        } catch {
            XCTFail("Request failed with error: \(error)")
        }
    }
}

enum RequestModels {
    
    struct RideEstimate: Codable {
        let customer_id: String
        let origin: String
        let destination: String
    }
    
    struct RideConfirmation: Codable {
        let customer_id: String
        let origin: String
        let destination: String
        let distance: Int
        let duration: Int
        let driver: Driver
        let value: Double
    }
}

