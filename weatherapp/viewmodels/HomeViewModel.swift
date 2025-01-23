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
    
    @Published var errorMessage: String?
    @Published var activeLocationData: LocationDataStore?
    @Published var activeWeatherData: WeatherDataStore?
    
    
    init(locationViewModel: LocationViewModel, apiViewModel: ApiViewModel, storeViewModel: StoreViewModel) {
        self.locationViewModel = locationViewModel
        self.apiViewModel = apiViewModel
        self.storeViewModel = storeViewModel
        
        locationViewModel.$currentLocation
            .compactMap { $0 } 
            .sink { [weak self] location in
                
                self?.fetchWeatherData(Latitude: location.latitude, Longitude: location.longitude)
            }
            .store(in: &cancellables)
    }
    
    
    func fetchWeatherData(Latitude latitude: Double? = nil, Longitude longitude: Double? = nil) {
        if let latitude = latitude,
           let longitude = longitude {
            
            apiViewModel.getWeatherInCurrentLocation(latitude: latitude, longitude: longitude, units: "metric") { result in
                
                let locationId = UUID()
                
                switch result {
                case .success(let weatherResponse):
                    let liveLocation =  self.storeLocationData(LocationId: locationId, WeatherResponse: weatherResponse)
                    self.activeLocationData = liveLocation
                    self.activeWeatherData = self.storeWeatherData(WeatherResponse: weatherResponse, LocationId: locationId)
                    self.fetchForecastData(LiveLocation: liveLocation)
                    self.errorMessage = nil
                    
                case .failure(let error):
                    // fetch saved data and update
                    self.errorMessage = error.localizedDescription
                }
                
            }
            
        }
        else
        {
            //returen database data
            self.errorMessage = "Unable to fetch weather data."
        }
    }
    
    
    func fetchForecastData(LiveLocation liveLocation: LocationDataStore) {
        
        if let latitude = locationViewModel.currentLocation?.latitude,
           let longitude = locationViewModel.currentLocation?.longitude {
            
            apiViewModel.getFiveDaysFocast(latitude: latitude, longitude: longitude, units: "metric"){ result in
                
                switch result {
                case .success(let forecastData):
                    forecastData.list.forEach { forecast in
                        
                        if let isFuture = self.isDateFuture(WeatherDate: forecast.dt_txt){
                            
                            if isFuture {
                                self.storeForecastWeatherData(OriginalList: forecast, LocationId: liveLocation.id!)
                                
                            }else{
                                print("Date discarded: \(forecast.dt_txt)")
                            }
                            
                        }
                        
                    }
                    self.errorMessage = nil
                    
                case .failure(let error):
                    //Return focast data from database
                    print("fetchForecastData FAILED: \(error.localizedDescription)")
                    self.errorMessage = error.localizedDescription
                }
                
            }
            
        }
        else {
            //self.forecastData = nil
            //Return focast data from database
            self.errorMessage = "Unable to fetch forecast data."
        }
    }
    
    
    
    
    func storeLocationData(LocationId locationId: UUID,  WeatherResponse weatherResponse: WeatherResponse) -> LocationDataStore {
        print("storeLocationData: called ")
        return storeViewModel.addLocationData(
            LocationId: locationId,
            Name: weatherResponse.name,
            Latitude: weatherResponse.coord.lat,
            Longitude: weatherResponse.coord.lon,
            Active: true,
            IsFavourite: false,
            LastUpdated: Date()
        )
        
    }
    
    
    func storeWeatherData(WeatherResponse weatherResponse: WeatherResponse, LocationId locationId: UUID) -> WeatherDataStore {
        return storeViewModel.addWeatherData(
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
