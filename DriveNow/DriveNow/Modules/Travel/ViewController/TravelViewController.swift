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
        let travelView = TravelView(viewModel: viewModel, onConfirm: { [weak self] customerId, origin, destination in
            self?.handleConfirm(customerId: customerId, origin: origin, destination: destination)
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
        print(viewModel)
    }
    
    func displayError(error: TravelModel.Error) {
        print(error.message)
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.viewModel.isPresented = false
            
            // Instantiate the custom error overlay view
            let errorView = ErrorView(message: error.message)
            
            // Optional: If you'd like to do something after dismissal
            errorView.onClose = {
                self.viewModel.isPresented = true
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
    
    
    private func handleConfirm(customerId: String, origin: String, destination: String) {
        
        let request = TravelModel.Request(customerId: customerId, origin: origin, destination: destination)
        Task {
            await interactor?.getRideEstimate(request: request)
        }
    }
}
