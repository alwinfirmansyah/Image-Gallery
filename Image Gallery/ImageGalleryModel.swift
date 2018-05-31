//
//  ImageGalleryModel.swift
//  Image Gallery
//
//  Created by Alwin Firmansyah on 5/30/18.
//  Copyright © 2018 Alwin Firmansyah. All rights reserved.
//

import Foundation

struct ImageGalleryModel: Hashable {
    
    var hashValue: Int
    
//    var topic: String
//    var imageGalleryURLs = [URL?]()
//    var imageAspectRatios = [Float]()
    
//    var topic: String
//    var imageGalleryURLs = [URL(string: "https://images.pexels.com/photos/274131/pexels-photo-274131.jpeg?auto=compress&cs=tinysrgb&h=350"),URL(string: "https://newevolutiondesigns.com/images/freebies/cool-wallpaper-2.jpg"), URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcReIoYqxU5APOY1fPGRuzLX7x47TsnyakYQXp6dLnNytz3k-2te"), URL(string: "https://www.jpl.nasa.gov/images/cassini/20090202/pia03883-full.jpg"), URL(string: "https://images.pexels.com/photos/709881/pexels-photo-709881.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260"), URL(string: "https://images.pexels.com/photos/943907/pexels-photo-943907.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260"), URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS_AqlonO-xlbRezcqaOzjqFVlOZ3ih6v_yFmSb8GyOTJUVY5rd"), URL(string: "https://www.nasa.gov/sites/default/files/wave_earth_mosaic_3.jpg"), URL(string: "https://hdwallsource.com/img/2014/9/high-resolution-backgrounds-4696-4789-hd-wallpapers.jpg"), URL(string: "https://images.pexels.com/photos/274131/pexels-photo-274131.jpeg?auto=compress&cs=tinysrgb&h=350"),URL(string: "https://newevolutiondesigns.com/images/freebies/cool-wallpaper-2.jpg"), URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcReIoYqxU5APOY1fPGRuzLX7x47TsnyakYQXp6dLnNytz3k-2te"), URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRKzBggXsaBjPSlrLnBjDGg6Go6PxUkMph5P2wsjuruPhBA3qBd"), URL(string: "https://www.nasa.gov/sites/default/files/saturn_collage.jpg"), URL(string: "https://images.pexels.com/photos/943907/pexels-photo-943907.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260"), URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS_AqlonO-xlbRezcqaOzjqFVlOZ3ih6v_yFmSb8GyOTJUVY5rd"), URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRN5KbyS6CV_W_vLK8Ana9M6ev3CZUiGTMjEYnFO6eRxVTKGjqBFA"), URL(string: "https://hdwallsource.com/img/2014/9/high-resolution-backgrounds-4696-4789-hd-wallpapers.jpg")]
//    var imageAspectRatios: [Double] = [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0,]
    
    
    var topic: String
    var imageGalleryURLs = [URL(string: "https://images.pexels.com/photos/274131/pexels-photo-274131.jpeg?auto=compress&cs=tinysrgb&h=350"),URL(string: "https://newevolutiondesigns.com/images/freebies/cool-wallpaper-2.jpg"), URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcReIoYqxU5APOY1fPGRuzLX7x47TsnyakYQXp6dLnNytz3k-2te")]
    var imageAspectRatios: [Double] = [1.0, 1.0, 1.0]
    
    init(topic: String, identifier: Int) {
        self.topic = topic
        self.hashValue = identifier
    }
}
