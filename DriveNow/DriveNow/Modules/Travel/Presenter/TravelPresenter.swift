//
//  TravelPresenter.swift
//  DriveNow
//
//  Created by Eduardo Regis Vieira on 11/12/24.
//

import Foundation

protocol TravelPresentaionLogic {
    func presentTravel(response: TravelModel.Response)
    func presentOrigins(response: TravelModel.TravelOrigins)
    func presentDestinations(response: TravelModel.TravelDestinations)
    func presentError(error: TravelModel.Error)
}

class TravelPresenter: TravelPresentaionLogic {
    
    weak var viewController: TravelDisplayLogic?
    
    func presentTravel(response: TravelModel.Response) {
        
        let viewModel = TravelModel.ViewModel(
            origin: response.data.origin,
            destination: response.data.destination,
            distance: response.data.distance,
            duration: response.data.duration,
            options: response.data.options,
            routeResponse: response.data.routeResponse
        )
        
        viewController?.displayTravelEstimate(viewModel: viewModel)
        
    }
    
    func presentError(error: TravelModel.Error) {
        
        viewController?.displayError(error: error)
    }
    
    func presentOrigins(response: TravelModel.TravelOrigins) {
        viewController?.displayAvailableOrigins(response.origins)
    }
    
    func presentDestinations(response: TravelModel.TravelDestinations) {
        viewController?.displayAvailableDestinations(response.destinations)
    }
    
    
}

