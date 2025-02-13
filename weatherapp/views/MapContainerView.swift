//
//  MapContainerView.swift
//  weatherapp
//
//  Created by fin on 22/01/2025.
//

import SwiftUI
import GoogleMaps
import GooglePlaces

struct MapContainerView: View {
    @ObservedObject var locationViewModel = LocationViewModel()
    
    @StateObject var mapViewModel: MapViewModel
    
    
    @State private var searchText = ""
    @State private var predictions: [GMSAutocompletePrediction] = []
    @State private var selectedPlace: CLLocationCoordinate2D?
    @State private var selectedPlaceName: String?
    
    private let placesClient = GMSPlacesClient.shared()
    
    @State private var isPopupPresented = false
    
    
    init (locationViewModel: LocationViewModel, storeViewModel: StoreViewModel) {
        _mapViewModel = StateObject(wrappedValue: MapViewModel(storeViewModel: storeViewModel))
        self.locationViewModel = locationViewModel
    }
    
    var body: some View {
        ZStack {
            MapView(
                locationViewModel: locationViewModel,
                locations: mapViewModel.locationArray,
                selectedPlace: selectedPlace
            )
            .edgesIgnoringSafeArea(.top)
            .frame(maxHeight: .infinity)
            VStack {
                VStack(spacing: 0) {
                    HStack {
                        TextField("Search for a location", text: $searchText,
                                  onCommit: {
                            fetchPredictions()
                        }).onChange(of: searchText) { newValue in
                            fetchPredictions()
                        }
                        .padding()
                        .background(Color(UIColor.systemBackground)) // Adapts to dark mode
                        .foregroundColor(.primary) // Adapts text color
                        .cornerRadius(30)
                        .shadow(radius: 3)
                        Button(action: {
                            fetchPredictions()
                        }) {
                            Image(systemName: "magnifyingglass") // Lens icon
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .clipShape(Circle()) // Makes the background circular
                        }
                    }
                    .padding()
                    
                    
                    if !predictions.isEmpty {
                        List(predictions, id: \.placeID) { prediction in
                            VStack(alignment: .leading) {
                                Text(prediction.attributedPrimaryText.string)
                                    .font(.body)
                                if let secondaryText = prediction.attributedSecondaryText {
                                    Text(secondaryText.string)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                            .onTapGesture {
                                self.searchText = ""
                                self.selectPrediction(prediction)
                                UIApplication.shared.endEditing()
                            }
                        }
                        .frame(maxHeight: 400)
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(radius: 3)
                        .padding(.horizontal)
                    }
                }
                
                Spacer()
            }
        }
        .customPopup(isPresented: $isPopupPresented) {
            VStack{
                
                Text("Would you like to save this location to your favorites!")
                    .font(.headline)
                    .padding()
                    .lineLimit(nil)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                
                VStack{
                    Text("\(selectedPlaceName ?? "Unkwown")")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .fontWeight(.bold)
                        .padding()
                    
                    Text("Latitude \(String(format: "%.2f", selectedPlace?.latitude ?? 0.0))\nLongitude \(String(format: "%.2f", selectedPlace?.longitude ?? 0.0))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .fontWeight(.bold)
                    
                    
                }
                HStack{
                    Button(action: {
                        isPopupPresented = false
                    }) {
                        Text("Dismiss")
                            .foregroundColor(.blue)
                            .padding()
                            .background(Color(UIColor.secondarySystemBackground))
                            .cornerRadius(8)
                    }
                    Spacer()
                    Button(action: {
                        isPopupPresented = false
                        saveToFavourites()
                    }) {
                        HStack {
                            Image(systemName:   "heart"  )
                                .foregroundColor(.white)
                                .padding(.leading, 10)
                            Text("Save")
                                .foregroundColor(.white)
                                .padding([.trailing, .bottom, .top])
                            
                        }
                    } .background(Color.blue)
                        .cornerRadius(8)
                }.padding(.top, 10)
                
            }.padding()
                .background(Color(UIColor.systemBackground))
                .cornerRadius(10)
                .frame(maxWidth: UIScreen.main.bounds.width * 0.8)
                .alignmentGuide(.leading) { d in d[.leading] }
        }
    }
    
    private func fetchPredictions() {
        guard !searchText.isEmpty else {
            predictions.removeAll()
            return
        }
        
        let filter = GMSAutocompleteFilter()
        filter.types = []
        
        placesClient.findAutocompletePredictions(fromQuery: searchText, filter: filter, sessionToken: nil) { results, error in
            if let error = error {
                print("Error fetching predictions: \(error.localizedDescription)")
                return
            }
            
            predictions = results ?? []
        }
    }
    
    
    private func selectPrediction(_ prediction: GMSAutocompletePrediction) {
        fetchPlaceDetails(for: prediction.placeID)
        predictions.removeAll()
    }
    
    private func fetchPlaceDetails(for placeID: String) {
        let placeFields: GMSPlaceField = [.coordinate, .name]
        
        placesClient.fetchPlace(fromPlaceID: placeID, placeFields: placeFields, sessionToken: nil) { place, error in
            
            if let error = error {
                // display This Error if encountered
                print("Error fetching place details: \(error.localizedDescription)")
                return
            }
            
            if let place = place {
                isPopupPresented.toggle()
                selectedPlaceName = place.name ?? ""
                selectedPlace = place.coordinate
            }
        }
    }
    
    
    private func saveToFavourites() {
        
        if let latitude = selectedPlace?.latitude,
           let longitude = selectedPlace?.longitude,
           let placeName = selectedPlaceName {
            mapViewModel.addFavouriteLocation(Name: placeName, Latitude: latitude, Longitude: longitude)
        } else {
            print("Error: Latitude or Longitude is nil.")
        }
        
    }
}
