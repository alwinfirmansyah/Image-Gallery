//
//  GroupOfImageGalleriesModel.swift
//  Image Gallery
//
//  Created by Alwin Firmansyah on 5/30/18.
//  Copyright © 2018 Alwin Firmansyah. All rights reserved.
//

import Foundation

struct GroupOfImageGalleriesModel {
    
    var topics: [String] = ["Food", "Sports", "People"]
    lazy var arrayOfImageGalleries: [ImageGalleryModel] = [ImageGalleryModel(topic: topics[0]), ImageGalleryModel(topic: topics[1]), ImageGalleryModel(topic: topics[2])]
    
}
