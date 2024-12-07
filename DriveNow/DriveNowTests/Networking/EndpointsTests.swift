//
//  EndpointsTests.swift
//  DriveNow
//
//  Created by Eduardo on 07/12/24.
//

import XCTest
@testable import DriveNow

final class EndpointsTests: XCTestCase {
    
    func testPostRiedEstimateURL() {
        let expectedURL = "https://xd5zl5kk2yltomvw5fb37y3bm40vsyrx.lambda-url.sa-east-1.on.aws/ride/estimate"
        let url = Endpoints.postRideEstimate.url
        XCTAssertEqual(url.absoluteString, expectedURL, "The postRideEstimate endpoint URL does not match the expected URL.")
    }
    
    func testPathcRideConfirmURL() {
        let expectedURL = "https://xd5zl5kk2yltomvw5fb37y3bm40vsyrx.lambda-url.sa-east-1.on.aws/ride/confirm"
        let url = Endpoints.patchRideConfirm.url
        XCTAssertEqual(url.absoluteString, expectedURL, "The patchRideConfirm endpoint URL does not match the expected URL.")
    }
    
    func testGetRideURL() {
        let cutomerID = "customerId"
        let driverID = "driverId"
        let expectedURL = "https://xd5zl5kk2yltomvw5fb37y3bm40vsyrx.lambda-url.sa-east-1.on.aws/ride/\(cutomerID)?driver_id=\(driverID)"
        let url = Endpoints.getRide(customerId: cutomerID, driverId: driverID).url
        XCTAssertEqual(url.absoluteString, expectedURL, "The getRide endpoint URL does not match the expected URL.")
    }
}
