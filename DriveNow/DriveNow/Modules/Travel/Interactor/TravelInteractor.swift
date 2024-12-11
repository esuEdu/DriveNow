//
//  Travelnteractor.swift
//  DriveNow
//
//  Created by Eduardo Regis Vieira on 11/12/24.
//

import Foundation

protocol TravelBusinessLogic {
    func getRideEstimate(request: TravelModel.Request) async
}

class TraveInteractor: TravelBusinessLogic {
    
    var presenter: TravelPresentaionLogic?
    var worker: NetworkWorkerProtocol
    
    init(worker: NetworkWorkerProtocol) {
        self.worker = worker
    }
    
    func getRideEstimate(request: TravelModel.Request) async {
        
        let requestData = encode(request)
        
        do {
            let data: RideEstimateModel = try await worker.fetchData(from: .rideEstimate, data: requestData)
            
            let response: TravelModel.Response = .init(data: data)
            
            presenter?.presentTravel(response: response)
            
        } catch let error {
            
            let descriptionError: TravelModel.Error = .init(message: error.localizedDescription)
            
            presenter?.presentError(error: descriptionError)
        }
    }
}
