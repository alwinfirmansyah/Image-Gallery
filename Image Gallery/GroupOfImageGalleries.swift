//
//  GroupOfImageGalleriesModel.swift
//  Image Gallery
//
//  Created by Alwin Firmansyah on 5/30/18.
//  Copyright © 2018 Alwin Firmansyah. All rights reserved.
//

import Foundation

struct GroupOfImageGalleries: Codable {
    
    static var topics: [String] = ["Food", "Sports", "People"]
    static var arrayOfImageGalleries: [ImageGalleryModel] = [ImageGalleryModel(topic: "Food", identifier: 1), ImageGalleryModel(topic: "Sports", identifier: 2), ImageGalleryModel(topic: "People", identifier: 3)]
    
    var listOfTopics: [String]
    var listOfImageGalleries: [ImageGalleryModel]
    
    init() {
        self.listOfTopics = GroupOfImageGalleries.topics
        self.listOfImageGalleries = GroupOfImageGalleries.arrayOfImageGalleries
    }
    
    var json: Data? {
        return try? JSONEncoder().encode(self)
    }
    
}
