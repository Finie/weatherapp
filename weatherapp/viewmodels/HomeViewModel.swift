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
    
    @Published var showAlert = false
    @Published var errorMessage: String?
    @Published var activeLocationData: LocationDataStore?
    @Published var activeWeatherData: WeatherDataStore?
    @Published var listWeatherData: [WeatherDataStore] = []

    
    
    init(locationViewModel: LocationViewModel, apiViewModel: ApiViewModel, storeViewModel: StoreViewModel) {
        self.locationViewModel = locationViewModel
        self.apiViewModel = apiViewModel
        self.storeViewModel = storeViewModel
        
        locationViewModel.$currentLocation
            .compactMap { $0 }
            .sink { [weak self] location in
                self?.getCurrentStoredLocation()
                self?.fetchWeatherData(Latitude: location.latitude, Longitude: location.longitude)
            }
            .store(in: &cancellables)
    }
    
    
    func getWeatherData() {
        if let weatherData = storeViewModel.weatherData {
            self.listWeatherData = weatherData
        }
    }
    
    
    func getCurrentStoredLocation(){
        if let activeLocation = storeViewModel.activeLocation {
            
            print("ActiveLocation: \(activeLocation.name ?? "unavailable")")
            self.activeLocationData = activeLocation
            self.getCurrentActiveWeatherData()
        }
    }
    
    func getCurrentActiveWeatherData(){
        if let activeWeather = storeViewModel.activeWeather {
            self.activeWeatherData = activeWeather
        }
    }
    
    
    func getErrorMessage()  {
        if let errorMessage = storeViewModel.errorMessage {
            self.errorMessage = errorMessage
        }
    }
    
    
    func fetchWeatherData(Latitude latitude: Double? = nil, Longitude longitude: Double? = nil) {
 
        
        if let latitude = latitude,
           let longitude = longitude {
            
            apiViewModel.getWeatherInCurrentLocation(latitude: latitude, longitude: longitude, units: "metric") { result in
         
                
                switch result {
                    
                case .success(let weatherResponse):
                    
                    if  self.activeLocationData != nil {
                        
                        if let locationId = self.activeLocationData?.id {
                            self.storeLocationData(LocationId: locationId, WeatherResponse: weatherResponse)
                            self.storeWeatherData(WeatherResponse: weatherResponse, LocationId: locationId)
                        }
                    }
                    else{
                        let locationId = UUID()
                        self.storeLocationData(LocationId: locationId, WeatherResponse: weatherResponse)
                        self.storeWeatherData(WeatherResponse: weatherResponse, LocationId: locationId)
                    }
                    self.getCurrentStoredLocation()
                    self.fetchForecastData()
                    self.errorMessage = nil
                    
                case .failure(let error):
                    // fetch saved data and update
                    self.getWeatherData()
                    self.getCurrentActiveWeatherData()
                    self.getCurrentStoredLocation()
                    self.getCurrentActiveWeatherData()
                    DispatchQueue.main.async {
                        self.errorMessage = error.localizedDescription
                        self.showAlert = true
                    }
                }
            }
        }
    }
    
    
    func fetchForecastData() {
 
        if let latitude = activeLocationData?.latitude,
           let longitude = activeLocationData?.longitude,
           let locationId = activeLocationData?.id {
            
            apiViewModel.getFiveDaysFocast(latitude: latitude, longitude: longitude, units: "metric"){ result in
                
                switch result {
                case .success(let forecastData):
                    forecastData.list.forEach { forecast in
                        if let isFuture = self.isDateFuture(WeatherDate: forecast.dt_txt){
                            if isFuture {
                                self.storeForecastWeatherData(OriginalList: forecast, LocationId: locationId)
                            }
                            else{
                                print("Date discarded: \(forecast.dt_txt)")
                            }
                        }
                    }
                    self.getWeatherData()
                    self.errorMessage = nil
          
                    
                case .failure(let error):
                    //Return focast data from database
                    print("fetchForecastData FAILED: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        self.errorMessage = error.localizedDescription
                        self.showAlert = true
                    }
                }
                
            }
            
        }
    }
    
    
    func storeLocationData(LocationId locationId: UUID,  WeatherResponse weatherResponse: WeatherResponse) {
        print("storeLocationData: called \(locationId)")
        storeViewModel.addLocationData(
            LocationId: locationId,
            Name: weatherResponse.name,
            Latitude: weatherResponse.coord.lat,
            Longitude: weatherResponse.coord.lon,
            Active: true,
            IsFavourite: false,
            LastUpdated: Date()
        )
        
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
            Date: "\(Date())"
        )
    }
    
    
    func storeForecastWeatherData(OriginalList forecast: OriginalList, LocationId locationId: UUID){
        
        storeViewModel.addWForecasteatherData(
            Condition:forecast.weather[0].description,
            Weather: forecast.weather[0].main,
            FeelsLike: forecast.main.feels_like,
            MaxTemp: forecast.main.temp_max,
            MinTemp: forecast.main.temp_min,
            IsActiveData: false,
            LocationId: locationId,
            Date: forecast.dt_txt
        )
    }
    
    
    func isDateFuture(WeatherDate dateString: String) -> Bool? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        
        guard let parsedDate = dateFormatter.date(from: dateString) else {
            print("Invalid date string: \(dateString)")
            return false
        }
        let currentDate = Date()
        
        return parsedDate >= currentDate
    }
    
    
}
