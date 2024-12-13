//
//  RouteMapView.swift
//  DriveNow
//
//  Created by Eduardo Regis Vieira on 12/12/24.
//

import SwiftUI
import MapKit

struct RouteMapView: UIViewRepresentable {
    @Binding var region: MKCoordinateRegion
    var polyline: MKPolyline?
    var origin: CLLocationCoordinate2D
    var destination: CLLocationCoordinate2D
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.setRegion(region, animated: false)
        mapView.delegate = context.coordinator
        
        // Add annotations for origin and destination
        let originAnnotation = MKPointAnnotation()
        originAnnotation.coordinate = origin
        originAnnotation.title = "Origin"
        
        let destinationAnnotation = MKPointAnnotation()
        destinationAnnotation.coordinate = destination
        destinationAnnotation.title = "Destination"
        
        mapView.addAnnotations([originAnnotation, destinationAnnotation])
        
        // Add polyline overlay
        if let polyline = polyline {
            mapView.addOverlay(polyline)
        }
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        // Update the region
        uiView.setRegion(region, animated: true)
        
        // Remove existing overlays and add the new one
        uiView.removeOverlays(uiView.overlays)
        if let polyline = polyline {
            uiView.addOverlay(polyline)
        }
        
        // Remove existing annotations and add new ones
        uiView.removeAnnotations(uiView.annotations)
        
        let originAnnotation = MKPointAnnotation()
        originAnnotation.coordinate = origin
        originAnnotation.title = "Origin"
        
        let destinationAnnotation = MKPointAnnotation()
        destinationAnnotation.coordinate = destination
        destinationAnnotation.title = "Destination"
        
        uiView.addAnnotations([originAnnotation, destinationAnnotation])
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // MARK: - Coordinator
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: RouteMapView
        
        init(_ parent: RouteMapView) {
            self.parent = parent
        }
        
        // Renderer for the polyline
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = .blue
                renderer.lineWidth = 4
                return renderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }
        
        // Customize annotation views if needed
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard !(annotation is MKUserLocation) else { return nil }
            
            let identifier = "AnnotationView"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if annotationView == nil {
                annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
            } else {
                annotationView?.annotation = annotation
            }
            
            return annotationView
        }
    }
}
