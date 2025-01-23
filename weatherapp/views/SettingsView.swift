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
 
        
        VStack{
//            Text("SettingsView")
       
            List(favouriteViewModel.favouriteLocations, id: \.id) { location in
                Text("\(location.name ?? "Unavailable")")
            }
        }.onAppear {
            favouriteViewModel.fetchFavouriteLocations()
        }
    }
}
