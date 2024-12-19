//
//  TravelHistoryViewController.swift
//  DriveNow
//
//  Created by Eduardo Regis Vieira on 12/12/24.
//

//
//  TravelHistoryViewController.swift
//  DriveNow
//
//  Created by Eduardo Regis Vieira on 12/12/24.
//

import Foundation
import UIKit

protocol TravelHistoryDisplayLogic: AnyObject {
    func displayAvailableDrivers(_ drivers: [Int : String])
    func displayFilteredResults(_ viewModel: TravelHistoryModel.ViewModel)
    func displayError(_ error: TravelHistoryModel.Error)
}

class TravelHistoryViewController: UIViewController, TravelHistoryDisplayLogic {
    
    var interactor: TravelHistoryBusinessLogic?
    var router: AppRouter?
    
    // UI Components
    private let userIdTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter User ID"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        textField.backgroundColor = .white
        return textField
    }()
    
    private let driverButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select Driver", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .darkGray
        button.layer.cornerRadius = 8
        button.addTarget(nil, action: #selector(driverButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let applyFilterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Apply Filter", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 8
        button.addTarget(nil, action: #selector(applyFilterTapped), for: .touchUpInside)
        button.isEnabled = true
        return button
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(RideTableViewCell.self, forCellReuseIdentifier: RideTableViewCell.identifier)
        table.isHidden = true // Initially hidden
        table.backgroundColor = .systemBackground
        return table
    }()
    
    // Data Sources
    private var drivers: [Int:String] = [:] {
        didSet {
            self.sortedDriverKeys = [nil] + drivers.keys.sorted().map { Optional($0) }
        }
    }
    
    private var sortedDriverKeys: [Int?] = [nil]
    private var selectedDriver: Int?
    private var filteredRides: [Ride] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        setupUI()
        fetchAvailableDrivers()
    }
    
    private func setupUI() {
        // Add subviews
        view.addSubview(userIdTextField)
        view.addSubview(driverButton)
        view.addSubview(applyFilterButton)
        view.addSubview(activityIndicator)
        view.addSubview(tableView)
        
        // Set delegates
        tableView.dataSource = self
        tableView.delegate = self
        
        // Disable autoresizing mask
        userIdTextField.translatesAutoresizingMaskIntoConstraints = false
        driverButton.translatesAutoresizingMaskIntoConstraints = false
        applyFilterButton.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        // Apply constraints
        NSLayoutConstraint.activate([
            userIdTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            userIdTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            userIdTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            userIdTextField.heightAnchor.constraint(equalToConstant: 44),
            
            driverButton.topAnchor.constraint(equalTo: userIdTextField.bottomAnchor, constant: 20),
            driverButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            driverButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            driverButton.heightAnchor.constraint(equalToConstant: 50),
            
            applyFilterButton.topAnchor.constraint(equalTo: driverButton.bottomAnchor, constant: 40),
            applyFilterButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            applyFilterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            applyFilterButton.heightAnchor.constraint(equalToConstant: 50),
            
            tableView.topAnchor.constraint(equalTo: applyFilterButton.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        // Style table view
        tableView.layer.cornerRadius = 8
        tableView.layer.borderWidth = 1
        tableView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    private func fetchAvailableDrivers() {
        activityIndicator.startAnimating()
        interactor?.fetchAvailableDrivers()
    }
    
    @objc private func driverButtonTapped() {
        let alert = UIAlertController(title: "Select Driver", message: nil, preferredStyle: .actionSheet)
        
        // Add "All Drivers" option
        alert.addAction(UIAlertAction(title: "All Drivers", style: .default, handler: { _ in
            self.selectedDriver = nil
            self.driverButton.setTitle("All Drivers", for: .normal)
        }))
        
        // Add actions for each driver
        drivers.forEach { (id, name) in
            alert.addAction(UIAlertAction(title: name, style: .default, handler: { _ in
                self.selectedDriver = id
                self.driverButton.setTitle(name, for: .normal)
            }))
        }
        
        // Cancel action
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // For iPad support
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = driverButton
            popoverController.sourceRect = driverButton.bounds
        }
        
        present(alert, animated: true)
    }
    
    @objc private func applyFilterTapped() {
        guard let userId = userIdTextField.text, !userId.isEmpty else {
            displayError(TravelHistoryModel.Error(message: "Please enter a user ID."))
            return
        }
        
        let request = TravelHistoryModel.FilterRequest(
            userId: userId,
            driverId: selectedDriver
        )
        
        applyFilterButton.isEnabled = false
        activityIndicator.startAnimating()
        tableView.isHidden = true
        
        Task {
            interactor?.applyFilter(request: request)
            DispatchQueue.main.async {
                self.applyFilterButton.isEnabled = true
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    // MARK: - Display Logic
    
    func displayAvailableDrivers(_ drivers: [Int : String]) {
        DispatchQueue.main.async {
            self.drivers = drivers
            // Optionally set default selection
            self.driverButton.setTitle("All Drivers", for: .normal)
        }
    }
    
    func displayFilteredResults(_ viewModel: TravelHistoryModel.ViewModel) {
        DispatchQueue.main.async {
            self.filteredRides = viewModel.results.rides
            self.tableView.isHidden = false
            self.tableView.reloadData()
        }
    }
    
    func displayError(_ error: TravelHistoryModel.Error) {
        DispatchQueue.main.async {
            self.applyFilterButton.isEnabled = true
            self.activityIndicator.stopAnimating()
            let alert = UIAlertController(title: "Error", message: error.message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension TravelHistoryViewController: UITableViewDataSource, UITableViewDelegate {
    
    // Define the number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Define the number of rows in the section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredRides.count
    }
    
    // Configure each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: RideTableViewCell.identifier, for: indexPath) as? RideTableViewCell else {
            return UITableViewCell()
        }
        
        let ride = filteredRides[indexPath.row]
        cell.configure(with: ride)
        
        return cell
    }
    
    // Handle cell selection (optional)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselect the cell
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Implement action on selecting a ride if necessary
    }
}

// MARK: - RideTableViewCell
class RideTableViewCell: UITableViewCell {
    
    static let identifier = "RideTableViewCell"
    
    // UI Components
    private let dateLabel = UILabel()
    private let originLabel = UILabel()
    private let destinationLabel = UILabel()
    private let distanceLabel = UILabel()
    private let durationLabel = UILabel()
    private let driverLabel = UILabel()
    private let valueLabel = UILabel()
    
    // Stack View for layout
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 5
        stack.alignment = .leading
        return stack
    }()
    
    // Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Configure UI
        stackView.addArrangedSubview(dateLabel)
        stackView.addArrangedSubview(originLabel)
        stackView.addArrangedSubview(destinationLabel)
        stackView.addArrangedSubview(distanceLabel)
        stackView.addArrangedSubview(durationLabel)
        stackView.addArrangedSubview(driverLabel)
        stackView.addArrangedSubview(valueLabel)
        
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Layout
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -10),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
        
        // Configure fonts and colors
        dateLabel.font = UIFont.boldSystemFont(ofSize: 16)
        originLabel.font = UIFont.systemFont(ofSize: 14)
        destinationLabel.font = UIFont.systemFont(ofSize: 14)
        distanceLabel.font = UIFont.systemFont(ofSize: 14)
        durationLabel.font = UIFont.systemFont(ofSize: 14)
        driverLabel.font = UIFont.systemFont(ofSize: 14)
        valueLabel.font = UIFont.systemFont(ofSize: 14)
        valueLabel.textColor = .systemGreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Configure the cell with ride data
    func configure(with ride: Ride) {
        dateLabel.text = "Date: \(ride.date)"
        originLabel.text = "Origin: \(ride.origin)"
        destinationLabel.text = "Destination: \(ride.destination)"
        distanceLabel.text = String(format: "Distance: %.2f km", ride.distance)
        durationLabel.text = "Duration: \(ride.duration)"
        driverLabel.text = "Driver: \(ride.driver.name)"
        valueLabel.text = String(format: "Value: R$ %.2f", ride.value)
    }
}
