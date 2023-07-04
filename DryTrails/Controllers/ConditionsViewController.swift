//
//  ConditionsViewController.swift
//  DryTrails
//
//  Created by Michael Whaley on 6/6/23.
//

import UIKit
import Foundation

class ConditionsViewController: UIViewController {
    
    var weatherManager = WeatherManager()
    var name: String
    var lat: Float
    var lon: Float
    init?(coder: NSCoder, name: String, lat: Float, lon: Float) {
        self.name = name
        self.lat = lat
        self.lon = lon
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("No Location Selected")
    }
    
    
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var loTempLabel: UILabel!
    @IBOutlet weak var hiTempLabel: UILabel!
    
    @IBOutlet weak var conditionImage: UIImageView!
    
    @IBOutlet weak var sunRiseLabel: UILabel!
    @IBOutlet weak var sunSetLabel: UILabel!
    
    @IBOutlet weak var rainDay0Label: UILabel!
    @IBOutlet weak var rainDay1Label: UILabel!
    @IBOutlet weak var rainDay2Label: UILabel!
    @IBOutlet weak var rainDay3Label: UILabel!
    @IBOutlet weak var rainDay4Label: UILabel!
    @IBOutlet weak var rainDay5Label: UILabel!
    
    @IBOutlet weak var date0Label: UILabel!
    @IBOutlet weak var date1Label: UILabel!
    @IBOutlet weak var date2Label: UILabel!
    @IBOutlet weak var date3Label: UILabel!
    @IBOutlet weak var date4Label: UILabel!
    @IBOutlet weak var date5Label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationNameLabel.text = name
        weatherManager.delegate = self
        weatherManager.fetchWeather(latitude: lat, longitude: lon)
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
extension ConditionsViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperature.text = weather.temperatureString
            self.conditionImage.image = UIImage(systemName: weather.conditionName)
            self.hiTempLabel.text = weather.hiTemperatureString
            self.loTempLabel.text = weather.loTemperatureString
            self.sunRiseLabel.text = weather.sunRiseString
            self.sunSetLabel.text = weather.sunSetString
            
            self.rainDay0Label.text = "\(String(format: "\(weather.precipitationFormat)",weather.precipitation_sum[0]))\(weather.precipitationString)"
            self.rainDay1Label.text = "\(String(format: "\(weather.precipitationFormat)",weather.precipitation_sum[1]))\(weather.precipitationString)"
            self.rainDay2Label.text = "\(String(format: "\(weather.precipitationFormat)",weather.precipitation_sum[2]))\(weather.precipitationString)"
            self.rainDay3Label.text = "\(String(format: "\(weather.precipitationFormat)",weather.precipitation_sum[3]))\(weather.precipitationString)"
            self.rainDay4Label.text = "\(String(format: "\(weather.precipitationFormat)",weather.precipitation_sum[4]))\(weather.precipitationString)"
            self.rainDay5Label.text = "\(String(format: "\(weather.precipitationFormat)",weather.precipitation_sum[5]))\(weather.precipitationString)"
            
            self.date0Label.text = String(weather.time[0].dropFirst(5))
            self.date1Label.text = String(weather.time[1].dropFirst(5))
            self.date2Label.text = String(weather.time[2].dropFirst(5))
            self.date3Label.text = String(weather.time[3].dropFirst(5))
            self.date4Label.text = String(weather.time[4].dropFirst(5))
            self.date5Label.text = String(weather.time[5].dropFirst(5))
            
            //                self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            //                self.cityLabel.text = weather.cityName
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}





