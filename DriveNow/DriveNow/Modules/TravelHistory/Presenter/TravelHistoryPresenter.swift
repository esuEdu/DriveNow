//
//  TravelHistoryPresenter.swift
//  DriveNow
//
//  Created by Eduardo Regis Vieira on 12/12/24.
//

import Foundation

protocol TravelHistoryPresentaionLogic {
    func presentAvailableDrivers(response: TravelHistoryModel.DriversResponse)
    func presentFilteredResults(response: TravelHistoryModel.Response)
    func presentError(_ error: TravelHistoryModel.Error)
}

class TravelHistoryPresenter: TravelHistoryPresentaionLogic {
    
    weak var viewController: TravelHistoryDisplayLogic?
    
    func presentAvailableDrivers(response: TravelHistoryModel.DriversResponse) {
        // Crie um viewModel se necessário
        // Aqui apenas repassa a informação
        viewController?.displayAvailableDrivers(response.drivers)
    }
    
    func presentFilteredResults(response: TravelHistoryModel.Response) {
        // Transforma o Response em ViewModel
        let viewModel = TravelHistoryModel.ViewModel(results: response.results)
        viewController?.displayFilteredResults(viewModel)
    }
    
    func presentError(_ error: TravelHistoryModel.Error) {
        viewController?.displayError(error)
    }
}

