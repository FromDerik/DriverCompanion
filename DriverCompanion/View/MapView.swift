//
//  MapView.swift
//  MapApp
//
//  Created by Derik Malcolm on 9/22/22.
//

import Foundation
import SwiftUI
import MapKit

class LandmarkAnnotation: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}

//struct MapViewController: UIViewControllerRepresentable {
//    @EnvironmentObject var locationManager: LocationManager
//    @Binding var coordinateRegion: MKCoordinateRegion
//    @Binding var mapItems: [MKMapItem]
//    @State private var lastLocation: CLLocationCoordinate2D?
//    
//    let mapView = MKMapView()
//    
//    func makeUIViewController(context: Context) -> UIViewController {
//        let vc = UIViewController()
//        vc.view.addSubview(mapView)
//        
//        vc.additionalSafeAreaInsets = UIEdgeInsets(top: 64, left: 0, bottom: 64, right: 0)
//        return vc
//    }
//    
//    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
////        mapView.topAnchor.constraint(equalTo: uiViewController.view.topAnchor).isActive = true
////        mapView.leadingAnchor.constraint(equalTo: uiViewController.view.leadingAnchor).isActive = true
////        mapView.trailingAnchor.constraint(equalTo: uiViewController.view.trailingAnchor).isActive = true
////        mapView.bottomAnchor.constraint(equalTo: uiViewController.view.bottomAnchor).isActive = true
//        context.coordinator.centerViewOnUserLocation()
//    }
//    
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//    
//    class Coordinator: NSObject, MKMapViewDelegate {
//        var parent: MapViewController
//        
//        init(_ parent: MapViewController) {
//            self.parent = parent
//        }
//        
//        func centerViewOnUserLocation() {
//            if let location = parent.locationManager.location {
//                centerViewOnCoordinate(location)
//            }
//        }
//        
//        func centerViewOnCoordinate(_ coordinate: CLLocationCoordinate2D) {
//            parent.mapView.setRegion(MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025)), animated: true)
//        }
//        
//        func calculateCenterCoordinate(for coordinates: [CLLocationCoordinate2D]) -> CLLocationCoordinate2D {
//            var x: Double = 0
//            var y: Double = 0
//            var z: Double = 0
//            
//            coordinates.forEach { coordinate in
//                let lat = coordinate.latitude * Double.pi / 180
//                let long = coordinate.longitude * Double.pi / 180
//                
//                x += cos(lat) * cos(long)
//                y += cos(lat) * sin(long)
//                z += sin(lat)
//            }
//            
//            let total = Double(coordinates.count)
//            
//            x = x / total
//            y = y / total
//            z = z / total
//            
//            let centerLong = atan2(y, x)
//            let centerSquarRoot = sqrt(x * x + y * y)
//            let centerLat = atan2(z, centerSquarRoot)
//            
//            return CLLocationCoordinate2D(latitude: centerLat * 180 / Double.pi, longitude: centerLong * 180 / Double.pi)
//        }
//        
//        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
//            let region = MKCoordinateRegion(center: userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
//            mapView.setRegion(region, animated: true)
//        }
//    }
//    
//}

struct MapView: UIViewRepresentable {
    @EnvironmentObject var locationManager: LocationManager
    @Binding var coordinateRegion: MKCoordinateRegion
    @Binding var mapItems: [MKMapItem]
    @Binding var trackingUserLocation: Bool
    @State private var lastLocation: CLLocationCoordinate2D?
    
    let mapView = MKMapView()
    
    func makeUIView(context: Context) -> MKMapView {
        mapView.delegate = context.coordinator
        mapView.showsScale = false
        mapView.showsUserLocation = true
        
        context.coordinator.centerViewOnUserLocation()
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.removeAnnotations(uiView.annotations)
        let annotations = mapItems.map { LandmarkAnnotation(coordinate: $0.placemark.coordinate)}
        uiView.addAnnotations(annotations)
        
        if !trackingUserLocation {
            var coordinate = CLLocationCoordinate2D()
            
            if mapItems.count > 1 {
                coordinate = context.coordinator.calculateCenterCoordinate(for: mapItems.map { $0.placemark.coordinate })
            } else {
                guard let mapItem = mapItems.first else { return }
                coordinate = mapItem.placemark.coordinate
            }
            
            context.coordinator.centerViewOnCoordinate(coordinate)
        } else {
            context.coordinator.centerViewOnUserLocation()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        
        init(_ parent: MapView) {
            self.parent = parent
        }
        
        func centerViewOnUserLocation() {
            if let location = parent.locationManager.location {
                centerViewOnCoordinate(location)
            }
        }
        
        func centerViewOnCoordinate(_ coordinate: CLLocationCoordinate2D) {
            parent.mapView.setRegion(MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025)), animated: true)
        }
        
//        func calculateDistanceInMeters(for coordinates: [CLLocationCoordinate2D]) -> Double {
//            let locations = coordinates.map { CLLocation(latitude: $0.latitude, longitude: $0.longitude) }
//
//            locations.forEach { location in
//
//            }
//        }
        
        func calculateCenterCoordinate(for coordinates: [CLLocationCoordinate2D]) -> CLLocationCoordinate2D {
            let poly = MKPolygon(coordinates: coordinates, count: coordinates.count)
            return poly.coordinate
//            var x: Double = 0
//            var y: Double = 0
//            var z: Double = 0
//
//            coordinates.forEach { coordinate in
//                let lat = coordinate.latitude * Double.pi / 180
//                let long = coordinate.longitude * Double.pi / 180
//
//                x += cos(lat) * cos(long)
//                y += cos(lat) * sin(long)
//                z += sin(lat)
//            }
//
//
//            let total = Double(coordinates.count)
//
//            x = x / total
//            y = y / total
//            z = z / total
//
//            let centerLong = atan2(y, x)
//            let centerSquarRoot = sqrt(x * x + y * y)
//            let centerLat = atan2(z, centerSquarRoot)
//
//            return CLLocationCoordinate2D(latitude: centerLat * 180 / Double.pi, longitude: centerLong * 180 / Double.pi)
        }
        
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
//            let region = MKCoordinateRegion(center: userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
//            mapView.setRegion(region, animated: true)
        }
        
        
        
    }
}
