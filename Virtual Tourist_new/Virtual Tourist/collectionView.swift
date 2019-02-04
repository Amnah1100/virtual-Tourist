//
//  collectionView.swift
//  Virtual Tourist
//
//  Created by amnah on 2/3/19.
//  Copyright © 2019 amnah. All rights reserved.
//

import Foundation
import UIKit
import CoreData
class collectionView :UIViewController{
    
    @IBOutlet weak var collectionView: UICollectionView!
    var pin: PinObj!
    var page: Int = 0
    var fetchedResultsController: NSFetchedResultsController<PhotoObj>!
    
    var isEmpty: Bool {
        return  fetchedResultsController.fetchedObjects?.count ?? 0 == 0 ? true : false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        fetch()
    }
   
    //this func chescks if the core data is empty it gets images from flikcr API
    //if not empty --> if returns images from the core data
    public func fetch()
    {
        if isEmpty == true
        {
            //access flickr API to get photos
         callFlickrAPI()
            print("there is no stored in this location")
        }else{
            
            let fetchRequest : NSFetchRequest<PhotoObj> = PhotoObj.fetchRequest()
            
            let predicate = NSPredicate(format: "PinObj == %@",  PinObj.self as! CVarArg)
            fetchRequest.predicate = predicate
            fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DataController.shared.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            
            fetchedResultsController.delegate = self as! NSFetchedResultsControllerDelegate
            do{
                try fetchedResultsController.performFetch()
            }catch{
                fatalError("The fetch could not be performed: \(error.localizedDescription)")
                
            }
        }
        
        
    }
    // this func calls get flickrImages()
    func callFlickrAPI()
    {
        
        FlickrData.getFlickrImages(lat: self.pin.latitude, long: self.pin.longitude) { (error : Error?,  _ flickrImages : [FlickrImage]?) in
                        guard error == nil else{
            
                            return
                        }
                    }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//      //  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
//      // flickrImageView = fetchedResultsController.object(at: indexPath)
//        
//       // let flickrImg:
//        return
//    }
    
    
}

