//
//  ViewController.swift
//  weatherapp
//
//  Created by fin on 18/01/2025.
//

import UIKit
import SwiftUI

class ViewController: UIViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Create an instance of WeatherViewModel
        let weatherViewModel = WeatherViewModel()
        let apiViewModel = ApiViewModel()
        
        
        apiViewModel.getWeatherInCurrentLocation(latitude: "-1.2828438285975219", longitude: "36.74014963992855", units: "metric"){
            [weak self] weather in
            switch weather {
            case .success(let weatherData):
                
                print("WeatherData is: "+String(describing: weatherData))
                
            case .failure(let error):
                print("Backend Response Error: \(error)")
            }
            
        }
        
        
        apiViewModel.getFiveDaysFocast(latitude: "-1.2828438285975219", longitude: "36.74014963992855", units: "metric", completion: {
            [weak self] forecast in
            
            switch forecast {
            case .success(let forecastData):
                
                print("ForecastData is: "+String(describing: forecastData))
                
            case .failure(let error):
                print("Backend Response Error: \(error)")
            }
        })
        
        // Initialize WeatherViewController with WeatherViewModel
        let weatherViewController = WeatherViewController(weatherViewModel: weatherViewModel)
        
        // Embed the SwiftUI view in a UIHostingController
        let hostingController = UIHostingController(rootView: weatherViewController)
        
        // Add the hosting controller's view as a child
        addChild(hostingController)
        hostingController.view.frame = view.bounds
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
    }
    
    
}

