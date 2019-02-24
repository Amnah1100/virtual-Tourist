//
//  LocationsMap.swift
//  Virtual Tourist
//
//  Created by amnah on 2/3/19.
//  Copyright © 2019 amnah. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreData

class LocationsMap: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
 var fetchedResultsController:NSFetchedResultsController<PinObj>!
  
    var  datacontrol = DataController.shared
    var selectedPin : PinObj!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       // setUp()
        getPins()
       mapView.delegate = self
        
        setUpFetchedResultsController()
        
    }
    
    fileprivate func setUpFetchedResultsController() {
        let fetchRequest:NSFetchRequest<PinObj> = PinObj.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "createdDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: datacontrol.viewContext, sectionNameKeyPath: nil, cacheName: "PinData")
        fetchedResultsController.delegate = self
        do{
            try fetchedResultsController.performFetch()
        }catch{
            fatalError("The fetch could not be performed : \(error.localizedDescription)")
        }
    }
    
    
    
    @IBAction func longGestureAnnotation(_ sender: UILongPressGestureRecognizer) {
        mapView.addGestureRecognizer( sender)
        
        var tappedPoint = sender.location(in: mapView)
        var newCoordinates = mapView.convert(tappedPoint, toCoordinateFrom: mapView)
     //     let annotation  =  appDelegate.annotation
        let annotation = MyPinAnnotation()
    
           annotation.coordinate = newCoordinates
        datacontrol.savePin(lat: newCoordinates.latitude , lon: newCoordinates.longitude )
//        annotation.pinData = DataController.shared.savePin(lat: newCoordinates.latitude , lon: newCoordinates.longitude )
//
 
        mapView.addAnnotation(annotation)
     

    }
   
   
   


    func getPins()
    {

        let savedPins =
            datacontrol.loadPins()
            //DataController.shared.loadPins()
        print("savedpins",savedPins.count)
        for pin in savedPins{
            let annotaion = MyPinAnnotation()
            annotaion.coordinate = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
            annotaion.pinData = pin
          //  print("this is the pin", pin)
            mapView.addAnnotation(annotaion)
        }
    }
    
    
   
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "toCollectionView" ) {
         
            
         if  let vc = segue.destination as? collectionView {
            vc.datacontroller = self.datacontrol
            vc.pin = selectedPin
          
           }
         
        }
        
    }
    
    
}

extension LocationsMap : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.pinTintColor = .red
        }
        else {
            pinView!.annotation = annotation
        }
        
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        
        let annotation = view.annotation
        let annotationLat = annotation?.coordinate.latitude
        let annotationLong = annotation?.coordinate.longitude
        if let result = fetchedResultsController.fetchedObjects {
            for pin in result {
                if pin.latitude == annotationLat && pin.longitude == annotationLong {
                    selectedPin = pin
                    performSegue(withIdentifier: "toCollectionView", sender: self)
                    
                    break
                }
            }
            
            
            
            
        }
        
        
        
    }
    
}


extension LocationsMap : NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        
        guard let pin = anObject as? PinObj else {
            preconditionFailure("All changes observed in the map view controller should be for Point instances")
        }
        
        
        switch type {
        case .insert:
            DispatchQueue.main.async {
                self.mapView.addAnnotation(pin)
            }
            
        case .delete:
            mapView.removeAnnotation(pin)
            
        case .update:
            mapView.removeAnnotation(pin)
            mapView.addAnnotation(pin)
            
        case .move: break
            
        }
    }
}


extension PinObj: MKAnnotation {
    public var coordinate: CLLocationCoordinate2D {
        
        let latDegrees = CLLocationDegrees(latitude)
        let longDegrees = CLLocationDegrees(longitude)
        return CLLocationCoordinate2D(latitude: latDegrees, longitude: longDegrees)
        
    }
}

