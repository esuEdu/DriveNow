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
    case travelOptions(rideEstimate: RideEstimateModel, requestInfo: TravelModel.Request)
    case travelHistory
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
        case .travelOptions(rideEstimate: let rideEstimate, requestInfo: let requestInfo):
            let travelOptionsViewController = createTravelOptionsModule(rideEstimate: rideEstimate, requestInfo: requestInfo)
            navigationController.pushViewController(travelOptionsViewController, animated: true)
        case .travelHistory:
            let travelHistoryViewController = createTravelHistoryModule()
            navigationController.pushViewController(travelHistoryViewController, animated: true)
        }
    }
    
    private func createTravelModule() -> UIViewController {
        let viewController = TravelViewController()
        let presenter = TravelPresenter()
        let interactor = TravelInteractor(worker: worker)
        
        viewController.interactor = interactor
        viewController.router = self
        presenter.viewController = viewController
        interactor.presenter = presenter
        
        return viewController
    }
    
    private func createTravelOptionsModule(rideEstimate: RideEstimateModel, requestInfo: TravelModel.Request) -> UIViewController {
        let viewController = TravelOptionsViewController()
        let presenter = TravelOptionsPresenter()
        let interactor = TravelOptionsInteractor(worker: worker, rideEstimate: rideEstimate, requestInfo: requestInfo)
        
        viewController.interactor = interactor
        viewController.router = self
        presenter.viewController = viewController
        interactor.presenter = presenter
        
        return viewController
    }
    
    private func createTravelHistoryModule() -> UIViewController {
        let viewController = TravelHistoryViewController()
        let presenter = TravelHistoryPresenter()
        let interactor = TravelHistoryInteractor(worker: worker)
        
        viewController.interactor = interactor
        viewController.router = self
        presenter.viewController = viewController
        interactor.presenter = presenter
        
        return viewController
    }
    
    
}

