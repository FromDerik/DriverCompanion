//
//  LocationManager.swift
//  MapApp
//
//  Created by Derik Malcolm on 9/21/22.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var location: CLLocationCoordinate2D?
    
    let manager = CLLocationManager()
    
    override init() {
        super.init()
        checkAuthorization()
    }
    
    func checkAuthorization() {
        switch manager.authorizationStatus {
        case .authorizedAlways:
            setupLocationManager()
            authorizationStatus = .authorizedAlways
        case .authorizedWhenInUse:
            setupLocationManager()
            authorizationStatus = .authorizedWhenInUse
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            authorizationStatus = .notDetermined
        case .denied:
            authorizationStatus = .denied
        case .restricted:
            authorizationStatus = .restricted
        @unknown default:
            break
        }
    }
    
    func setupLocationManager() {
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last?.coordinate
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error.localizedDescription)")
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkAuthorization()
    }
}
