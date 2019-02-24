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
import  MapKit

class collectionView :UIViewController, UICollectionViewDataSource{

    
   var datacontroller = DataController.shared
    
      let annotation = MyPinAnnotation()
    
    var pin: PinObj!
   // var photo
    var photos = [PhotoObj]()
    var selectedIndex = [NSIndexPath]()
    var selectedPhotos = [IndexPath]()
    private var blockOperations : [BlockOperation] = []

    @IBOutlet weak var backBtn: UIBarButtonItem!
    

   // @IBOutlet weak var noDataFoundLabel: UILabel!
    
    @IBOutlet weak var newCollectionBtn: UIButton!
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    
  
    @IBOutlet weak var locationMap: MKMapView!

    
    @IBOutlet weak var noImagesLabel: UILabel!
    

    
   var page: Int = 0
    var fetchedResultsController: NSFetchedResultsController<PhotoObj>!
    
    var isEmpty: Bool {
        
       return  fetchedResultsController?.fetchedObjects?.count != 0
    
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        newCollectionBtn.isEnabled = true
        newCollectionBtn.setTitle("New Collection", for: .normal)
       

        fetchResult()
        if self.fetchedResultsController.fetchedObjects?.count == 0{
            callFlickrAPI()
        }
        AddAnnotation()
      
        self.myCollectionView.allowsMultipleSelection = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchResult()
        

    }
   
    
    
    @IBAction func backBtnTapped(sender: AnyObject) {
        
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func setLayout (cell: collectionViewCell, status:Bool)
    {
        if status == false{
            cell.activityIndicator.isHidden = false
            cell.activityIndicator.startAnimating()
            
        }else{
            cell.activityIndicator.stopAnimating()
            cell.activityIndicator.isHidden = true
        }
    }

    
    //this func chescks if the core data is empty it gets images from flikcr API
    //if not empty --> if returns images from the core data
 fileprivate   func fetchResult()
    {
        let fetchRequest:NSFetchRequest<PhotoObj> = PhotoObj.fetchRequest()
        let predicate = NSPredicate(format: "pinObj == %@", self.pin)
        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "createdDate" , ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: datacontroller.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = self as! NSFetchedResultsControllerDelegate
        do{
            try fetchedResultsController.performFetch()
            
        }
        catch{
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
        
    }
    func AddAnnotation(){
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(pin.latitude, pin.longitude)
        self.locationMap.addAnnotation(annotation)
        
        // to zoom in the location
        let coredinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(pin.latitude, pin.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.07, longitudeDelta: 0.07)
        let region = MKCoordinateRegion(center: coredinate, span: span)
        self.locationMap.setRegion(region, animated: true)
       
    }

    // this func calls get flickrImages()
    func callFlickrAPI()
    {
       FlickrData.getFlickrImages(lat: self.annotation.coordinate.latitude, long: self.annotation.coordinate.longitude)
        { (error : Error?,  _ flickrImages : [URL]?) in
          
            guard error == nil else
            {
                print ("no data was found")

                return
            }
                for url in flickrImages!{
                    FlickrData.downloadAndSaveImages(url: url, pin: self.pin)  }
            
        }
       
      
    }
    
    
    @IBAction func NewCollectionTapped(sender: AnyObject) {

        guard let fetchedResults = self.fetchedResultsController.fetchedObjects else{
            return
        }
        
        selectedPhotos.removeAll()
        
        for x in fetchedResults{
            
            datacontroller.viewContext.delete(x)
            try? datacontroller.viewContext.save()
        }
        callFlickrAPI()
        self.myCollectionView.reloadData()
        
        
    }
    func deletePhotos(){
        var photosToDelete: [PhotoObj] = [PhotoObj]()
        for i in selectedPhotos{
            photosToDelete.append(fetchedResultsController.object(at: i))
        }
        for i in photosToDelete{
            datacontroller.viewContext.delete(i)
            try? datacontroller.viewContext.save()
        }
        selectedPhotos.removeAll()
    }
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
   
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! collectionViewCell
  
            self.setUI(cell: cell, status: false)
             cell.selectedView.isHidden = true
    
         let item = self.fetchedResultsController.object(at: indexPath)
      
        
        if let dataVal = item.image, let imageVal = UIImage(data: dataVal)
         {
              self.setUI(cell: cell, status: true)
        cell.FlickrImage.image = imageVal

        }
        
        return cell
    }
    func setUI(cell: collectionViewCell, status: Bool){
        if status == false
        {
            cell.activityIndicator.isHidden = false
             cell.activityIndicator.startAnimating()
        }else{
            cell.activityIndicator.stopAnimating()
            cell.activityIndicator.isHidden = true
        }
    }

}

// set UICollectionViewDelegate
extension collectionView: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        datacontroller.viewContext.delete(fetchedResultsController.object(at: indexPath))
        let cell = collectionView.cellForItem(at: indexPath) as! collectionViewCell
        
        
        try? datacontroller.viewContext.save()
          cell.selectedView.isHidden = true
        self.myCollectionView.reloadData()
    }
    func collectionview(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        let cell = collectionView.cellForItem(at: indexPath) as! collectionViewCell
   
     
       
      newCollectionBtn.setTitle("Remove Selected Pictures", for: .normal)
        selectedPhotos.append(indexPath)
         }

    
}

// Set the FetchedResultsController
extension collectionView:NSFetchedResultsControllerDelegate{
    func controllerWillChangeContent(_ controller:
        NSFetchedResultsController<NSFetchRequestResult>) {
       blockOperations.removeAll(keepingCapacity: false)
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType,newIndexPath: IndexPath?)
    {
        let operation: BlockOperation
        switch type{
        case .insert:
            guard let newIndexPath  = newIndexPath else {return}
        operation = BlockOperation{ self.myCollectionView.insertItems(at: [newIndexPath])}
            
        case .delete:
            guard let newIndexpath = indexPath else {return}
            operation = BlockOperation {self.myCollectionView.deleteItems(at: [newIndexpath])}
        case .move:
            guard let indexPath = indexPath, let newIndexPath = newIndexPath else {return}
            operation = BlockOperation{self.myCollectionView.moveItem(at: indexPath, to: newIndexPath)}
        case .update:
                guard let indexPath = indexPath else {return}
                operation = BlockOperation{self.myCollectionView.reloadItems(at:[indexPath])}
        }
        blockOperations.append(operation)
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.myCollectionView.reloadData()
    }
    

}
