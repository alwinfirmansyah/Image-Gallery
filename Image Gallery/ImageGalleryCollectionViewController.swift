//
//  ImageGalleryCollectionViewController.swift
//  Image Gallery
//
//  Created by Alwin Firmansyah on 5/22/18.
//  Copyright © 2018 Alwin Firmansyah. All rights reserved.
//

import UIKit

private let reuseIdentifier = "imageCell"

class ImageGalleryCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // MARK: model below
    var topic = ""
    var imageURLs = [URL(string: "https://upload.wikimedia.org/wikipedia/commons/5/55/Stanford_Oval_September_2013_panorama.jpg"),URL(string: "https://www.jpl.nasa.gov/images/cassini/20090202/pia03883-full.jpg"), URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcReIoYqxU5APOY1fPGRuzLX7x47TsnyakYQXp6dLnNytz3k-2te"), URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRKzBggXsaBjPSlrLnBjDGg6Go6PxUkMph5P2wsjuruPhBA3qBd")]
    var imageAspectRatios = [Double]()
    
    
    // MARK: lifecycle methods
    override func viewDidLoad() {
        
    }
    
    // MARK: - UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageURLs.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        if let imageCell = cell as? ImageCollectionViewCell {
            let url = imageURLs[indexPath.item]?.imageURL
            // need to adjust aspect ratio from the operations of the drag and drop
            imageCell.imageURL = url
        }
        return cell
    }
    
    // MARK: - UICollectionViewDragDelegate
    
//    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
//        session.localContext = collectionView
//        return dragItems(at: indexPath)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
//        return dragItems(at: indexPath)
//    }
//
//    private func dragItems(at indexPath: IndexPath) -> [UIDragItem] {
//        if let image = (self.collectionView?.cellForItem(at: indexPath) as? ImageCollectionViewCell)?.imageView.image {
//            let dragItem = UIDragItem(itemProvider: NSItemProvider(object: image))
//            dragItem.localObject = image
//            return [dragItem]
//        } else {
//            return []
//        }
//    }
    
    // MARK: - UICollectionViewDropDelegate
    
//    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
//        <#code#>
//    }
    

}
