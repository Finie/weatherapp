//
// StoreViewModel.swift
//  weatherapp
//
//  Created by fin on 18/01/2025.
//

import Foundation
import CoreData

class StoreViewModel: ObservableObject {
    private let viewContext = PersistenceController.shared.viewContext
    
    private var errorMessage: String?
    
    @Published var weatherData: [WeatherDataStore]? = []
    @Published var locationData: [LocationDataStore] = []
    @Published var activeLocation: LocationDataStore?
    @Published var activeWeather: WeatherDataStore?
    
    
    init() {
        fetchWeatherData()
        fetchLocationData()
        fetchActiveLocationData()
        fetchActiveWeatherData()
        fetchInActiveWeatherData()
    }
    
    
    func fetchActiveLocationData(){
        let fetchRequest: NSFetchRequest<LocationDataStore> = LocationDataStore.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "active == %@", NSNumber(value: true))
        fetchRequest.fetchLimit = 1
        
        do {
            if let activeLocation = try viewContext.fetch(fetchRequest).first {
                self.activeLocation = activeLocation
            } else {
                print("No active location found.")
                self.errorMessage = "No active location found."
            }
        } catch {
            print("Error fetching active location data: \(error)")
            self.errorMessage = "Error fetching active location data: \(error)"
        }
    }
    
    
    
    func fetchActiveWeatherData(){
        let fetchRequest: NSFetchRequest<WeatherDataStore> = WeatherDataStore.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isActiveData == %@", NSNumber(value: true))
        fetchRequest.fetchLimit = 1
        
        do {
            if let activeWeather = try viewContext.fetch(fetchRequest).first {
                self.activeWeather = activeWeather
            } else {
                self.errorMessage = "No active location found."
            }
        } catch {
            print("Error fetching active location data: \(error)")
            self.errorMessage = "Error fetching active location data: \(error)"
        }
    }
    
    
    
    func fetchInActiveWeatherData(){
        let fetchRequest: NSFetchRequest<WeatherDataStore> = WeatherDataStore.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isActiveData == %@", NSNumber(value: false))
        
        do {
            
            let inActiveWeather = try viewContext.fetch(fetchRequest)
            self.weatherData = inActiveWeather
            print("inActiveWeather Count: \(inActiveWeather.count)")
            
            if inActiveWeather.isEmpty{
                print("No active location found.")
                self.errorMessage = "No active location found."
            }
            
        }
        catch {
            print("Error fetching active location data: \(error)")
            self.errorMessage = "Error fetching active location data: \(error)"
        }
    }
    
    
    func fetchLocationData(){
        let fetchRequest: NSFetchRequest<LocationDataStore> = LocationDataStore.fetchRequest()
        do{
            locationData = try viewContext.fetch(fetchRequest)
            print("Location Count: \(locationData.count)")
        }catch{
 
                self.errorMessage = "Failed to load data \(error.localizedDescription)"
 
        }
    }
    
    
    
    func fetchWeatherData() {
        let fetchRequest: NSFetchRequest<WeatherDataStore> = WeatherDataStore.fetchRequest()
        do {
            weatherData = try viewContext.fetch(fetchRequest)
        }catch{
 
                self.errorMessage = "Failed to load data \(error.localizedDescription)"
 
        }
    }
    
    func addLocationData(
        LocationId locationId: UUID,
        Name name: String,
        Latitude latitude: Double,
        Longitude longitude: Double,
        Active active: Bool,
        IsFavourite isFavourite:Bool,
        LastUpdated lastUpdated: Date) -> LocationDataStore {
        
        if let activeLocation = activeLocation {
            
            activeLocation.name = name
            activeLocation.latitude = latitude
            activeLocation.longitude = longitude
            activeLocation.active = active
            activeLocation.lastUpdated = lastUpdated
            activeLocation.isFavourite = isFavourite
            
            
            save()
            fetchLocationData()
            
            print("Updated active location: \(activeLocation)")
            return activeLocation
        }
        
        
        
        let newLocationData = LocationDataStore(context: viewContext)
        newLocationData.id = locationId
        newLocationData.name = name
        newLocationData.active = active
        newLocationData.latitude = latitude
        newLocationData.longitude = longitude
        newLocationData.lastUpdated = lastUpdated
        newLocationData.isFavourite = isFavourite
        
        save()
        fetchLocationData()
        
        print("New active location \(newLocationData)")
        return newLocationData
    }
    
    
    
    
    
    func addWeatherData(Condition condition: String,
                        Weather weather: String,
                        FeelsLike feelsLike: Double,
                        MaxTemp maxTemp: Double,
                        MinTemp minTemp: Double,
                        IsActiveData isActiveData: Bool,
                        LocationId locationId: UUID,
                        Date date: String) -> WeatherDataStore {
        
        if let activeWeather = activeWeather {
            
            activeWeather.weather =  weather
            activeWeather.condition = condition
            activeWeather.date = "\(date)"
            activeWeather.feelsLike = feelsLike
            activeWeather.isActiveData = isActiveData
            activeWeather.maxTemp = maxTemp
            activeWeather.minTemp = minTemp
            activeWeather.locationId = locationId
            
            save()
            fetchWeatherData()
            
            return activeWeather
        }
        
        
        
        let newweather = WeatherDataStore(context: viewContext)
        newweather.id = UUID()
        newweather.weather =  weather
        newweather.condition = condition
        newweather.date = "\(date)"
        newweather.feelsLike = feelsLike
        newweather.isActiveData = isActiveData
        newweather.maxTemp = maxTemp
        newweather.minTemp = minTemp
        newweather.locationId = locationId
        
        save()
        fetchWeatherData()
        
        return newweather
        
    }
    
    
    func addWForecasteatherData(Condition condition: String,
                                Weather weather: String,
                                FeelsLike feelsLike: Double,
                                MaxTemp maxTemp: Double,
                                MinTemp minTemp: Double,
                                IsActiveData isActiveData: Bool,
                                LocationId locationId: UUID,
                                Date date: String) {
        
        guard let weatherList = weatherData else {
            print("Weather data list is nil.")
            return
        }
        
        if let existingWeather = weatherList.first(where: { $0.date == date }) {
            
            existingWeather.condition = condition
            existingWeather.weather = weather
            existingWeather.feelsLike = feelsLike
            existingWeather.maxTemp = maxTemp
            existingWeather.minTemp = minTemp
            existingWeather.isActiveData = isActiveData
            existingWeather.date = date
            
            print("Updated existing weather data for date: \(date)")
            
        }
        else{
            
            let newWeatherData = WeatherDataStore(context: viewContext)
            newWeatherData.id = UUID()
            newWeatherData.date = date
            newWeatherData.condition = condition
            newWeatherData.weather = weather
            newWeatherData.feelsLike = feelsLike
            newWeatherData.maxTemp = maxTemp
            newWeatherData.minTemp = minTemp
            newWeatherData.isActiveData = isActiveData
            
            print("Created new weather data for date: \(date)")
        }
        
        save()
        fetchWeatherData()
        
    }
    
    
    
    func addFavouriteLocation(
        LocationId locationId: UUID,
        Name name: String,
        Latitude latitude: Double,
        Longitude longitude: Double,
        Active active: Bool,
        IsFavourite isFavourite:Bool,
        LastUpdated lastUpdated: Date) {
        
        
        let newLocationData = LocationDataStore(context: viewContext)
        newLocationData.id = locationId
        newLocationData.name = name
        newLocationData.active = active
        newLocationData.latitude = latitude
        newLocationData.longitude = longitude
        newLocationData.lastUpdated = lastUpdated
        newLocationData.isFavourite = isFavourite
        
        save()
        fetchLocationData()
        print("Added new favourite location \(newLocationData)")
    }
    
    
    
    
    func save(){
        do {
            try viewContext.save()
        } catch {
            print("Saving Failed: \(error.localizedDescription)")
                self.errorMessage = "Store Failed: \(error.localizedDescription)"
        }
    }
}
