//
//  TravelPresenter.swift
//  DriveNow
//
//  Created by Eduardo Regis Vieira on 11/12/24.
//

import Foundation

protocol TravelOptionsPresentaionLogic {
    func presentTravelOptions(travelOptions: TravelOptionsModel.TravelOptions)
    func presentTravelRoute(travelRoute: TravelOptionsModel.Router)
    func presentRideConfirm()
    func presentError(error: TravelOptionsModel.Error)
}

class TravelOptionsPresenter: TravelOptionsPresentaionLogic {

    
    
    weak var viewController: TravelOptionsDisplayLogic?
    
    func presentTravelOptions(travelOptions: TravelOptionsModel.TravelOptions) {
        viewController?.displayTravelOptions(rides: travelOptions)
    }
    
    func presentTravelRoute(travelRoute: TravelOptionsModel.Router) {
        viewController?.displayTravelRoute(travelRouter: travelRoute)
    }
    
    func presentError(error: TravelOptionsModel.Error) {
        viewController?.displayError(error: error)
    }
    
    func presentRideConfirm() {
        viewController?.goToHistory()
    }
    
}
