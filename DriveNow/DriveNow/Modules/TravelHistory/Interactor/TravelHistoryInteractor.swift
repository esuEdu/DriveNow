//
//  TravelHistoryInteractor.swift
//  DriveNow
//
//  Created by Eduardo Regis Vieira on 12/12/24.
//

import Foundation

protocol TravelHistoryBusinessLogic {
    func fetchAvailableDrivers()
    func applyFilter(request: TravelHistoryModel.FilterRequest)
}

class TravelHistoryInteractor: TravelHistoryBusinessLogic {
    
    var presenter: TravelHistoryPresentaionLogic?
    var worker: NetworkWorkerProtocol
    
    init(worker: NetworkWorkerProtocol) {
        self.worker = worker
    }
    
    func fetchAvailableDrivers() {
        let drivers: [Int: String] = [1:"Homer Simpson", 2:"Dominic Toretto", 3:"James Bond"]
        let response = TravelHistoryModel.DriversResponse(drivers: drivers)
        presenter?.presentAvailableDrivers(response: response)
    }
    
    func applyFilter(request: TravelHistoryModel.FilterRequest) {
        
        Task { @MainActor in
            do {
                let results: RidesModel = try await worker.fetchData(from: .rides(customerId: request.userId, driverId: request.driverId), data: nil)
                
                let response = TravelHistoryModel.Response(results: results)
                presenter?.presentFilteredResults(response: response)
                
            }catch let error {
                
                let error: TravelHistoryModel.Error = .init(message: error.localizedDescription)
                
                presenter?.presentError(error)
            }
            
        }
    }
}

