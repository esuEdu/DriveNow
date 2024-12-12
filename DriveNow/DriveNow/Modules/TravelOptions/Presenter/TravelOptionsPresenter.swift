//
//  TravelPresenter.swift
//  DriveNow
//
//  Created by Eduardo Regis Vieira on 11/12/24.
//

import Foundation

protocol TravelOptionsPresentaionLogic {
    func presentTravel(response: TravelOptionsModel.Response)
    func presentError(error: TravelOptionsModel.Error)
}

class TravelOptionsPresenter: TravelOptionsPresentaionLogic {
    
    
    weak var viewController: TravelOptionsDisplayLogic?
    
    func presentTravel(response: TravelOptionsModel.Response) {
        
        let viewModel = TravelOptionsModel.ViewModel(
            origin: response.data.origin,
            destination: response.data.destination,
            distance: response.data.distance,
            duration: response.data.duration,
            options: response.data.options,
            routeResponse: response.data.routeResponse
        )
        
        viewController?.displayTravelEstimate(viewModel: viewModel)
        
    }
    
    func presentError(error: TravelOptionsModel.Error) {
        
        viewController?.displayError(error: error)
    }
    
}
