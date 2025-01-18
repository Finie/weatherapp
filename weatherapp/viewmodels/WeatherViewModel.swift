//
//  WeatherViewModel.swift
//  weatherapp
//
//  Created by fin on 18/01/2025.
//

import Foundation
import CoreData


class WeatherViewModel: ObservableObject {
    private let viewContext = PersistenceController.shared.viewContext
    
    @Published var weatherData: [WeatherDataStore] = []
    
    init() {
        fetchWeatherData()
    }
    
    func fetchWeatherData() {
        let fetchRequest: NSFetchRequest<WeatherDataStore> = WeatherDataStore.fetchRequest()
        do {
            weatherData = try viewContext.fetch(fetchRequest)
        }catch{
            print("DEBUG: Some error occurred while fetching: \(viewContext)")
        }
    }
    
    
    
    func addWeatherData(Latitude latitude: String, Longitude longitude: String, Weather weather: String, Location location: String) {
        
        
        let newweather = WeatherDataStore(context: viewContext)
        newweather.id = UUID()
        newweather.latitude =  latitude
        newweather.longitude =  longitude
        newweather.location =  location 
        newweather.weather =  weather
        
        save()
        self.fetchWeatherData()
    }
    
    
    func save(){
        do {
            try viewContext.save()
        } catch {
            print("DEBUG: Some error occurred while saving: \(error.localizedDescription)")
        }
    }
    
    
    
    
}
