//
//  MapViewModel.swift
//  weatherapp
//
//  Created by fin on 23/01/2025.
//

import Foundation
import CoreLocation

class MapViewModel: ObservableObject {
    
    private var storeViewModel: StoreViewModel
    
    @Published var locationArray: [CLLocationCoordinate2D] = []
    
    
    
    init(storeViewModel: StoreViewModel) {
        self.storeViewModel = storeViewModel
        
        // Fetch favourite locations during initialization
        getFavouriteLocations()
    }
    
    
    func addFavouriteLocation(Name name: String, Latitude latitude: Double, Longitude longitude: Double ) {
        
        storeViewModel.addFavouriteLocation(
            LocationId: UUID(),
            Name: name,
            Latitude: latitude,
            Longitude: longitude,
            Active: false,
            IsFavourite: true,
            LastUpdated: Date())
        
    }
    
    
    func getFavouriteLocations() {
        let locationList = storeViewModel.locationData
        
        locationArray = locationList.compactMap { location in
            return CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        }
    }
    
}
