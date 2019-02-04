//
//  DataController.swift
//  Virtual Tourist
//
//  Created by amnah on 2/3/19.
//  Copyright © 2019 amnah. All rights reserved.
//

import Foundation
import CoreData
import UIKit
class DataController{
    
    static let shared = DataController()
    var pins :[PinObj] = []
    private let persistentContainer:NSPersistentContainer
    
    // let backgroundContext:NSManagedObjectContext!
    public  var viewContext:NSManagedObjectContext{
        return persistentContainer.viewContext
    }
    
    private init()
    {
        persistentContainer = NSPersistentContainer(name:"Model")
        //         backgroundContext = persistentContainer.newBackgroundContext()
    }
    func load(completion:(() -> Void)? = nil)
    {
        persistentContainer.loadPersistentStores {
            storeDescription, error in
            guard error == nil else{
                fatalError(error!.localizedDescription)
                
            }
            completion?()
        }
    }
    
    public func savePin(lat: Double, lon: Double) -> PinObj
    {
        let addPin = PinObj(context: viewContext)
        addPin.latitude = lat
        addPin.longitude = lon
        try? viewContext.save()
        return addPin
        
    }
    public func loadPins() ->[PinObj]
    {
        let fetchRequest : NSFetchRequest<PinObj> = PinObj.fetchRequest()
        if let result = try? DataController.shared.viewContext.fetch(fetchRequest)
        {
            
            pins = result
            return pins
        }
        return pins
    }
   
    
    
    
}
