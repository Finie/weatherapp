//
//  HoneViewContent.swift
//  weatherapp
//
//  Created by fin on 24/01/2025.
//

import SwiftUI

struct HomeViewContent: View {
    
    @Binding var weatherDay: WeatherDataStore?
    @Binding var listWeatherData: [WeatherDataStore]
    @Binding var errorMessage: String?
     
    
    var body: some View {
        VStack{
            ZStack {
                Group {
                    switch self.weatherDay?.weather {
                    case "Clear":
                        Image("forest_sunny")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                        
                    case "Rain":
                        Image("forest_rainy")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    case "Clouds":
                        Image("forest_cloudy")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    default:
                        Image("forest_sunny")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    }
                }
                .frame(width: UIScreen.main.bounds.width)
                .edgesIgnoringSafeArea(.top)
                GeometryReader { geometry in
                   
                    

                    VStack {
                        Text("\(String(format: "%.1f", weatherDay?.feelsLike ?? 0.0))°C")
                            .font(.system(size: 50, weight: .heavy))
                            .foregroundColor(.white)
                            .shadow(radius: 5)
                        
                        Text("\(weatherDay?.condition ?? "unavailable" )".capitalized)
                            .font(.caption)
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                            .shadow(radius: 5)
                        
                        
                        Text("\(weatherDay?.weather ?? "unavailable" )".uppercased() )
                            .font(.title)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .shadow(radius: 5)
                        
                      
                    }
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                    .padding(.top, geometry.size.height * 0.25)
                }
            }
            .frame(width: UIScreen.main.bounds.width)
            .edgesIgnoringSafeArea(.top)
            
            
            ScrollView {
                if !listWeatherData.isEmpty {
                    BottomView(weatherDay: $weatherDay, listWeatherData: $listWeatherData)
                } else {
                    VStack {
                        Text(errorMessage ??  "Loading...")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.clear)
                    .contentShape(Rectangle())
                    .multilineTextAlignment(.center)
                }
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        
    }
}
