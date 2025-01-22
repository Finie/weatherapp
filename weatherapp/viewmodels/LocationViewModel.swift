//
//  LocationViewModel.swift
//  weatherapp
//
//  Created by fin on 21/01/2025.
//

import Foundation
import Combine
import CoreLocation


// swiftui combine databinder

class LocationViewModel: ObservableObject {
 
    @Published var currentLocation: CLLocationCoordinate2D? // Current user location
    @Published var error: String?
    
    private var locationManager = LocationManager()
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        startUpdatingLocation()
        getLocationCoordinates()
        getLocationError()
    }
    
    
    func getLocationCoordinates(){
        
        print("Fetching Current Location ....")
        
        locationManager.$location
            .sink { [weak self] location in
                if let location = location {
                    
                    let formattedLatitude = Double(String(format: "%.4f", location.latitude)) ?? 0.0
                    let formattedLongitude = Double(String(format: "%.4f", location.longitude)) ?? 0.0
                 
                    self?.currentLocation = CLLocationCoordinate2D(latitude: formattedLatitude, longitude: formattedLongitude)
                    
                    
                    print("Current Location at: \(formattedLatitude), \(formattedLongitude) ....")
                    
                    
                } else {
                    self?.error = "Location not available"
                }
            }
            .store(in: &cancellables)
        
    }
    
    
    func getLocationError(){
        
        locationManager.$errorMessage
            .sink { [weak self] errorMessage in
                if let errorMessage = errorMessage {
                    self?.error = "Error: \(errorMessage)"
                }
            }
            .store(in: &cancellables)
        
    }
    
    
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    
    func getLocationArray() -> [CLLocationCoordinate2D] {
        return [//293451599, 124424454
            CLLocationCoordinate2D(latitude: -1.2920659, longitude: 36.8219462),
            CLLocationCoordinate2D(latitude: -0.437099, longitude: 36.9580104)
        ]
    }
    
    
}
