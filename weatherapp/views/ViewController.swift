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

