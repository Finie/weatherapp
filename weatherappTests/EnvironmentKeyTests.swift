//
//  EnvironmentKeyTests.swift
//  weatherapp
//
//  Created by fin on 20/01/2025.
//

import XCTest



@testable import weatherapp
class EnviromentKeyTests: XCTestCase {
    
    
    func testShouldReturnApiUrl() throws {
        
        let expectedUrl = "https://google.com/"
 
        @EnvironmentKey("TEST_URL")
        var apiUrl: String
        
        XCTAssertEqual(apiUrl, expectedUrl)
       
    }
    
    
    func testShouldReturnApiKey() throws {
        
        let expectedKey = "1234567890"
        
        @EnvironmentKey("TEST_API_KEY")
        var apiKey: String
        
        XCTAssertEqual(apiKey, expectedKey)
    }
    
    
}
