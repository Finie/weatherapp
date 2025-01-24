# WeatherApp

## Description

This is a SwiftUI app that fetches weather data from the OpenWeatherMap API. It uses environment variables to manage sensitive information like API keys, ensuring secure handling of credentials

## Features

- Fetches real-time weather data from OpenWeatherMap.
- Stores weather data for offline display
- Uses environment variables for security.

## Prerequisites

Before running the app, ensure that you have the following installed:

- Xcode 12 or later.
- CocoaPods (if dependencies are used via CocoaPods).
- Swift 5.3 or later.

## Installation

### 1. Clone the Repository

Clone the repository to your local machine using the following command:

````bash
git clone https://github.com/Finie/weatherapp
cd weatherapp


### 2. Install Dependencies
in your terminal run the following command to install the dependencies: GoogleMap SDK and GooglePlace SDK
```pod install

### 3. Install Dependencies
You need to define these environment variables for your development and test environments.
- API_URL=https://api.openweathermap.org
- API_KEY=shared via email
- googleapikey=shared via email
- OS_ACTIVITY_MODE=disable

### 4. Test Environment
For the testing environment, you need to define the following test-specific API keys. These can be injected similarly through a .env file or directly into Xcode's test scheme environment variables.
 - TEST_API_KEY=1234567890
 - TEST_URL=https://google.com/
````
