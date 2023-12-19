//
//  LocationsViewController.swift
//  DryTrails
//
//  Created by Michael Whaley on 5/25/23.
//

import UIKit
import SwipeCellKit
import CoreLocation
import MapKit

class LocationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    var weatherUnits = 1
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        let unitsMetric = UserDefaults.standard.bool(forKey: "notMetric")
        unitsDefault.setOn(unitsMetric, animated: false)
        CoreDataManager.shared.fetchLocations()
        configureTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        locationsTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.rowHeight = 80
        return CoreDataManager.shared.locationsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! SwipeTableViewCell
        cell.textLabel?.text = "\(CoreDataManager.shared.locationsArray[indexPath.row].name ?? "Current Location")"
        cell.delegate = self
        cell.textLabel?.textColor = .black
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let name = CoreDataManager.shared.locationsArray[indexPath.row].name!
        let lat = CoreDataManager.shared.locationsArray[indexPath.row].latitude
        let lon = CoreDataManager.shared.locationsArray[indexPath.row].longitude
        guard let conditionsVC = self.storyboard?.instantiateViewController(identifier: "conditionsView", creator: { coder in
            return ConditionsViewController(coder: coder, name: name, lat: lat, lon: lon)
            
            }) else {
                fatalError("Failed to load conditionsView from storyboard.")
            }
        self.navigationController?.pushViewController(conditionsVC, animated: true)
    }
    
    
    @IBAction func locationButtonPressed(_ sender: UIButton) {
        locationManager.startUpdatingLocation()
//        locationManager.requestLocation()
    }
    func fetchCity(from location: CLLocation, completion: @escaping (_ city: String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            completion(placemarks?.first?.locality,
                       error)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let _: () = fetchCity(from: location) { city, error in
                guard let city = city, error == nil else { return }
                
                let lat = location.coordinate.latitude
                let lon = location.coordinate.longitude
                guard let conditionsVC = self.storyboard?.instantiateViewController(identifier: "conditionsView", creator: { coder in
                    return ConditionsViewController(coder: coder, name: city, lat: Float(lat), lon: Float(lon))
                    
                }) else {
                    fatalError("Failed to load conditionsView from storyboard.")
                }
                self.navigationController?.pushViewController(conditionsVC, animated: true)
            }
            
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }


    
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "searchView", sender: self)
    }
    @IBAction func unitsSwitch(_ sender: UISwitch) {
        if sender.isOn {
            UserDefaults.standard.set(true, forKey: "notMetric")
        } else {
            UserDefaults.standard.set(false, forKey: "notMetric")
        }
    }
    
    @IBOutlet weak var unitsDefault: UISwitch!
    func setSwitch() {
        if (UserDefaults.standard.bool(forKey: "notMetric") == true) {
            unitsDefault.setOn(true, animated: true)
        } else if (UserDefaults.standard.bool(forKey: "notMetric") == false){
            unitsDefault.setOn(false, animated: true)
        }
    }
    @IBOutlet weak var locationsTable: UITableView!
    func configureTableView() {
        locationsTable.delegate = self
        locationsTable.dataSource = self
    }
}



extension LocationsViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            CoreDataManager.shared.context.delete(CoreDataManager.shared.locationsArray[indexPath.row])
            CoreDataManager.shared.locationsArray.remove(at: indexPath.row)
            CoreDataManager.shared.saveContext()
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "deleteIcon")
        return [deleteAction]
    }
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
}


