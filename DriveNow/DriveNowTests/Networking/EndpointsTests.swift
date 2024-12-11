//
//  EndpointsTests.swift
//  DriveNow
//
//  Created by Eduardo on 07/12/24.
//

import XCTest
@testable import DriveNow

final class EndpointsTests: XCTestCase {
    
    func testRideEstimateURL() {
        let expectedURL = "https://xd5zl5kk2yltomvw5fb37y3bm40vsyrx.lambda-url.sa-east-1.on.aws/ride/estimate"
        let url = Endpoints.postRideEstimate.url
        XCTAssertEqual(url.absoluteString, expectedURL, "The postRideEstimate endpoint URL does not match the expected URL.")
    }
    
    func testRideConfirmURL() {
        let expectedURL = "https://xd5zl5kk2yltomvw5fb37y3bm40vsyrx.lambda-url.sa-east-1.on.aws/ride/confirm"
        let url = Endpoints.patchRideConfirm.url
        
        XCTAssertEqual(url.absoluteString, expectedURL, "The patchRideConfirm endpoint URL does not match the expected URL.")
    }
    
    func testRideURL() {
        let cutomerID = "customerId"
        let driverID = 1
        
        let expectedURL = "https://xd5zl5kk2yltomvw5fb37y3bm40vsyrx.lambda-url.sa-east-1.on.aws/ride/\(cutomerID)?driver_id=\(driverID)"
        let url = Endpoints.getRide(customerId: cutomerID, driverId: driverID).url
        
        XCTAssertEqual(url.absoluteString, expectedURL, "The getRide endpoint URL does not match the expected URL.")
    }
    
    func testRideEstimateMethod() {
        let expectedMethod: String = "POST"
        let method = Endpoints.postRideEstimate.method
        
        XCTAssertEqual(method, expectedMethod, "The postRideEstimate endpoint method does not match the expected method.")
    }
    
    func testRideConfirmMethod() {
        let expectedMethod: String = "PATCH"
        let method = Endpoints.patchRideConfirm.method
        
        XCTAssertEqual(method, expectedMethod, "The patchRideConfirm endpoint method does not match the expected method.")
    }
    
    func testRifdeMethod() {
        let cutomerID = "customerId"
        let driverID = 1
        
        let expectedMethod: String = "GET"
        let method = Endpoints.getRide(customerId: cutomerID, driverId: driverID).method
        
        XCTAssertEqual(method, expectedMethod, "The getRide endpoint method does not match the expected method.")
    }
}
