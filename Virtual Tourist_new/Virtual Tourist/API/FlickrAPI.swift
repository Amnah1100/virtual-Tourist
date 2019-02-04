//
//  FlickrAPI.swift
//  Virtual Tourist
//
//  Created by amnah on 2/3/19.
//  Copyright © 2019 amnah. All rights reserved.
//

import Foundation

import Foundation
struct FlickrAPI:Codable{
    
    static  let url = "https://api.flickr.com/services/rest"
    
    struct FlikcerParameters {
        static  let api_key = "api_key"
        static  let method = "method"
        static let format = "format"
        static var latitude =  "lat"
        static  let longitude = "lon"
        static  let tags = "tags"
        static let per_page = "per_page"
        static  let accuracy = "accuracy"
    }
    
    struct FlickerImageVal {
        static let api_key = "30e420f5370e702ca0655239574eb0cf"
        static let method = "flickr.photos.search"
        static let format = "json"
        static var latitude = 0.0
        static var longitude = 0.0
        static let tags = ""
        static let per_page = 10
        static let accuracy = "11"
    }
    
    
}

