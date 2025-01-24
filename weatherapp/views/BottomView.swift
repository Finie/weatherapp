//
//  BottomView.swift
//  weatherapp
//
//  Created by fin on 24/01/2025.
//

import SwiftUI

struct BottomView: View {
    
    // Receive forecast data from the parent view
    @Binding var weatherDay: WeatherDataStore?
    @Binding var listWeatherData: [WeatherDataStore]
    
    var body: some View {
        
        VStack {
            HStack {
                VStack {
                    Text("\(String(format: "%.1f", weatherDay?.minTemp ?? 0.0))°C")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Min")
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity, alignment: .center)  // Center content of the VStack
                
                VStack {
                    Text("\(String(format: "%.1f", weatherDay?.feelsLike ?? 0.0))°C")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Current")
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity, alignment: .center)  // Center content of the VStack
                
                VStack {
                    Text("\(String(format: "%.1f", weatherDay?.maxTemp ?? 0.0))°C")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Max")
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                
            }
            .overlay(
                Divider()
                    .background(Color.white),
                alignment: .bottom
            )
            
            ForEach(listWeatherData) { weatherData in
                if let isFuture = isDateFuture(WeatherDate: weatherData.date) {
                    isFuture ? HStack {
                        
                        VStack{
                            Text("\(self.getDay(from: weatherData.date) ?? "Loading...")")
                                .font(.headline)
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundColor(.white)
                            
                            Text("\(self.getTime(from: weatherData.date) ?? "Loading...")")
                                .font(.caption)
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundColor(.white)
                        }
                        
                        Image(weatherData.weather == "Clouds" ? "partlysunny" : weatherData.weather == "Rain" ? "rain" : "clear" )
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 26)
                        
                        Text("\(String(format: "%.1f", weatherDay?.feelsLike ?? 0.0))°")
                            .font(.subheadline)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .listRowInsets(EdgeInsets()) : nil
                }
                
            }
            .frame(maxWidth: .infinity)
        }
        
        
    }
    
    func getDay(from dateString: String?) -> String? {
        print("Date: \(String(describing: dateString))")
        
        guard let dateString = dateString, !dateString.isEmpty else {
            return nil
        }
        
        let cleanedDateString = dateString.replacingOccurrences(of: " +0000", with: "")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if let date = dateFormatter.date(from: cleanedDateString) {
            let dayFormatter = DateFormatter()
            dayFormatter.dateFormat = "EEEE"
            let day = dayFormatter.string(from: date)
            return "\(day)"
        }
        
        return nil
    }
    
    
    func getTime(from dateString: String?) -> String? {
        
        guard let dateString = dateString, !dateString.isEmpty else {
            return nil
        }
        
        let cleanedDateString = dateString.replacingOccurrences(of: " +0000", with: "")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if let date = dateFormatter.date(from: cleanedDateString) {
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "hh:mm a"
            let time = timeFormatter.string(from: date)
            
            return "\(time)"
        }
        
        return nil
    }
    
    
    
    func isDateFuture(WeatherDate dateString: String?) -> Bool? {
        guard let dateString = dateString else {
            return false
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        
        guard let parsedDate = dateFormatter.date(from: dateString) else {
            
            return false
        }
        let currentDate = Date()
        
        return parsedDate >= currentDate
    }
    
    
}
