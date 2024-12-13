//
//  Travelnteractor.swift
//  DriveNow
//
//  Created by Eduardo Regis Vieira on 11/12/24.
//

import Foundation

protocol TravelBusinessLogic {
    func getRideEstimate(request: TravelModel.Request) async
    func getAvailableOrigins()
    func getAvailableDestinations()
}

class TravelInteractor: TravelBusinessLogic {
    
    var presenter: TravelPresentaionLogic?
    var worker: NetworkWorkerProtocol
    
    init(worker: NetworkWorkerProtocol) {
        self.worker = worker
    }
    
    func getRideEstimate(request: TravelModel.Request) async {
        do {
            let requestData = encode(request)
            
            let data: RideEstimateModel = try await worker.fetchData(from: .rideEstimate, data: requestData)
            let response = TravelModel.Response(data: data)
            presenter?.presentTravel(response: response)
        } catch let error {
            var message = "Ocorreu um erro desconhecido."
            
            if let netError = error as? NetworkError {
                message = netError.errorMessage
            }
            
            let descriptionError = TravelModel.Error(message: message)
            presenter?.presentError(error: descriptionError)
        }
    }
    
    func getAvailableOrigins() {
        let origins: TravelModel.TravelOrigins = .init(origins: [
            "Av. Pres. Kenedy, 2385 - Remédios, Osasco - SP, 02675-031",
            "Av. Paulista, 1538 - Bela Vista, São Paulo - SP, 01310-200",
            "Av. Thomas Edison, 365 - Barra Funda, São Paulo - SP, 01140-000",
            "Av. Brasil, 2033 - Jardim America, São Paulo - SP, 01431-001"
        ])

        
        presenter?.presentOrigins(response: origins)
    }
    
    func getAvailableDestinations() {
        let destinations: TravelModel.TravelDestinations = .init(destinations: [
            "Av. Pres. Kenedy, 2385 - Remédios, Osasco - SP, 02675-031",
            "Av. Paulista, 1538 - Bela Vista, São Paulo - SP, 01310-200",
            "Av. Thomas Edison, 365 - Barra Funda, São Paulo - SP, 01140-000",
            "Av. Brasil, 2033 - Jardim America, São Paulo - SP, 01431-001"
        ])
        
        presenter?.presentDestinations(response: destinations)
    }
}
