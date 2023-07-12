//
//  WeatherManager.swift
//  DryTrails
//
//  Created by Michael Whaley on 6/28/23.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}



struct WeatherManager {

    var delegate: WeatherManagerDelegate?
        
        func fetchWeather(latitude: Float, longitude: Float) {
            if (UserDefaults.standard.bool(forKey: "notMetric") == true) {
                let tempUnits = "fahrenheit"
                let windUnits = "mph"
                let precipitationUnits = "inch"
                let urlString = "https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&hourly=soil_moisture_1_3cm&daily=temperature_2m_max,temperature_2m_min,sunrise,sunset,precipitation_sum&current_weather=true&temperature_unit=\(tempUnits)&windspeed_unit=\(windUnits)&precipitation_unit=\(precipitationUnits)&past_days=3&forecast_days=3&timezone=auto"
                performRequest(with: urlString)
//                print(urlString)
//                print(UserDefaults.standard.bool(forKey: "notMetric"))
            } else if (UserDefaults.standard.bool(forKey: "notMetric") == false) {
                
                let urlString = "https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&hourly=soil_moisture_1_3cm&daily=temperature_2m_max,temperature_2m_min,sunrise,sunset,precipitation_sum&current_weather=true&past_days=3&forecast_days=3&timezone=auto"
                performRequest(with: urlString)
//                print(urlString)
//                print(UserDefaults.standard.bool(forKey: "notMetric"))
            }
        }
        
        
        func performRequest(with urlString: String) {
            if let url = URL(string: urlString) {
                let session = URLSession(configuration: .default)
                let task = session.dataTask(with: url) { (data, response, error) in
                    if error != nil {
                        self.delegate?.didFailWithError(error: error!)
                        return
                    }
                    if let safeData = data {
                        if let weather = self.parseJSON(safeData) {
                            self.delegate?.didUpdateWeather(self, weather: weather)
                        }
                    }
                }
                task.resume()
            }
        }
        
        func parseJSON(_ weatherData: Data) -> WeatherModel? {
            let decoder = JSONDecoder()
            do {
                let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
                let temp = decodedData.current_weather.temperature
                let conditionName = decodedData.current_weather.weathercode
                let minTemp = decodedData.daily.temperature_2m_min[3]
                let maxTemp = decodedData.daily.temperature_2m_max[3]
                let dailyRain = decodedData.daily.precipitation_sum
                let dates = decodedData.daily.time
                let sunriseTime = decodedData.daily.sunrise
                let sunsetTime = decodedData.daily.sunset
                let hour = decodedData.hourly.time
                let soilMoisture = decodedData.hourly.soil_moisture_1_3cm
                let weather = WeatherModel(temperature: temp, temperature_2m_min: minTemp, temperature_2m_max: maxTemp, precipitation_sum: dailyRain, time: dates, sunrise: sunriseTime, sunset: sunsetTime, weathercode: conditionName, timeHour: hour, soil_moisture_1_3cm: soilMoisture)
                return weather
                
            } catch {
                delegate?.didFailWithError(error: error)
                return nil
            }
        }
    }

