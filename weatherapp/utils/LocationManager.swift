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
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        requestLocationAccess()
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
        print("Starting location update....")
    }
    
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
        print("Stopping location update....")
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let loc = locations.last {
            self.location = loc.coordinate
            stopUpdatingLocation()
        }
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DispatchQueue.main.async {
            self.errorMessage = error.localizedDescription
        }
    }
    
    // Handle changes in location authorization status
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .notDetermined:
            requestLocationAccess()
        case .restricted, .denied:
            self.errorMessage = "Location access is denied. Please enable it in Settings."
            
        case .authorizedWhenInUse, .authorizedAlways:
            startUpdatingLocation()
        @unknown default:
            self.errorMessage = "Unknown location authorization status."
            
        }
        
    }
    
    
    
    
}
