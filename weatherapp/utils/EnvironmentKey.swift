//
//  EnvironmentKey.swift
//  weatherapp
//
//  Created by fin on 20/01/2025.
//

import Foundation



@propertyWrapper
struct EnvironmentKey<T: LosslessStringConvertible> {
    var wrappedValue: T
    
    init(_ key: String) {
        guard let stringValue = ProcessInfo.processInfo.environment[key],
              let value = T(stringValue)
        else {
            fatalError("Environment variable '\(key)' not found or not convertible to \(T.self)")
        }
        self.wrappedValue = value
    }
    
}
