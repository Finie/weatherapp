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
        
        // Create an instance of ViewModel
        // let weatherViewModel = WeatherViewModel()
        let locationViewModel = LocationViewModel()
        let apiViewModel = ApiViewModel()
        let storeViewModel = StoreViewModel()
    
        let tabViewWrapper = TabViewWrapper(locationViewModel: locationViewModel, apiViewModel: apiViewModel, storeViewModel: storeViewModel)
        
        // Embed the SwiftUI view in a UIHostingController
        let hostingController = UIHostingController(rootView: tabViewWrapper)
        
        // Add the hosting controller's view as a child
        addChild(hostingController)
        hostingController.view.frame = view.bounds
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
    }
  
    
}

