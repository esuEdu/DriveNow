//
//  TravelViewController.swift
//  DriveNow
//
//  Created by Eduardo Regis Vieira on 11/12/24.
//

import Foundation
import UIKit

protocol TravelOptionsDisplayLogic: AnyObject {
    func displayTravelEstimate(viewModel: TravelOptionsModel.ViewModel)
    func displayError(error: TravelOptionsModel.Error)
}

class TravelOptionsViewController: UIViewController, TravelOptionsDisplayLogic {
    
    var interactor: TravelOptionsBusinessLogic?
    var router: AppRouter?
    
    override func viewDidLoad() {
        view.backgroundColor = .red
    }
    
    func displayTravelEstimate(viewModel: TravelOptionsModel.ViewModel) {
        
    }
    
    func displayError(error: TravelOptionsModel.Error) {
        
    }
    
}
