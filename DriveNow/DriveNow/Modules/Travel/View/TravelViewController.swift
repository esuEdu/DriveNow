//
//  TravelViewController.swift
//  DriveNow
//
//  Created by Eduardo Regis Vieira on 11/12/24.
//

import Foundation
import UIKit

protocol TravelDisplayLogic: AnyObject {
    func displayTravelEstimate(viewModel: TravelModel.ViewModel)
    func displayError(error: TravelModel.Error)
}

class TravelViewController: UIViewController, TravelDisplayLogic {
    
    var interactor: TravelBusinessLogic?
    var router: AppRouter?
    
    override func viewDidLoad() {
        view.backgroundColor = .red
    }
    
    func displayTravelEstimate(viewModel: TravelModel.ViewModel) {
        
    }
    
    func displayError(error: TravelModel.Error) {
        
    }
    
}
