//
//  SettingsView.swift
//  weatherapp
//
//  Created by fin on 21/01/2025.
//

import SwiftUI

struct SettingsView: View {
    
    @ObservedObject var favouriteViewModel: FavouriteViewModel
    
    
    var body: some View {
        
        NavigationView { // Add NavigationView
            VStack {
                List {
                    ForEach(favouriteViewModel.favouriteLocations, id: \.id) {
                        location in
                        
                        FavouriteLocationRow(location: location)
                        
                    }
                    .onDelete { indexSet in
                        if let index = indexSet.first {
                            let location = favouriteViewModel.favouriteLocations[index]
                            if let locationId = location.id {
                                favouriteViewModel.deleteLocation(Byid: locationId)
                            }
                        }
                        
                    }
                }
                .listStyle(InsetGroupedListStyle())
            }
            .onAppear {
                favouriteViewModel.fetchFavouriteLocations()
            }
            .navigationTitle("Favourite")
        }
        
    }
}
