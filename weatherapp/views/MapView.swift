//
//  MapView.swift
//  weatherapp
//
//  Created by fin on 21/01/2025.
//

import SwiftUI
import GoogleMaps
import CoreLocation

public struct MapView: UIViewRepresentable {
    
    
    @ObservedObject var locationViewModel: LocationViewModel
    
    var previousLocation: CLLocationCoordinate2D?
    var locations: [CLLocationCoordinate2D]
    
    var selectedPlace: CLLocationCoordinate2D?
    
    public func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    public func makeUIView(context: Context) -> GMSMapView {
        let mapView = GMSMapView()
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        
    
        for location in locations {
            let marker = GMSMarker(position: location)
            marker.map = mapView
        }
        
        if let currentLocation = locationViewModel.currentLocation {
            
            let currentLocationMarker = GMSMarker(position: currentLocation)
            currentLocationMarker.title = "You 📍"
            currentLocationMarker.map = mapView
            
            let camera = GMSCameraPosition.camera(withLatitude: currentLocation.latitude,
                                                  longitude: currentLocation.longitude,
                                                  zoom: 6.0)
            mapView.animate(to: camera)
        }
        
        return mapView
    }
    
    public func updateUIView(_ uiView: GMSMapView, context: Context) {
        
        for location in locations {
            let marker = GMSMarker(position: location)
            marker.map = uiView
        }
        
        if let selectedPlace = selectedPlace {
            let selectedMarker = GMSMarker(position: selectedPlace)
            selectedMarker.title = "Selected Place"
            selectedMarker.map = uiView
            
            let camera = GMSCameraPosition.camera(withLatitude: selectedPlace.latitude,
                                                  longitude: selectedPlace.longitude,
                                                  zoom: 14.0)
            uiView.animate(to: camera)
        }
    }
}
