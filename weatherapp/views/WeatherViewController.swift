//
//  WeatherViewController.swift
//  weatherapp
//
//  Created by fin on 18/01/2025.
//
import SwiftUI


struct WeatherViewController :View {
    
    @ObservedObject var weatherViewModel: WeatherViewModel
    
    
    @State var location: String = ""
    @State var weather: String = ""
    
    
    
    init(weatherViewModel: WeatherViewModel) {
        self.weatherViewModel = weatherViewModel
    
    }
    
    
    
    
    var body: some View{
        NavigationView {
            VStack{
                HStack{
                    VStack(alignment: .leading){
                        
                        TextField("Enter location name", text:$location)
                            .font(.headline)
                            .padding(.leading)
                            .frame(height: 55)
                            .background(Color(uiColor: .systemGray5))
                            .cornerRadius(5)
                        
                        
                        TextField("Enter Weather condition", text:$weather)
                            .font(.headline)
                            .padding(.leading)
                            .frame(height: 55)
                            .background(Color(uiColor: .systemGray5))
                            .cornerRadius(5)
                        
                    }
                    
                }
                
                Spacer()
                
                
                // List to display the weather data
//                List(weatherViewModel.weatherData, id: \.id) { weather in
//                    Text("\(weather.location ?? "Unknown"): \(weather.weather ?? "No data")")
//                }
                
                Button{
                    
                    weatherViewModel.addWeatherData(Latitude: "-1.23039", Longitude: "36.8230", Weather: weather, Location: location)
                    
                    self.location = ""
                    self.weather = ""
                }label: {
                    Text("Add weather")
                }
            }
        }
    }
    
    
}
