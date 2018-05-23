//
//  ImageCollectionViewCell.swift
//  Image Gallery
//
//  Created by Alwin Firmansyah on 5/22/18.
//  Copyright © 2018 Alwin Firmansyah. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var collectionViewCellLoadingSpinner: UIActivityIndicatorView!
    
    var imageURL: URL? {
        didSet {
            image = nil
            fetchImage()
        }
    }
        
    private var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            collectionViewCellLoadingSpinner?.stopAnimating()
        }
    }
    
    private func fetchImage() {
        if let url = imageURL {
            collectionViewCellLoadingSpinner.startAnimating()
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                let urlContents = try? Data(contentsOf: url)
                DispatchQueue.main.async {
                    if let imageData = urlContents, url == self?.imageURL {
                        self?.image = UIImage(data: imageData)
                    }
                }
            }
        }
    }
    
}
