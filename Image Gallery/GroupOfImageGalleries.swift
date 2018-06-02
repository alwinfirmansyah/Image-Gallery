//
//  GroupOfImageGalleriesModel.swift
//  Image Gallery
//
//  Created by Alwin Firmansyah on 5/30/18.
//  Copyright © 2018 Alwin Firmansyah. All rights reserved.
//

import Foundation

struct GroupOfImageGalleries: Codable {
    
    // -------------------------------------------------------------------------------
    // MARK: - Global Variables
    // -------------------------------------------------------------------------------
    
    static var topics: [String] = ["Food", "Sports", "People"]
    static var arrayOfImageGalleries: [ImageGalleryModel] = [ImageGalleryModel(topic: "Food", identifier: 1), ImageGalleryModel(topic: "Sports", identifier: 2), ImageGalleryModel(topic: "People", identifier: 3)]
    
    static var recentlyDeletedTopics = [String]()
    static var arrayOfRecentlyDeletedImageGalleries = [ImageGalleryModel]()
    
    // -------------------------------------------------------------------------------
    // MARK: - Instance Variables
    // -------------------------------------------------------------------------------
    
    var listOfTopics: [String]
    var listOfImageGalleries: [ImageGalleryModel]
    var listOfRecentlyDeletedTopics: [String]
    var listOfRecentlyDeletedImageGalleries: [ImageGalleryModel]
    
    // -------------------------------------------------------------------------------
    // MARK: - Initializing Image Galleries
    // -------------------------------------------------------------------------------
    
    init() {
        self.listOfTopics = GroupOfImageGalleries.topics
        self.listOfImageGalleries = GroupOfImageGalleries.arrayOfImageGalleries
        self.listOfRecentlyDeletedTopics = GroupOfImageGalleries.recentlyDeletedTopics
        self.listOfRecentlyDeletedImageGalleries = GroupOfImageGalleries.arrayOfRecentlyDeletedImageGalleries
    }
    
    // -------------------------------------------------------------------------------
    // MARK: - Json Related
    // -------------------------------------------------------------------------------
    
    init?(json: Data) {
        if let newValue = try? JSONDecoder().decode(GroupOfImageGalleries.self, from: json) {
            self = newValue
        } else {
            return nil
        }
    }
    
    var json: Data? {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        return try? jsonEncoder.encode(self)
    }

//    var json: Data? {
//        return try? JSONEncoder().encode(self)
//    }
    
}
