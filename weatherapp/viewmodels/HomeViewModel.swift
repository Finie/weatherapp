//
//  HomeViewModel.swift
//  weatherapp
//
//  Created by fin on 22/01/2025.
//
import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    private var apiViewModel: ApiViewModel
    private var locationViewModel: LocationViewModel
    private var storeViewModel: StoreViewModel
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var forecastData:ForecastResponse?
    @Published var weatherResponse: WeatherResponse?
    @Published var errorMessage: String?
    
    
    init(locationViewModel: LocationViewModel, apiViewModel: ApiViewModel, storeViewModel: StoreViewModel) {
        self.locationViewModel = locationViewModel
        self.apiViewModel = apiViewModel
        self.storeViewModel = storeViewModel
        
        locationViewModel.$currentLocation
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] location in
                self?.fetchWeatherData()
                self?.fetchForecastData()
            }
            .store(in: &cancellables)
    }
    
    
    func fetchWeatherData() {
        if let latitude = locationViewModel.currentLocation?.latitude,
           let longitude = locationViewModel.currentLocation?.longitude {
            
            apiViewModel.getWeatherInCurrentLocation(latitude: latitude, longitude: longitude, units: "metric") { result in
                let locationId = UUID()
               
                switch result {
                case .success(let weatherResponse):
                    self.storeLocationData(LocationId: locationId, WeatherResponse: weatherResponse)
                    self.storeWeatherData(WeatherResponse: weatherResponse, LocationId: locationId)
                    self.weatherResponse = weatherResponse
                    self.errorMessage = nil
                    
                case .failure(let error):
                    self.weatherResponse = nil
                    self.errorMessage = error.localizedDescription
                }
            }
            
        } else {
            self.weatherResponse = nil
            self.errorMessage = "Unable to fetch weather data."
        }
    }
    
    
    func fetchForecastData() {
        if let latitude = locationViewModel.currentLocation?.latitude,
           let longitude = locationViewModel.currentLocation?.longitude {
            
            apiViewModel.getFiveDaysFocast(latitude: latitude, longitude: longitude, units: "metric"){ result in
                switch result {
                case .success(let forecastData):
                    self.forecastData = forecastData
                    self.errorMessage = nil
                    
                case .failure(let error):
                    self.forecastData = nil
                    self.errorMessage = error.localizedDescription
                }
            }
            
        }
        else {
            self.forecastData = nil
            self.errorMessage = "Unable to fetch forecast data."
        }
    }
    
    
    
    
    func storeLocationData(LocationId locationId: UUID,  WeatherResponse weatherResponse: WeatherResponse) {
         
        storeViewModel.addLocationData(
            LocationId: locationId,
            Name: weatherResponse.name,
            Latitude: weatherResponse.coord.lat,
            Longitude: weatherResponse.coord.lon,
            Active: true,
            LastUpdated: Date())
         
    }
    
    
    func storeWeatherData(WeatherResponse weatherResponse: WeatherResponse, LocationId locationId: UUID) {
        
        storeViewModel.addWeatherData(
            Condition: weatherResponse.weather[0].description,
            Weather: weatherResponse.weather[0].main,
            FeelsLike: weatherResponse.main.feels_like,
            MaxTemp: weatherResponse.main.temp_max,
            MinTemp: weatherResponse.main.temp_min,
            IsActiveData: true,
            LocationId: locationId,
            Date: Date()
        )
    }
    
    
    
    func updateActiveLocationData(LocationDataStore locationDataStore: LocationDataStore) {
        
        
        
    }
    
    
    
    
}
