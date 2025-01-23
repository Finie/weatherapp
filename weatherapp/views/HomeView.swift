//
//  HomeView.swift
//  weatherapp
//
//  Created by fin on 21/01/2025.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var homeViewModel: HomeViewModel
    
    
    init(locationViewModel: LocationViewModel, apiViewModel: ApiViewModel, storeViewModel: StoreViewModel) {
        _homeViewModel = StateObject(wrappedValue: HomeViewModel(locationViewModel: locationViewModel, apiViewModel: apiViewModel,storeViewModel: storeViewModel))
    }
    
    
    var body: some View {
        VStack{
            
            Text("This is Home Page")
                .font(.headline)
                .fontWeight(.heavy)
                .padding(.all, 20)
            
            Text("Your current Location is")
                .font(.body)
                .fontWeight(.heavy)
                .padding(.all, 20)
            
            
            
            Text("Location name: \(homeViewModel.activeLocationData?.name ?? "unavailable")")
                .font(.body)
                .fontWeight(.heavy)
                .padding(.all, 16)
            
            
            Text("Feels like: \(homeViewModel.activeWeatherData?.feelsLike ?? 0.0)°c")
                .font(.body)
                .fontWeight(.heavy)
                .padding(.all, 16)
            
            Text("Weather: \(homeViewModel.activeWeatherData?.weather ?? "Loading...")")
                .font(.body)
                .fontWeight(.heavy)
                .padding(.all, 16)
            
            
            
            Text("Condition: \(homeViewModel.activeWeatherData?.condition ?? "loading...")")
                .font(.body)
                .fontWeight(.heavy)
                .padding(.all, 16)
            
            
    
            
            
        }.onAppear(){
            homeViewModel.fetchWeatherData()
        }
    }
}
