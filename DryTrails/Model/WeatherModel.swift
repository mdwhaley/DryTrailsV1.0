//
//  WeatherModel.swift
//  DryTrails
//
//  Created by Michael Whaley on 6/29/23.
//

import Foundation

struct WeatherModel {
    let temperature: Double
    let temperature_2m_min: Double
    let temperature_2m_max: Double
    let precipitation_sum: [Double]
    let time: [String]
    let sunrise: [String]
    let sunset: [String]
    let weathercode: Int
    let timeHour: [String]
    let soil_moisture_1_3cm: [Double]
    let currentTime = Date()
    let dateFormatter = DateFormatter()
    
    var temperatureString: String {
        return String(format: "%.0f", temperature) + degreesString
    }
    var loTemperatureString: String {
        return String(format: "%.0f", temperature_2m_min) + degreesString
    }
    var hiTemperatureString: String {
        return String(format: "%.0f", temperature_2m_max) + degreesString
    }
    var sunRiseString: String {
        return "Sunrise: " + String(sunrise[3].dropFirst(11))
    }
    var sunSetString: String {
        return "Sunset: " + String(sunset[3].dropFirst(11))
    }
    var degreesString: String {
        switch UserDefaults.standard.bool(forKey: "notMetric") {
        case true:
            return "°F"
        default:
            return "°C"
        }
    }
    var precipitationString: String {
        switch UserDefaults.standard.bool(forKey: "notMetric") {
        case true:
            return "\""
        default:
            return "mm"
        }
    }
    
    var precipitationFormat: String {
        switch UserDefaults.standard.bool(forKey: "notMetric") {
        case true:
            return "%.2f"
        default:
            return "%.0f"
        }
    }
    // Working on using a moon and star image for clear conditions before sunrise and after sunset. Need to convert date string to time valiue and compare
//    func isDaylight(sunrise: Date, sunset: Date) -> Bool {
//        let currentTime = Date()
//        return currentTime > sunrise && currentTime < sunset
//    }

    var conditionName: String {
        switch weathercode {
        case 0:
            //Clear Sky
            if currentTime > dateFormatter.date(from: sunrise[3]) ?? Date() && currentTime < dateFormatter.date(from: sunset[3]) ?? Date() {
                return "sun.max"
            } else {
                return "moon.stars"
            }
        case 1...3:
            //Mainly clear, partly cloudy, and overcast
            return "cloud.sun"
        case 45...48:
            //Fog and depositing rime fog
            return "cloud.fog"
        case 51...55:
            //Drizzle: Light, moderate, and dense intensity
            return "cloud.drizzle"
        case 56...57:
            //Freezing Drizzle: Light and dense intensity
            return "cloud.sleet"
        case 61...65:
            //Rain: Slight, moderate and heavy intensity
            return "cloud.rain"
        case 66...67:
            //Freezing Rain: Light and heavy intensity
            return "cloud.sleet"
        case 71...75:
            //Snow fall: Slight, moderate, and heavy intensity
            return "snow"
        case 77:
            //Snow grains
            return "snow"
        case 80...82:
            //Rain showers: Slight, moderate, and violent
            return "cloud.rain"
        case 85...86:
            //Snow showers slight and heavy
            return "cloud.snow"
        case 95:
            //Thunderstorm: Slight or moderate
            return "cloud.bolt"
        case 96...99:
            //Thunderstorm with slight and heavy hail
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
}
