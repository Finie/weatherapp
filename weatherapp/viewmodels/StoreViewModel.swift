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
    
    @Published var weatherData: [WeatherDataStore] = []
    @Published var locationData: [LocationDataStore] = [] 
    
   
    init() {
        fetchWeatherData()
        fetchLocationData()
    }
    
    func fetchLocationData(){
        let fetchRequest: NSFetchRequest<LocationDataStore> = LocationDataStore.fetchRequest()
        do{
            locationData = try viewContext.fetch(fetchRequest)
        }catch{
            DispatchQueue.main.async{
                self.errorMessage = "Failed to load data \(error.localizedDescription)"
            }
        }
    }
    
    
    func addLocationData(
        LocationId locationId: UUID,
        Name name: String,
        Latitude latitude: Double,
        Longitude longitude: Double,
        Active active: Bool,
        LastUpdated lastUpdated: Date)
    {
        
        let newLocationData = LocationDataStore(context: viewContext)
        
        newLocationData.id = locationId
        newLocationData.name = name
        newLocationData.active = active
        newLocationData.latitude = latitude
        newLocationData.longitude = longitude
        newLocationData.lastUpdated = lastUpdated
       
        print("Adding location data: \(newLocationData)")
        save()
        fetchLocationData()
        print("Location data added successfully and fetchLocationData was called.")
    }
    
    
    
    func updateActiveLocationData(LocationDataStore locationDataStore: LocationDataStore){
        
        let newLocationData = LocationDataStore(context: viewContext)
        newLocationData.latitude = locationDataStore.latitude
        newLocationData.longitude = locationDataStore.longitude
        newLocationData.name = locationDataStore.name
        newLocationData.lastUpdated = locationDataStore.lastUpdated
        
        
        
        
    }
    
    
    
    func fetchWeatherData() {
        let fetchRequest: NSFetchRequest<WeatherDataStore> = WeatherDataStore.fetchRequest()
        do {
            weatherData = try viewContext.fetch(fetchRequest)
        }catch{
            DispatchQueue.main.async{
                self.errorMessage = "Failed to load data \(error.localizedDescription)"
            }
        }
    }
    
    
    
    func addWeatherData(Condition condition: String,
                        Weather weather: String,
                        FeelsLike feelsLike: Double,
                        MaxTemp maxTemp: Double,
                        MinTemp minTemp: Double,
                        IsActiveData isActiveData: Bool,
                        LocationId locationId: UUID,
                        Date date: Date)
    {
    
        let newweather = WeatherDataStore(context: viewContext)
        newweather.id = UUID()
        newweather.weather =  weather
        newweather.condition = condition
        newweather.date = date
        newweather.feelsLike = feelsLike
        newweather.isActiveData = isActiveData
        newweather.maxTemp = maxTemp
        newweather.minTemp = minTemp
        newweather.locationId = locationId
        
        
        print("Adding weather data: \(newweather)")
        save()
        self.fetchWeatherData()
        print("Weather data added successfully and fetchWeatherData was called.")

    }
    
    
    func save(){
        do {
            try viewContext.save()
        } catch {
            DispatchQueue.main.async{
                self.errorMessage = "Store Failed: \(error.localizedDescription)"
            }
        }
    }
    
    
    func getErrorMessage() -> String? {
        return errorMessage
    }
    
    
}
