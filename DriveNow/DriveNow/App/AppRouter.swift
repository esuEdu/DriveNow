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
}

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
        }
    }
    
    private func createTravelModule() -> UIViewController {
        let viewController = TravelViewController()
        let presenter = TravelPresenter()
        let interactor = TraveInteractor(worker: worker)
        
        viewController.interactor = interactor
        viewController.router = self
        presenter.viewController = viewController
        interactor.presenter = presenter
        
        return viewController
    }
    
    
}

