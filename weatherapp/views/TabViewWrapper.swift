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
        
        VStack {
            
            TabView {
                HomeView(locationViewModel: locationViewModel, apiViewModel: apiViewModel, storeViewModel: storeViewModel).tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
                // Map tab
                MapContainerView(locationViewModel: locationViewModel)
                    .tabItem {
                        Image(systemName: "map")
                        Text("Favourites")
                    }
                
                
                
                SettingsView().tabItem {
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
