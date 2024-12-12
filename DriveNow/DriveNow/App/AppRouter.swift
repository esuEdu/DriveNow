//
//  AppRouter.swift
//  DriveNow
//
//  Created by Eduardo Regis Vieira on 11/12/24.
//

import Foundation
import UIKit

enum Destination {
    case travel
    case travelOptions(rideEstimate: RideEstimateModel)
}

@MainActor
class AppRouter {
    
    private let navigationController: UINavigationController
    
    var worker: NetworkWorkerProtocol
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        
        let apiClient = APIClient()
        self.worker = NetworkWorker(apiClient: apiClient)
    }
    
    func start() {
        navigate(to: .travel)
    }
    
    func navigate(to destination: Destination) {
        switch destination {
        case .travel:
            let travelViewController = createTravelModule()
            navigationController.pushViewController(travelViewController, animated: true)
        case .travelOptions(rideEstimate: let rideEstimate):
            let travelOptionsViewController = createTravelOptionsModule(rideEstimate: rideEstimate)
            navigationController.pushViewController(travelOptionsViewController, animated: true)
        }
    }
    
    private func createTravelModule() -> UIViewController {
        let viewController = TravelViewController()
        let presenter = TravelPresenter()
        let interactor = TravelInteractor(worker: worker)
        
        navigationController.isNavigationBarHidden = true
        viewController.interactor = interactor
        viewController.router = self
        presenter.viewController = viewController
        interactor.presenter = presenter
        
        return viewController
    }
    
    private func createTravelOptionsModule(rideEstimate: RideEstimateModel) -> UIViewController {
        let viewController = TravelOptionsViewController()
        let presenter = TravelOptionsPresenter()
        let interactor = TravelOptionsInteractor(worker: worker, rideEstimate: rideEstimate)
        
        navigationController.isNavigationBarHidden = true
        viewController.interactor = interactor
        viewController.router = self
        presenter.viewController = viewController
        interactor.presenter = presenter
        
        return viewController
    }
    
    
}

