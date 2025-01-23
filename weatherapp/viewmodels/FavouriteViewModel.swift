//
//  FavouriteViewModel.swift
//  weatherapp
//
//  Created by fin on 23/01/2025.
//
import Foundation


class FavouriteViewModel: ObservableObject {
    
    private var storeViewModel: StoreViewModel
    
    @Published var favouriteLocations: [LocationDataStore] = []
    
    init(storeViewModel: StoreViewModel) {
        self.storeViewModel = storeViewModel
    }
    
    
    
    
    func fetchFavouriteLocations() {
        self.favouriteLocations = storeViewModel.locationData
    }
    
}
