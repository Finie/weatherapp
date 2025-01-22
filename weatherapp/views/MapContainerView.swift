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
    @State private var searchText = ""
    @State private var predictions: [GMSAutocompletePrediction] = []
    @State private var selectedPlace: CLLocationCoordinate2D?
    @State private var selectedPlaceName: String?
    private let placesClient = GMSPlacesClient.shared()
    
    @State private var isPopupPresented = false
    
    
    var body: some View {
        ZStack {
            MapView(
                locationViewModel: locationViewModel,
                locations: locationViewModel.getLocationArray(),
                selectedPlace: selectedPlace
            )
            .edgesIgnoringSafeArea(.top)
            .frame(maxHeight: .infinity)
            VStack {
                VStack(spacing: 0) {
                    HStack {
                        TextField("Search for a location", text: $searchText, onCommit: {
                            fetchPredictions()
                        })
                        .padding()
                        .background(Color.white)
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
                                selectPrediction(prediction)
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
        }.customPopup(isPresented: $isPopupPresented) {
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
                        .foregroundColor(Color.black.opacity(0.5))
                        .fontWeight(.bold)
                        .padding()
                    
                    Text("Latitude \(selectedPlace?.latitude ?? 0.0)\nLongitude \(selectedPlace?.longitude ?? 0.0)")
                        .font(.caption)
                        .foregroundColor(Color.gray.opacity(0.7))
                        .fontWeight(.bold)
                    
                    
                }
                HStack{
                    Button(action: {
                        isPopupPresented = false
                    }) {
                        Text("Dismiss")
                            .foregroundColor(.blue)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                    }
                    Spacer()
                    Button(action: {
                        isPopupPresented = false
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
            .background(Color.white)
            .cornerRadius(10)
            .frame(maxWidth: UIScreen.main.bounds.width * 0.8)
            .alignmentGuide(.leading) { d in d[.leading] }
            
            
        }
    }
    
    // Fetch predictions as user types
    private func fetchPredictions() {
        guard !searchText.isEmpty else {
            predictions.removeAll()
            return
        }
        
        let filter = GMSAutocompleteFilter()
        filter.types = [] // Customize filter as needed
        
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
        searchText = prediction.attributedPrimaryText.string
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
}
