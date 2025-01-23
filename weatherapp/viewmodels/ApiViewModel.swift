//
//  ApiViewModel.swift
//  weatherapp
//
//  Created by fin on 19/01/2025.
//
import Foundation

class ApiViewModel: ObservableObject {
    
    private let apiClient: ApiClient
    
    @EnvironmentKey("API_KEY")
    var apiKey:String
    
    
    
    
    init(apiClient: ApiClient = ApiClient.shared) {
        self.apiClient = apiClient
    }
    
    
    func getWeatherInCurrentLocation(latitude:Double, longitude:Double, units:String,  completion: @escaping (Result<WeatherResponse, Error>) -> Void){
        
        let parameters: [String: Any] = [
            "lat": latitude,
            "lon": longitude,
            "appid": apiKey,
            "units": units
        ]
        
        apiClient.request(endpoint: "/data/2.5/weather/", method: NetworkMethod.GET, parameters: parameters) {
            [weak self] (result:Result<WeatherResponse, Error>) in
            switch result {
            case .success(let value):
                completion(.success(value))
            case .failure(let error):
                completion(.failure(error))
            }
            
        }
        
    }
    
    
    
    func getFiveDaysFocast(latitude:Double, longitude:Double, units:String,  completion: @escaping (Result<ForecastResponse, Error>) -> Void){
        
        let parameters: [String: Any] = [
            "lat": latitude,
            "lon": longitude,
            "appid": apiKey,
            "units": units
        ]
        
        
        apiClient.request(endpoint: "/data/2.5/forecast/", method: NetworkMethod.GET, parameters: parameters, completion: {
            [weak self] (result:Result<ForecastResponse, Error>) in
            switch result {
            case .success(let data):
       
                completion(.success(data))
            case .failure(let error):
        
                completion(.failure(error))
            }
            
        })
    }
}
