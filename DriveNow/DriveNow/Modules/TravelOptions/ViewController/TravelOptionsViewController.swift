//
//  TravelViewController.swift
//  DriveNow
//
//  Created by Eduardo Regis Vieira on 11/12/24.
//

import Foundation
import UIKit
import SwiftUI

protocol TravelOptionsDisplayLogic: AnyObject {
    func displayTravelOptions(rides: TravelOptionsModel.TravelOptions)
    func displayTravelRoute(travelRouter: TravelOptionsModel.Router)
    func displayError(error: TravelOptionsModel.Error)
    func goToHistory()
}

class TravelOptionsViewController: UIViewController, TravelOptionsDisplayLogic {
    
    var interactor: TravelOptionsBusinessLogic?
    var router: AppRouter?
    
    private var viewModel = TravelOptionsViewModel()
    
    override func viewDidLoad() {

        initialData()
        
        // Create a UIHostingController with the SwiftUIView
        let travelView = TravelOptionsView(viewModel: self.viewModel) {
            
            self.confirmTravel()
        }
        
        let hostingController = UIHostingController(rootView: travelView)
        
        addChild(hostingController)
        view.addSubview(hostingController.view)
        
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        hostingController.didMove(toParent: self)
    }
    
    func initialData() {
        interactor?.getRidesOptions()
        interactor?.getTravelRoute()
    }
    
    func confirmTravel() {
        let request: TravelOptionsModel.DriverId = .init(driverId: viewModel.selectedId)
        interactor?.confirmTravel(request: request)
    }
    
    func displayTravelRoute(travelRouter: TravelOptionsModel.Router) {
        self.viewModel.setRouter(travelRouter)
    }
    
    func displayTravelOptions(rides: TravelOptionsModel.TravelOptions) {
        self.viewModel.ridesOptions = rides
    }
    
    func goToHistory() {
        Task { @MainActor in
            print("test")
            self.router?.navigate(to: .travelHistory)
        }
    }
    
    func displayError(error: TravelOptionsModel.Error) {
        // Mostra alerta de erro
        let alert = UIAlertController(title: "Erro", message: error.message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
}
