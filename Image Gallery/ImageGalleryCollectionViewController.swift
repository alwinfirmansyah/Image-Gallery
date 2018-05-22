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
    
//    var imageURLs = [URL]()
//    var imageAspectRatios = [Double]()
//
//    var singleImageURL: URL? {
//        didSet {
//            image = nil
//            if view.window != nil {
//                fetchImage()
//            }
//        }
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        if imageView.image == nil {
//            fetchImage()
//        }
//    }
//
//    var imageView = UIImageView()
//
//    private var image: UIImage? {
//        get {
//            return imageView.image
//        }
//        set {
//            imageView.image = newValue
//            imageView.sizeToFit()
////            spinner?.stopAnimating()
//        }
//    }
//
//    // need to eventually include parameters for fetch image so that we know which url to fetch an image for in the url array
//    private func fetchImage() {
//        if let url = singleImageURL {
////            spinner.startAnimating()
//            DispatchQueue.global(qos: .userInitiated).async {
//                let urlContents = try? Data(contentsOf: url)
//                DispatchQueue.main.async { [weak self] in
//                    if let imageData = urlContents, url == self?.singleImageURL {
//                        self?.image = UIImage(data: imageData)
//                    }
//                }
//            }
//        }
//    }
    
    
    var imageViews = [UIImage(named: "bistro")]
    
    // MARK: - UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageViews.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        if let imageCell = cell as? ImageCollectionViewCell {
            let image = imageViews[indexPath.item]
            imageCell.imageView?.image = image
        }
        return cell
    }

}
