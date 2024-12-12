//
//  TravelViewController.swift
//  DriveNow
//
//  Created by Eduardo Regis Vieira on 11/12/24.
//

import Foundation
import UIKit
import SwiftUI

protocol TravelDisplayLogic: AnyObject {
    func displayTravelEstimate(viewModel: TravelModel.ViewModel)
    func displayError(error: TravelModel.Error)
}

class TravelViewController: UIViewController, TravelDisplayLogic {
    
    var interactor: TravelBusinessLogic?
    var router: AppRouter?
    
    private var hostingController: UIHostingController<TravelView>!
    private var viewModel = TravelViewModel()
    
    override func viewDidLoad() {
        // Create a UIHostingController with the SwiftUI View
        let travelView = TravelView(viewModel: viewModel, onConfirm: {
            self.handleConfirm()
        })
        
        self.hostingController = UIHostingController(rootView: travelView)
        
        // add the hosting controller as a child view controller
        addChild(hostingController)
        view.addSubview(hostingController.view)
        
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        hostingController.didMove(toParent: self)
    }
    
    
    func displayTravelEstimate(viewModel: TravelModel.ViewModel) {
        
        let rideEstimate: RideEstimateModel = .init(
            origin: viewModel.origin,
            destination: viewModel.destination,
            distance: viewModel.distance,
            duration: viewModel.duration,
            options: viewModel.options,
            routeResponse: viewModel.routeResponse
        )
        
        Task { @MainActor in
            self.viewModel.isLoading = false
            router?.navigate(to: .travelOptions(rideEstimate: rideEstimate))
        }

    }
    
    func displayError(error: TravelModel.Error) {
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            // Instantiate the custom error overlay view
            let errorView = ErrorView(message: error.message)
            
            // Optional: If you'd like to do something after dismissal
            errorView.onClose = {
                self.viewModel.isLoading = false
            }
            
            // Add it to the view hierarchy
            self.view.addSubview(errorView)
            errorView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                errorView.topAnchor.constraint(equalTo: self.view.topAnchor),
                errorView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                errorView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                errorView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            ])
            
            // Animate it in (fade in)
            errorView.alpha = 0
            UIView.animate(withDuration: 0.3) {
                errorView.alpha = 1
            }
        }
    }
    
    
    private func handleConfirm() {
        
        let request = TravelModel.Request(customerId: viewModel.customerId, origin: viewModel.origin, destination: viewModel.destination)
                
        Task {
            await interactor?.getRideEstimate(request: request)
        }
    }
}
