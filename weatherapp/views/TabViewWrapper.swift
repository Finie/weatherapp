//
//  TabView.swift
//  weatherapp
//
//  Created by fin on 21/01/2025.
//

import SwiftUI

struct TabViewWrapper: View {
    
    @ObservedObject var locationViewModel: LocationViewModel
    @ObservedObject var apiViewModel: ApiViewModel
    @ObservedObject var storeViewModel: StoreViewModel 
    
    
    
    var body: some View {
        
        let favouriteViewModel = FavouriteViewModel(storeViewModel: storeViewModel) // Create FavouriteViewModel
               
        VStack {
            
            TabView {
                HomeView(locationViewModel: locationViewModel, apiViewModel: apiViewModel, storeViewModel: storeViewModel).tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
                // Map tab
                MapContainerView(locationViewModel: locationViewModel, storeViewModel: storeViewModel)
                    .tabItem {
                        Image(systemName: "map")
                        Text("Favourites")
                    }
                
                SettingsView(favouriteViewModel: favouriteViewModel).tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
            }
        }
    }
}


struct TabViewContainer_Previews: PreviewProvider {
    static var previews: some View {
        let mockViewModel = LocationViewModel()
        let apiMockViewModel = ApiViewModel()
        let storeMockViewModel = StoreViewModel()
        
        TabViewWrapper(locationViewModel: mockViewModel, apiViewModel:  apiMockViewModel, storeViewModel: storeMockViewModel)
    }
}
