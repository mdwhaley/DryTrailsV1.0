//
//  CoreDataManager.swift
//  DryTrails
//
//  Created by Michael Whaley on 6/6/23.
//

import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
//    var locationsArray = [Locations]()
    var locationsArray = [Locations]()
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DryTrails")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                fatalError("Fatal error loading store: \(error.localizedDescription)")
            }
        }
        return container
    }()
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("error")
            }
        }
        fetchLocations()
    }
    
    /**
     Add the passed location to CoreData
     */
    func addLocation(name: String, latitude: Float, longitude: Float) {
        let locations = Locations(context: self.context)
        locations.name = name
        locations.latitude = latitude
        locations.longitude = longitude
        saveContext()
    }
    
    /**
     Retrieve locations from CoreData
     */
    @discardableResult
    func fetchLocations() -> [Locations] {
        let fetchRequest : NSFetchRequest<Locations> = {
            let request = NSFetchRequest<Locations>(entityName: "Locations")
             request.predicate = NSPredicate(value: true)
            return request
        }()
        
        do {
            locationsArray = try context.fetch(fetchRequest)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        return locationsArray
    }
    
}
