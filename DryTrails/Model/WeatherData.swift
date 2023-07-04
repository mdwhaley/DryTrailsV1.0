//
//  WeatherData.swift
//  DryTrails
//
//  Created by Michael Whaley on 6/29/23.
//

import Foundation

struct WeatherData: Codable {
    let current_weather: Main
    let daily: Daily
}

struct Main: Codable {
    let temperature: Double
    let weathercode: Int
}

struct Daily: Codable {
    let temperature_2m_max: [Double]
    let temperature_2m_min: [Double]
    let precipitation_sum: [Double]
    let time: [String]
    let sunrise: [String]
    let sunset: [String]
    //let weathercode: [Int]
}
