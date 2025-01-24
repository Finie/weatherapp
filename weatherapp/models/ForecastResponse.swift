//
//  ForecastResponse.swift
//  weatherapp
//
//  Created by fin on 20/01/2025.
//

import Foundation

struct ForecastResponse: Codable {
    let cod: String
    let message: Double
    let cnt: Int
    let list: [OriginalList]
    let city: OriginalCity
    
    enum CodingKeys: String, CodingKey {
        case cod
        case message
        case cnt
        case list
        case city
    }
}

struct OriginalList: Codable {
    let dt: Int
    let main: OriginalMain
    let weather: [OriginalWeather]
    let clouds: OriginalClouds
    let wind: OriginalWind
    let visibility: Int
    let pop: Double
    let sys: Sys
    let dt_txt: String
    
    // Map "dt_txt" to camelCase
    private enum CodingKeys: String, CodingKey {
        case dt, main, weather, clouds, wind, visibility, pop, sys
        case dt_txt = "dt_txt"
    }
}

struct OriginalMain: Codable {
    let temp: Double
    let temp_min: Double
    let feels_like: Double
    let temp_max: Double
    let pressure: Double
    let sea_level: Double
    let grnd_level: Double
    let humidity: Int
    let temp_kf: Double
    
    enum CodingKeys: String, CodingKey {
        case temp
        case temp_min
        case temp_max
        case feels_like
        case pressure
        case sea_level
        case grnd_level
        case humidity
        case temp_kf
    }
}

struct OriginalWeather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case main
        case description
        case icon
    }
}

struct OriginalClouds: Codable {
    let all: Int
    
    enum CodingKeys: String, CodingKey {
        case all
    }
}

struct OriginalWind: Codable {
    let speed: Double
    let deg: Double
    
    enum CodingKeys: String, CodingKey {
        case speed
        case deg
    }
}

struct OriginalSnow: Codable {}

struct OriginalSys: Codable {
    let pod: String
    
    enum CodingKeys: String, CodingKey {
        case pod
    }
}

struct OriginalCity: Codable {
    let id: Int
    let name: String
    let coord: OriginalCoord
    let country: String?
    let population: Int
    let timezone: Int
    let sunrise: Int
    let sunset: Int
    
    
}

struct OriginalCoord: Codable {
    let lat: Double
    let lon: Double
    
    enum CodingKeys: String, CodingKey {
        case lat
        case lon
    }
}

