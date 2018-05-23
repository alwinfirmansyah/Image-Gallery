//
//  ImageGalleryCollectionViewController.swift
//  Image Gallery
//
//  Created by Alwin Firmansyah on 5/22/18.
//  Copyright © 2018 Alwin Firmansyah. All rights reserved.
//

import UIKit

private let reuseIdentifier = "imageCell"

class ImageGalleryCollectionViewController: UICollectionViewController {
    
    // MARK: model below
    
    var imageURLs = [URL(string: "https://upload.wikimedia.org/wikipedia/commons/5/55/Stanford_Oval_September_2013_panorama.jpg"),URL(string: "https://www.jpl.nasa.gov/images/cassini/20090202/pia03883-full.jpg"), URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcReIoYqxU5APOY1fPGRuzLX7x47TsnyakYQXp6dLnNytz3k-2te"), URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRKzBggXsaBjPSlrLnBjDGg6Go6PxUkMph5P2wsjuruPhBA3qBd")]
    var imageAspectRatios = [Double]()
    
    // MARK: - UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageURLs.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        if let imageCell = cell as? ImageCollectionViewCell {
            if let url = imageURLs[indexPath.item]?.imageURL {
                DispatchQueue.global(qos: .userInitiated).async {
                    let urlContents = try? Data(contentsOf: url)
                    DispatchQueue.main.async { [weak self] in
                        if let imageData = urlContents, url == self?.imageURLs[indexPath.item] {
                            imageCell.imageView?.image = UIImage(data: imageData)
                        }
                    }
                }
            }
        }
        return cell
    }

}
