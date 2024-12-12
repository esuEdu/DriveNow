//
//  Travelnteractor.swift
//  DriveNow
//
//  Created by Eduardo Regis Vieira on 11/12/24.
//

import Foundation

protocol TravelOptionsBusinessLogic {
    func getRideEstimate(request: TravelOptionsModel.Request) async
}

class TravelOptionsInteractor: TravelOptionsBusinessLogic {
    
    var presenter: TravelOptionsPresentaionLogic?
    var worker: NetworkWorkerProtocol
    var rideEstimate: RideEstimateModel
    
    init(worker: NetworkWorkerProtocol, rideEstimate: RideEstimateModel) {
        self.worker = worker
        self.rideEstimate = rideEstimate
    }
    
    func getRideEstimate(request: TravelOptionsModel.Request) async {
        
        let requestData = encode(request)
        
        do {
            let data: RideEstimateModel = try await worker.fetchData(from: .rideEstimate, data: requestData)
            
            let response: TravelOptionsModel.Response = .init(data: data)
            
            presenter?.presentTravel(response: response)
            
        } catch let error {
            
            let descriptionError: TravelOptionsModel.Error = .init(message: error.localizedDescription)
            
            presenter?.presentError(error: descriptionError)
        }
    }
}
