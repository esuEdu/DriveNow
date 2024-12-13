//
//  TravelOptionsViewModel.swift
//  DriveNow
//
//  Created by Eduardo Regis Vieira on 12/12/24.
//

import Foundation
import MapKit
import SwiftUI

struct RouteResponse: Decodable {
    let routes: [Route]
}

struct Route: Decodable {
    let polyline: Polyline
}

struct Polyline: Decodable {
    let encodedPolyline: String
}

class TravelOptionsViewModel: ObservableObject {
    @Published var isPresented: Bool = true
    @Published var router: TravelOptionsModel.Router?
    @Published var ridesOptions: TravelOptionsModel.TravelOptions = .init(travels: [])
    @Published var selectedId: Int = 0
    
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    @Published var routePolyline: MKPolyline?
    
    @Published var errorMessage: String?
    
    func setRouter(_ router: TravelOptionsModel.Router) {
        self.router = router
        decodePolyline()
    }
    
    private func decodePolyline() {
        guard let router = router else { return }
        
        do {
            // Decode the JSON routerData
            let routeResponse = try JSONDecoder().decode(RouteResponse.self, from: router.routerData)
            
            // Extract the first route's encodedPolyline
            guard let firstRoute = routeResponse.routes.first else { return }
            let encodedPolyline = firstRoute.polyline.encodedPolyline
            
            // Decode the encodedPolyline to coordinates
            if let coordinates = decodePolyline(encodedPolyline) {
                // Create MKPolyline
                let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
                self.routePolyline = polyline
                
                // Update the map region to fit the polyline
                self.setRegion(for: polyline)
            }
        } catch {
            print("Failed to decode routerData: \(error)")
            self.errorMessage = "Failed to load route."
        }
    }
    
    private func setRegion(for polyline: MKPolyline) {
        let rect = polyline.boundingMapRect
        let region = MKCoordinateRegion(rect)
        
        // Increase the span to zoom out
        let spanFactor: Double = 1.2
        let newSpan = MKCoordinateSpan(
            latitudeDelta: region.span.latitudeDelta * spanFactor,
            longitudeDelta: region.span.longitudeDelta * spanFactor
        )
        
        let newRegion = MKCoordinateRegion(center: region.center, span: newSpan)
        
        DispatchQueue.main.async {
            self.region = newRegion
        }
    }
    
    // Simple polyline decoder
    private func decodePolyline(_ encoded: String) -> [CLLocationCoordinate2D]? {
        var coordinates: [CLLocationCoordinate2D] = []
        var index = encoded.startIndex
        var latitude = 0
        var longitude = 0
        
        while index < encoded.endIndex {
            var result = 0
            var shift = 0
            var byte: Int
            
            repeat {
                byte = Int(encoded[index].asciiValue! - 63)
                index = encoded.index(after: index)
                result |= (byte & 0x1F) << shift
                shift += 5
            } while byte >= 0x20
            
            let deltaLat = ((result & 1) != 0) ? ~(result >> 1) : (result >> 1)
            latitude += deltaLat
            
            result = 0
            shift = 0
            
            repeat {
                byte = Int(encoded[index].asciiValue! - 63)
                index = encoded.index(after: index)
                result |= (byte & 0x1F) << shift
                shift += 5
            } while byte >= 0x20
            
            let deltaLon = ((result & 1) != 0) ? ~(result >> 1) : (result >> 1)
            longitude += deltaLon
            
            let coord = CLLocationCoordinate2D(
                latitude: Double(latitude) * 1e-5,
                longitude: Double(longitude) * 1e-5
            )
            coordinates.append(coord)
        }
        
        return coordinates
    }
}

