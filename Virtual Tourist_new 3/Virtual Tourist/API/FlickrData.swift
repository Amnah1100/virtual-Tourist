//
//  FlickrData.swift
//  Virtual Tourist
//
//  Created by amnah on 2/3/19.
//  Copyright © 2019 amnah. All rights reserved.
//

import Foundation


import Foundation
import MapKit

class FlickrData:NSObject {
    static var  photosUrlArray = [URL]()
     static func getImages(lat:Double, long:Double, completion: @escaping (_ error: Error?, _ flickrImages: [URL]?) -> Void)
    {
        let latitude = lat
        let longtitude = long
        let url = URL(string:"\(FlickrAPI.url)?\(FlickrAPI.FlikcerParameters.method)=\(FlickrAPI.FlickerImageVal.method)&\(FlickrAPI.FlikcerParameters.format)=\(FlickrAPI.FlickerImageVal.format)&\(FlickrAPI.FlikcerParameters.api_key)=\(FlickrAPI.FlickerImageVal.api_key)&\(FlickrAPI.FlikcerParameters.latitude)=\(latitude)&\(FlickrAPI.FlikcerParameters.longitude)=\(longtitude)&\("radius")=\(3)")!
        var request = URLRequest(url: url)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                if Reachability.isConnectedToNetwork() == false
                {
                   
                    debugPrint("network connection failed ")
                }
                
                completion(error!, nil)
                
                
                return
            }
            // we don't need to create a sub data
            let range = Range(uncheckedBounds: (14, data!.count - 1))
            let newData = data?.subdata(in: range)
            if let json = try? JSONSerialization.jsonObject(with: newData!) as? [String: Any],
                let photosMeta = json?["photos"] as? [String: Any],
                let photos = photosMeta["photo"] as? [Any]
            {
                var flickrImages:[FlickrImage] = []
             
                var currImage : [UIImage] = []
                var urls: [URL] = []
             
                for photo in photos {
                    if let flickrImage = photo as? [String:Any],
                        let id = flickrImage["id"] as? String,
                        let secret = flickrImage["secret"] as? String,
                        let server = flickrImage["server"] as? String,
                        let farm = flickrImage["farm"] as? Int
                    {
                        
                      let url = FlickrData.getImageurl(idVal:id, secretVal: secret, serverVal: server, farmVal: farm )
                        
                      urls.append(url)
                   }
                }
                completion(nil, urls)
            }
           
        }
        task.resume()
        
    }
    

    static func getFlickrImages(lat:Double,long:Double, completion: @escaping (_ error: Error?, _ flickrImages: [URL]?) -> Void){
        var res : [URL] = []
 
        FlickrData.getImages(lat: lat, long: long){ (error : Error?,  _ flickrImages : [URL]?) in
            guard error == nil else{
                completion(error!, nil)
                return
            }
            
            if flickrImages!.count > 25 {
                var randomArray: [Int] = []
                while randomArray.count < 25
                {
                    let random = arc4random_uniform(UInt32(flickrImages!.count))
                    if !randomArray.contains(Int(random))
                    {randomArray.append(Int(random))}
                }
                for random in randomArray{
                    res.append(flickrImages! [random])
                }
                completion(nil, res)
                
            }else{
                completion(nil, res)
            }
        }
        
    }
    

   static func getImageurl (idVal:String, secretVal: String, serverVal: String, farmVal: Int )->URL
    {
        let url = NSURL(
            string:"https://farm\(farmVal).staticflickr.com/\(serverVal)/\(idVal)_\(secretVal).jpg")

        return url as! URL
    
    }
  static  func downloadAndSaveImages(url:URL, pin: PinObj)
    {
        let data = URLSession.shared.dataTask(with: url)
        {
            data, response, error in
            if error == nil {
                if let data = data {
                    
                    // call save func to save images in  core data
                DataController.shared.savePhoto(data: data, pin: pin)
                }
            }else {
                print(error!)
            }
        }
        data.resume()
        
    }
}
