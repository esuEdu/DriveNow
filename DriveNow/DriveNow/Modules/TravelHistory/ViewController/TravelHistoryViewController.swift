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
    
    // Componentes de UI
    private let userIdTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Informe o ID do usuário"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        return textField
    }()
    
    private let driverPickerView = UIPickerView()
    
    // Dicionário de motoristas [ID: Nome]
    private var drivers: [Int:String] = [:] {
        didSet {
            let sortedKeys = drivers.keys.sorted()
            self.sortedDriverKeys = [nil] + sortedKeys.map { Optional($0) }
            driverPickerView.reloadAllComponents()
        }
    }
    
    // Array de chaves ordenadas + nil representando "Todos"
    private var sortedDriverKeys: [Int?] = [nil]
    
    private let applyFilterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Aplicar Filtro", for: .normal)
        button.addTarget(nil, action: #selector(applyFilterTapped), for: .touchUpInside)
        return button
    }()
    
    // Adicionando a UITableView para exibir os resultados filtrados
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(RideTableViewCell.self, forCellReuseIdentifier: RideTableViewCell.identifier)
        return table
    }()
    
    // Data source para armazenar os resultados filtrados
    private var filteredRides: [Ride] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        // Configurar PickerView
        driverPickerView.dataSource = self
        driverPickerView.delegate = self
        
        // Configurar TableView
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isHidden = true // Esconder inicialmente
        
        // Adicionar subviews
        view.addSubview(userIdTextField)
        view.addSubview(driverPickerView)
        view.addSubview(applyFilterButton)
        view.addSubview(tableView)
        
        // Exemplo simples de posicionamento com AutoLayout
        userIdTextField.translatesAutoresizingMaskIntoConstraints = false
        driverPickerView.translatesAutoresizingMaskIntoConstraints = false
        applyFilterButton.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            userIdTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            userIdTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            userIdTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            driverPickerView.topAnchor.constraint(equalTo: userIdTextField.bottomAnchor, constant: 20),
            driverPickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            driverPickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            driverPickerView.heightAnchor.constraint(equalToConstant: 150),
            
            applyFilterButton.topAnchor.constraint(equalTo: driverPickerView.bottomAnchor, constant: 20),
            applyFilterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: applyFilterButton.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
        
        interactor?.fetchAvailableDrivers()
    }
    
    @objc private func applyFilterTapped() {
        let userIdText = userIdTextField.text ?? ""
        let selectedRow = driverPickerView.selectedRow(inComponent: 0)
        
        // Obtém a chave do motorista selecionado (se nil, significa "Todos")
        let selectedDriverKey = sortedDriverKeys[selectedRow]
        
        // Cria um request para filtrar
        let request = TravelHistoryModel.FilterRequest (
            userId: userIdText,
            driverId: selectedDriverKey // passa o ID ou nil
        )
        
        interactor?.applyFilter(request: request)
    }
    
    // MARK: - Display Logic
    
    func displayAvailableDrivers(_ drivers: [Int:String]) {
        self.drivers = drivers
    }
    
    func displayFilteredResults(_ viewModel: TravelHistoryModel.ViewModel) {
        self.filteredRides = viewModel.results.rides
        tableView.isHidden = false
        tableView.reloadData()
    }
    
    func displayError(_ error: TravelHistoryModel.Error) {
        // Mostra alerta de erro
        let alert = UIAlertController(title: "Erro", message: error.message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UIPickerViewDataSource, UIPickerViewDelegate
extension TravelHistoryViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sortedDriverKeys.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if let key = sortedDriverKeys[row] {
            return drivers[key]
        } else {
            return "Todos"
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension TravelHistoryViewController: UITableViewDataSource, UITableViewDelegate {
    
    // Define o número de seções
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Define o número de linhas na seção
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredRides.count
    }
    
    // Configura cada célula
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: RideTableViewCell.identifier, for: indexPath) as? RideTableViewCell else {
            return UITableViewCell()
        }
        
        let ride = filteredRides[indexPath.row]
        cell.configure(with: ride)
        
        return cell
    }
    
    // (Opcional) Lida com a seleção de uma célula
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Desseleciona a célula
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Implementar ação ao selecionar uma ride, se necessário
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
    
    // Inicialização
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Configurar UI
        let stackView = UIStackView(arrangedSubviews: [dateLabel, originLabel, destinationLabel, distanceLabel, durationLabel, driverLabel, valueLabel])
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.alignment = .leading
        
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Layout
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -10),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
        
        // Configurar fontes e cores, se necessário
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

    // Configurar a célula com os dados de uma ride
    func configure(with ride: Ride) {
        dateLabel.text = "Data: \(ride.date)"
        originLabel.text = "Origem: \(ride.origin)"
        destinationLabel.text = "Destino: \(ride.destination)"
        distanceLabel.text = String(format: "Distância: %.2f km", ride.distance)
        durationLabel.text = "Duração: \(ride.duration)"
        driverLabel.text = "Motorista: \(ride.driver.name)"
        valueLabel.text = String(format: "Valor: R$ %.2f", ride.value)
    }
}
