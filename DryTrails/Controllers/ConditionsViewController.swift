//
//  ConditionsViewController.swift
//  DryTrails
//
//  Created by Michael Whaley on 6/6/23.
//

import UIKit
import Foundation

class ConditionsViewController: UIViewController, WeatherManagerDelegate {
    var weatherManager = WeatherManager()
    var name: String
    var lat: Float
    var lon: Float
    
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var loTempLabel: UILabel!
    @IBOutlet weak var hiTempLabel: UILabel!
    @IBOutlet weak var conditionImage: UIImageView!
    @IBOutlet weak var sunRiseLabel: UILabel!
    @IBOutlet weak var sunSetLabel: UILabel!
    @IBOutlet var dateLabels: [UILabel]!
    @IBOutlet var precipitationLabels: [UILabel]!
    @IBOutlet weak var soilMoistureLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationNameLabel.text = name
        weatherManager.delegate = self
        weatherManager.fetchWeather(latitude: lat, longitude: lon)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
    }
    
    
    init?(coder: NSCoder, name: String, lat: Float, lon: Float) {
        self.name = name
        self.lat = lat
        self.lon = lon
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("No Location Selected")
    }
    
    
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
    DispatchQueue.main.async {
        self.temperature.text = weather.temperatureString
        self.conditionImage.image = UIImage(systemName: weather.conditionName)
        self.hiTempLabel.text = weather.hiTemperatureString
        self.loTempLabel.text = weather.loTemperatureString
        self.sunRiseLabel.text = weather.sunRiseString
        self.sunSetLabel.text = weather.sunSetString
        for (index, labels) in
                self.dateLabels.enumerated() {
                labels.text = String(weather.time[index].dropFirst(5))
        }
        for (index, labels) in
                self.precipitationLabels.enumerated() {
                labels.text = "\(String(format: "\(weather.precipitationFormat)",weather.precipitation_sum[index]))\(weather.precipitationString)"
        }
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        let result = formatter.string(from: date)
        let noMinuteResult = result.dropLast(2)
        let finalResult = noMinuteResult.appending("00")
        if let index = weather.timeHour.firstIndex(of: finalResult) {
            let soilMoisture = weather.soil_moisture_1_3cm[index]
            self.soilMoistureLabel.text = String(format: "%.1f %%", (soilMoisture * 100))
        }
    }
}
func didFailWithError(error: Error) {
    print(error)
}

    
    @IBAction func saveLocation(_ sender: UIBarButtonItem) {
        // Declare Alert message
        let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to save this location?", preferredStyle: .alert)
        dialogMessage.addTextField(configurationHandler: { textField in
            textField.placeholder = "\(self.name)"})
            // Create save button with action handler
        let save = UIAlertAction(title: "Save", style: .default, handler: { (action) -> Void in
            var userInput = dialogMessage.textFields?.first?.text ?? ""
            if (userInput != "") {
                self.name = userInput
            } else {
                userInput = self.name
            }
            CoreDataManager.shared.addLocation(name: self.name, latitude: self.lat, longitude: self.lon)
        })
        // Create Cancel button with action handlder
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
        }
        //Add OK and Cancel button to dialog message
        dialogMessage.addAction(save)
        dialogMessage.addAction(cancel)
        
        // Present dialog message to user
        self.present(dialogMessage, animated: true, completion: nil)
    }
}
//extension ConditionsViewController: WeatherManagerDelegate {
//    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
//        DispatchQueue.main.async {
//            self.temperature.text = weather.temperatureString
//            self.conditionImage.image = UIImage(systemName: weather.conditionName)
//            self.hiTempLabel.text = weather.hiTemperatureString
//            self.loTempLabel.text = weather.loTemperatureString
//            self.sunRiseLabel.text = weather.sunRiseString
//            self.sunSetLabel.text = weather.sunSetString
//            for (index, labels) in
//                    self.dateLabels.enumerated() {
//                    labels.text = String(weather.time[index].dropFirst(5))
//            }
//            for (index, labels) in
//                    self.precipitationLabels.enumerated() {
//                    labels.text = "\(String(format: "\(weather.precipitationFormat)",weather.precipitation_sum[index]))\(weather.precipitationString)"
//            }
//            let date = Date()
//            let formatter = DateFormatter()
//            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
//            let result = formatter.string(from: date)
//            let noMinuteResult = result.dropLast(2)
//            let finalResult = noMinuteResult.appending("00")
//            if let index = weather.timeHour.firstIndex(of: finalResult) {
//                let soilMoisture = weather.soil_moisture_1_3cm[index]
//                self.soilMoistureLabel.text = String(format: "%.1f %%", (soilMoisture * 100))
//            }
//        }
//    }
//    func didFailWithError(error: Error) {
//        print(error)
//    }
//}

