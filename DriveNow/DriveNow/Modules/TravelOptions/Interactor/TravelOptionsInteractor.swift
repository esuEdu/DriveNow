//
//  Travelnteractor.swift
//  DriveNow
//
//  Created by Eduardo Regis Vieira on 11/12/24.
//

import Foundation

protocol TravelOptionsBusinessLogic {
    func getRidesOptions()
    func getTravelRoute()
    func confirmTravel(request: TravelOptionsModel.DriverId)
}

class TravelOptionsInteractor: TravelOptionsBusinessLogic {
    
    var presenter: TravelOptionsPresentaionLogic?
    var worker: NetworkWorkerProtocol
    
    var rideEstimate: RideEstimateModel
    var requestInfo: TravelModel.Request
    
    init(worker: NetworkWorkerProtocol, rideEstimate: RideEstimateModel, requestInfo: TravelModel.Request) {
        self.worker = worker
        self.rideEstimate = rideEstimate
        self.requestInfo = requestInfo
    }
    
    func confirmTravel(request: TravelOptionsModel.DriverId) {
        
        let selectedOption = rideEstimate.options.first { $0.id == request.driverId }!
        
        let driver: Driver = .init(id: selectedOption.id, name: selectedOption.name)
        
        let request: TravelOptionsModel.Request = .init(
            customerId: requestInfo.customerId,
            origin: requestInfo.origin,
            destination: requestInfo.destination,
            distance: rideEstimate.distance,
            duration: rideEstimate.duration,
            driver: driver,
            value: selectedOption.value
        )
        
        let requestData = encode(request)
        
        Task { @MainActor in
            
            do {
                let _ : RideConfirmationModel  = try await worker.fetchData(from: .rideConfirm, data: requestData)
                presenter?.presentRideConfirm()
            } catch let error {
                var message = "Ocorreu um erro desconhecido."
                
                if let netError = error as? NetworkError {
                    message = netError.errorMessage
                }
                
                let descriptionError = TravelOptionsModel.Error(message: message)
                presenter?.presentError(error: descriptionError)
            }
            
        }
    }
    
    func getRidesOptions() {
        let travelOptions: TravelOptionsModel.TravelOptions = .init(travels: rideEstimate.options)
        presenter?.presentTravelOptions(travelOptions: travelOptions)
    }
    
    func getTravelRoute() {
        
        let routerData = encode(rideEstimate.routeResponse)
        
        let travelRoute: TravelOptionsModel.Router = .init(origin: rideEstimate.origin, destination: rideEstimate.destination, routerData: routerData)
        
        presenter?.presentTravelRoute(travelRoute: travelRoute)
        
    }
}
