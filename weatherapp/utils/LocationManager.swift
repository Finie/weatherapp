//
//  LocationManager.swift
//  weatherapp
//
//  Created by fin on 21/01/2025.
//

import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    
    @Published var location: CLLocationCoordinate2D? = nil
    @Published var errorMessage: String? = nil
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        checkAuthorizationStatus()
    }
    
    // Check the authorization status before requesting permission
    func checkAuthorizationStatus() {
        processStatusUpdate(Status: locationManager.authorizationStatus)
    }
    
    
    // Request access to location
    func requestLocationAccess() {
        // Only request if the user hasn't granted permission yet
        if locationManager.authorizationStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    
    func startUpdatingLocation() {
        // Start receiving location updates
        locationManager.startUpdatingLocation()
    }
    
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let loc = locations.last {
            DispatchQueue.main.async {
                self.location = loc.coordinate
            }
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DispatchQueue.main.async {
            self.errorMessage = error.localizedDescription
        }
    }
    
    // Handle changes in location authorization status
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        processStatusUpdate(Status: status)
        
    }
    
    
    func processStatusUpdate(Status status: CLAuthorizationStatus) {
        
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            DispatchQueue.main.async {
                self.errorMessage = "Location access is denied. Please enable it in Settings."
            }
        case .authorizedWhenInUse, .authorizedAlways:
            startUpdatingLocation()
        @unknown default:
            DispatchQueue.main.async {
                self.errorMessage = "Unknown location authorization status."
            }
        }
        
    }
    
    
}
