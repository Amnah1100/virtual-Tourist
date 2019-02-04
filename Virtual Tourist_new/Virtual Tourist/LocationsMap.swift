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

class LocationsMap: UIViewController, MKMapViewDelegate {
    
    
    //@IBOutlet weak var mapViewItem: MKMapView!
  
   // @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       // setUp()
        getPins()
       mapView.delegate = self
        
        
    }
    
    //    func setUp()
//    {
//        let longPressedGuest = UILongPressGestureRecognizer(target: self, action: #selector(self.mapLongPressed(_:)))
//        mapViewItem.addGestureRecognizer(longPressedGuest)
//    }
//
//
//    @objc func mapLongPressed(_ sender:UILongPressGestureRecognizer)
//    {
//        guard sender.state == UIGestureRecognizer.State.began
//            else{return}
//        let touchPoint = sender.location(in: self.mapViewItem)
//        let newCoordinates = self.mapViewItem.convert(touchPoint, toCoordinateFrom: self.mapViewItem)
//        let annotation = MyPinAnnotation()
//        annotation.coordinate = newCoordinates
//
//
//        annotation.pinData = DataController.shared.savePin(lat: newCoordinates.latitude , lon: newCoordinates.longitude )
//
//        mapViewItem.addAnnotation(annotation)//    }
    
    @IBAction func longGestureAnnotation(_ sender: UILongPressGestureRecognizer) {
        mapView.addGestureRecognizer( sender)
        
        var tappedPoint = sender.location(in: mapView)
        var newCoordinates = mapView.convert(tappedPoint, toCoordinateFrom: mapView)
        let annotation  =  MyPinAnnotation()
        annotation.coordinate = newCoordinates
        
        annotation.pinData = DataController.shared.savePin(lat: newCoordinates.latitude , lon: newCoordinates.longitude )
        mapView.addAnnotation(annotation)

    }
   
    
//    @IBAction func getAnnotation( gestureRecognizer: UILongPressGestureRecognizer) {
//
//
//        mapView.addGestureRecognizer( gestureRecognizer)
//
//        var tappedPoint = gestureRecognizer.location(in: mapView)
//        var newCoordinates = mapView.convert(tappedPoint, toCoordinateFrom: mapView)
//        let annotation  =  MyPinAnnotation()
//        annotation.coordinate = newCoordinates
//
//        annotation.pinData = DataController.shared.savePin(lat: newCoordinates.latitude , lon: newCoordinates.longitude )
//        mapView.addAnnotation(annotation)
//    }
    
   


    func getPins()
    {
//
//        let savedPins =
//            DataController.shared.loadPins()
//        for pin in savedPins{
//            let annotaion = MyPinAnnotation()
//            annotaion.coordinate = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
//            annotaion.pinData = pin
//            mapView.addAnnotation(annotaion)
 //       }
    }
    
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            print("this is the annotation value", annotation)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
//
//        FlickrData.getFlickrImages(location: (view.annotation?.coordinate)!) { (error : Error?,  _ flickrImages : [FlickrImage]?) in
//            guard error == nil else{
//
//                return
//            }
//        }
//
//        let cont = UIStoryboard(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "AlbumImg") as! UINavigationController
//        
//        present(cont, animated: true, completion: nil)
//
//        print("this is the Album Photo ")
//
        
        let cont = UIStoryboard(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "AlbumImg") as! UINavigationController
        
        present(cont, animated: true, completion: nil)
        
        
        
        
        
        
        
    }
    
}

