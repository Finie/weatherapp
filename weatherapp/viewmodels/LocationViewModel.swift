//
//  LocationViewModel.swift
//  weatherapp
//
//  Created by fin on 21/01/2025.
//

import Foundation
import Combine
import CoreLocation

class LocationViewModel: ObservableObject {
 
    @Published var currentLocation: CLLocationCoordinate2D?
    @Published var error: String?
    
    private var locationManager = LocationManager()
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        getLocationCoordinates()
    }
    
    
    func getLocationCoordinates(){
        locationManager.$location
            .sink { [weak self] location in
                if let location = location {
                    
                    print("Updated coordinates: \(location.latitude), \(location.longitude)")
                    self?.currentLocation = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
                } else {
                    self?.error = "Location not available"
                  
                }
            }
            .store(in: &cancellables)
        
    }
    
 
}
