//
//  TravelViewModel.swift
//  DriveNow
//
//  Created by Eduardo Regis Vieira on 12/12/24.
//

import SwiftUI

class TravelViewModel: ObservableObject {
    @Published var isPresented: Bool = true
    @Published var isLoading: Bool = false
    
    
    @Published var customerId: String = ""
    @Published var origin: String = ""
    @Published var destination: String = ""
    
}
