//
//  WeatherDataStore.swift
//  weatherapp
//
//  Created by fin on 18/01/2025.
//


import Foundation
import CoreData

@objc(WeatherDataStore)
public class WeatherDataStore: NSManagedObject {
    // No need to define properties here, as they will be in the extension
}

extension WeatherDataStore {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeatherDataStore> {
        return NSFetchRequest<WeatherDataStore>(entityName: "WeatherDataStore")
    }

    @NSManaged public var id: UUID
    @NSManaged public var longitude: String
    @NSManaged public var latitude: String
    @NSManaged public var location: String 
    @NSManaged public var weather: String
}
