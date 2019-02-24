//
//  photo.swift
//  Virtual Tourist
//
//  Created by amnah on 2/7/19.
//  Copyright © 2019 amnah. All rights reserved.
//

import Foundation
import UIKit

class collectionViewCell:UICollectionViewCell{
   
    //let datacontroller = DataController.shared
   

    @IBOutlet weak var FlickrImage: UIImageView!
    
    @IBOutlet weak var selectedView: UIView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
}
