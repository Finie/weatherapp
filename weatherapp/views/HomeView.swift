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
        VStack {
            HomeViewContent(weatherDay: $homeViewModel.activeWeatherData, listWeatherData: $homeViewModel.listWeatherData, errorMessage: $homeViewModel.errorMessage)
        }
        .alert(isPresented: $homeViewModel.showAlert) {
            AlertUtil.showAlert(message: homeViewModel.errorMessage ?? "Unknown Error occured", isPresented:$homeViewModel.showAlert)
        }
        .background(
            homeViewModel.activeWeatherData?.weather == "Clear"
            ?
            Color.sunny
            :
                homeViewModel.activeWeatherData?.weather == "Rain"
            ?
            Color.rainy
            :
                homeViewModel.activeWeatherData?.weather == "Clouds"
            ?
            Color.cloudy
            :
                Color.sunny
        )
        .onAppear {
            homeViewModel.fetchWeatherData()
        }
        
    }
}


