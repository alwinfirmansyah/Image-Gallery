//
//  ImageGalleryModel.swift
//  Image Gallery
//
//  Created by Alwin Firmansyah on 5/30/18.
//  Copyright © 2018 Alwin Firmansyah. All rights reserved.
//

import Foundation

struct ImageGalleryModel: Hashable, Codable {
    
    var hashValue: Int
    var topic: String
    var imageGalleryURLs: [URL]
    var imageAspectRatios: [Double]
    
    init(topic: String, identifier: Int) {
        self.topic = topic
        self.hashValue = identifier
        self.imageGalleryURLs = [URL]()
        self.imageAspectRatios = [Double]()
    }

}
