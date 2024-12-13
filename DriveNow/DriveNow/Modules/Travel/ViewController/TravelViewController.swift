//
//  TravelViewController.swift
//  DriveNow
//
//  Created by Eduardo Regis Vieira on 11/12/24.
//
//
//  TravelViewController.swift
//  DriveNow
//
//  Created by Eduardo Regis Vieira on 12/12/24.
//

import UIKit

protocol TravelDisplayLogic: AnyObject {
    func displayTravelEstimate(viewModel: TravelModel.ViewModel)
    func displayError(error: TravelModel.Error)
    func displayAvailableOrigins(_ origins: [String])
    func displayAvailableDestinations(_ destinations: [String])
}

class TravelViewController: UIViewController, TravelDisplayLogic {

    var interactor: TravelBusinessLogic?
    var router: AppRouter?

    // UI Components
    private let customerIdTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Customer ID"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .white
        return textField
    }()

    private let originButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select Origin", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .darkGray
        button.layer.cornerRadius = 8
        button.addTarget(nil, action: #selector(originButtonTapped), for: .touchUpInside)
        return button
    }()

    private let destinationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select Destination", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .darkGray
        button.layer.cornerRadius = 8
        button.addTarget(nil, action: #selector(destinationButtonTapped), for: .touchUpInside)
        return button
    }()

    private let confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Confirm", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 8
        button.addTarget(nil, action: #selector(confirmButtonTapped), for: .touchUpInside)
        return button
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.hidesWhenStopped = true
        return indicator
    }()

    private var origins: [String] = []
    private var destinations: [String] = []
    private var selectedOrigin: String?
    private var selectedDestination: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        setupUI()
        fetchAvailableLocations()
    }

    private func setupUI() {
        view.addSubview(customerIdTextField)
        view.addSubview(originButton)
        view.addSubview(destinationButton)
        view.addSubview(confirmButton)
        view.addSubview(activityIndicator)

        customerIdTextField.translatesAutoresizingMaskIntoConstraints = false
        originButton.translatesAutoresizingMaskIntoConstraints = false
        destinationButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            customerIdTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            customerIdTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            customerIdTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            customerIdTextField.heightAnchor.constraint(equalToConstant: 44),

            originButton.topAnchor.constraint(equalTo: customerIdTextField.bottomAnchor, constant: 20),
            originButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            originButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            originButton.heightAnchor.constraint(equalToConstant: 50),

            destinationButton.topAnchor.constraint(equalTo: originButton.bottomAnchor, constant: 20),
            destinationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            destinationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            destinationButton.heightAnchor.constraint(equalToConstant: 50),

            confirmButton.topAnchor.constraint(equalTo: destinationButton.bottomAnchor, constant: 40),
            confirmButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            confirmButton.heightAnchor.constraint(equalToConstant: 50),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func fetchAvailableLocations() {
        interactor?.getAvailableOrigins()
        interactor?.getAvailableDestinations()
    }

    @objc private func originButtonTapped() {
        let alert = UIAlertController(title: "Select Origin", message: nil, preferredStyle: .actionSheet)
        origins.forEach { origin in
            alert.addAction(UIAlertAction(title: origin, style: .default, handler: { _ in
                self.selectedOrigin = origin
                self.originButton.setTitle(origin, for: .normal)
            }))
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true)
    }

    @objc private func destinationButtonTapped() {
        let alert = UIAlertController(title: "Select Destination", message: nil, preferredStyle: .actionSheet)
        destinations.forEach { destination in
            alert.addAction(UIAlertAction(title: destination, style: .default, handler: { _ in
                self.selectedDestination = destination
                self.destinationButton.setTitle(destination, for: .normal)
            }))
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true)
    }

    @objc private func confirmButtonTapped() {
        guard let customerId = customerIdTextField.text, !customerId.isEmpty else {
            displayError(error: TravelModel.Error(message: "Please enter a customer ID."))
            return
        }

        guard let origin = selectedOrigin, let destination = selectedDestination else {
            displayError(error: TravelModel.Error(message: "Please select both origin and destination."))
            return
        }

        let request = TravelModel.Request(customerId: customerId, origin: origin, destination: destination)

        confirmButton.isEnabled = false
        activityIndicator.startAnimating()

        Task {
            await interactor?.getRideEstimate(request: request)
            DispatchQueue.main.async {
                self.confirmButton.isEnabled = true
                self.activityIndicator.stopAnimating()
            }
        }
    }

    // MARK: - Display Logic

    func displayAvailableOrigins(_ origins: [String]) {
        self.origins = origins
    }

    func displayAvailableDestinations(_ destinations: [String]) {
        self.destinations = destinations
    }

    func displayTravelEstimate(viewModel: TravelModel.ViewModel) {
        let rideEstimate = RideEstimateModel(
            origin: viewModel.origin,
            destination: viewModel.destination,
            distance: viewModel.distance,
            duration: viewModel.duration,
            options: viewModel.options,
            routeResponse: viewModel.routeResponse
        )
        
        var customerId: String = ""
        
        Task { @MainActor in
            customerId = customerIdTextField.text ?? ""
        }

        let requestInfo = TravelModel.Request(
            customerId: customerId,
            origin: selectedOrigin ?? "",
            destination: selectedDestination ?? ""
        )

        Task { @MainActor in
            self.router?.navigate(to: .travelOptions(rideEstimate: rideEstimate, requestInfo: requestInfo))
        }
    }

    func displayError(error: TravelModel.Error) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: error.message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
}

