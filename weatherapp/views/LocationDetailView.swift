//
//  LocationDetailView.swift
//  weatherapp
//
//  Created by fin on 24/01/2025.
//

import SwiftUI
import GoogleMaps
import CoreLocation

struct LocationDetailView: UIViewRepresentable  {
    
    let location: LocationDataStore
    

    public func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    public func makeUIView(context: Context) -> GMSMapView {
        let mapView = GMSMapView()
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        
        
        
        var currentLocation: CLLocationCoordinate2D = CLLocationCoordinate2D()
        currentLocation.latitude = location.latitude
        currentLocation.longitude = location.longitude
        
        let currentLocationMarker = GMSMarker(position: currentLocation)
        currentLocationMarker.title = location.name
        currentLocationMarker.map = mapView
        
        let camera = GMSCameraPosition.camera(withLatitude: currentLocation.latitude,
                                              longitude: currentLocation.longitude,
                                              zoom: 14.0)
        mapView.animate(to: camera)
    
        
        return mapView
    }
    
    
    public func updateUIView(_ uiView: GMSMapView, context: Context) {
        // Update the map view when the state changes
        // In this case, we don't need to update anything, so it can be left empty.
    }
    
    
}
