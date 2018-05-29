//
//  ImageGalleryViewController.swift
//  Image Gallery
//
//  Created by Alwin Firmansyah on 5/23/18.
//  Copyright © 2018 Alwin Firmansyah. All rights reserved.
//

import UIKit

class ImageGalleryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDragDelegate, UICollectionViewDropDelegate {

    @IBOutlet weak var galleryCollectionView: UICollectionView! {
        didSet {
            galleryCollectionView.dataSource = self
            galleryCollectionView.delegate = self
            galleryCollectionView.dragDelegate = self
            galleryCollectionView.dropDelegate = self
        }
    }
    
    // -------------------------------------------------------------------------------
    // MARK: - Collection View Model
    // -------------------------------------------------------------------------------
    
//    var imageURLs: [URL?] = [URL(string: "https://images.pexels.com/photos/274131/pexels-photo-274131.jpeg?auto=compress&cs=tinysrgb&h=350"),URL(string: "https://newevolutiondesigns.com/images/freebies/cool-wallpaper-2.jpg"), URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcReIoYqxU5APOY1fPGRuzLX7x47TsnyakYQXp6dLnNytz3k-2te"), URL(string: "https://www.jpl.nasa.gov/images/cassini/20090202/pia03883-full.jpg"), URL(string: "https://images.pexels.com/photos/709881/pexels-photo-709881.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260"), URL(string: "https://images.pexels.com/photos/943907/pexels-photo-943907.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260"), URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS_AqlonO-xlbRezcqaOzjqFVlOZ3ih6v_yFmSb8GyOTJUVY5rd"), URL(string: "https://www.nasa.gov/sites/default/files/wave_earth_mosaic_3.jpg"), URL(string: "https://hdwallsource.com/img/2014/9/high-resolution-backgrounds-4696-4789-hd-wallpapers.jpg"), URL(string: "https://images.pexels.com/photos/274131/pexels-photo-274131.jpeg?auto=compress&cs=tinysrgb&h=350"),URL(string: "https://newevolutiondesigns.com/images/freebies/cool-wallpaper-2.jpg"), URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcReIoYqxU5APOY1fPGRuzLX7x47TsnyakYQXp6dLnNytz3k-2te"), URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRKzBggXsaBjPSlrLnBjDGg6Go6PxUkMph5P2wsjuruPhBA3qBd"), URL(string: "https://www.nasa.gov/sites/default/files/saturn_collage.jpg"), URL(string: "https://images.pexels.com/photos/943907/pexels-photo-943907.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260"), URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS_AqlonO-xlbRezcqaOzjqFVlOZ3ih6v_yFmSb8GyOTJUVY5rd"), URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRN5KbyS6CV_W_vLK8Ana9M6ev3CZUiGTMjEYnFO6eRxVTKGjqBFA"), URL(string: "https://hdwallsource.com/img/2014/9/high-resolution-backgrounds-4696-4789-hd-wallpapers.jpg")]
//    var imageAspectRatios: [CGFloat] = [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0,]
    
//    var imageURLs: [URL?] = [URL(string: "https://images.pexels.com/photos/274131/pexels-photo-274131.jpeg?auto=compress&cs=tinysrgb&h=350"),URL(string: "https://newevolutiondesigns.com/images/freebies/cool-wallpaper-2.jpg"), URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcReIoYqxU5APOY1fPGRuzLX7x47TsnyakYQXp6dLnNytz3k-2te"), URL(string: "https://images.pexels.com/photos/943907/pexels-photo-943907.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260"), URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS_AqlonO-xlbRezcqaOzjqFVlOZ3ih6v_yFmSb8GyOTJUVY5rd"), URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRN5KbyS6CV_W_vLK8Ana9M6ev3CZUiGTMjEYnFO6eRxVTKGjqBFA"), URL(string: "https://hdwallsource.com/img/2014/9/high-resolution-backgrounds-4696-4789-hd-wallpapers.jpg")]
//    var imageAspectRatios: [CGFloat] = [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0,]
    
//    var imageURLs: [URL?] = [URL(string: "https://images.pexels.com/photos/274131/pexels-photo-274131.jpeg?auto=compress&cs=tinysrgb&h=350"),URL(string: "https://newevolutiondesigns.com/images/freebies/cool-wallpaper-2.jpg")]
//    var imageAspectRatios: [CGFloat] = [1.0, 1.0]
    
//
    var imageURLs = [URL?]()
    var imageAspectRatios = [CGFloat]()

    
    // -------------------------------------------------------------------------------
    // MARK: - Collection View Data Source
    // -------------------------------------------------------------------------------
    
    private let imageCell = "imageCell"
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imageCell, for: indexPath)
        if let imageCell = cell as? ImageCollectionViewCell, let url = imageURLs[indexPath.item]?.imageURL {
            imageCell.galleryImageURL = url
        }
        return cell
    }
    
    // -------------------------------------------------------------------------------
    // MARK: - Collection View Design and Layout
    // -------------------------------------------------------------------------------
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellWidth / imageAspectRatios[indexPath.item] )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return horizontalCellSpacing
    }
    
    // -------------------------------------------------------------------------------
    // MARK: - Collection View Drag Delegate
    // -------------------------------------------------------------------------------
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        session.localContext = collectionView
        return dragItems(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
        return dragItems(at: indexPath)
    }
    
    
    private func dragItems(at indexPath: IndexPath) -> [UIDragItem] {
        if let url = (galleryCollectionView.cellForItem(at: indexPath) as? ImageCollectionViewCell)?.galleryImageURL {
            let dragItem = UIDragItem(itemProvider: NSItemProvider(object: (url as NSURL)))
            dragItem.localObject = url as NSURL
            return [dragItem]
        } else {
            return []
        }
    }
    
    // -------------------------------------------------------------------------------
    // MARK: - Collection View Drop Delegate
    // -------------------------------------------------------------------------------
    
        func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
            if session.localDragSession != nil {
                return session.canLoadObjects(ofClass: NSURL.self)
            } else {
                return session.canLoadObjects(ofClass: NSURL.self) && session.canLoadObjects(ofClass: UIImage.self)
            }
        }
    
        func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
            let isSelf = (session.localDragSession?.localContext as? UICollectionView) == collectionView
            return UICollectionViewDropProposal(operation: isSelf ? .move : .copy, intent: .insertAtDestinationIndexPath) }
    
        func collectionView(
            _ collectionView: UICollectionView,
            performDropWith coordinator: UICollectionViewDropCoordinator
            ) {
            let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)
            for dropItem in coordinator.items {
                if let sourceIndexPath = dropItem.sourceIndexPath {
                    collectionView.performBatchUpdates({
                        imageAspectRatios.move(from: sourceIndexPath.item, to: destinationIndexPath.item)
                        imageURLs.move(from: sourceIndexPath.item, to: destinationIndexPath.item)
                        collectionView.moveItem(at: sourceIndexPath, to: destinationIndexPath)
                    })
                    coordinator.drop(dropItem.dragItem, toItemAt: destinationIndexPath)
                } else {
                    let placeholderContext = coordinator.drop(
                        dropItem.dragItem,
                        to: UICollectionViewDropPlaceholder(insertionIndexPath: destinationIndexPath, reuseIdentifier: "DropPlaceholderCell")
                    )
                    
                    dropItem.dragItem.itemProvider.loadObject(ofClass: UIImage.self) { (provider, error) in
                        if let imageAspectRatio = (provider as? UIImage)?.aspectRatio {
                            DispatchQueue.main.async { [weak self] in
                                self?.imageAspectRatios.insert(imageAspectRatio, at: destinationIndexPath.item)
                            }
                        }
                    }
                    
                    dropItem.dragItem.itemProvider.loadObject(ofClass: NSURL.self) { (provider, error) in
                        DispatchQueue.main.async { [weak self] in
                            if let url = provider as? NSURL {
                                placeholderContext.commitInsertion(dataSourceUpdates: { insertionIndexPath in
                                    self?.imageURLs.insert((url as URL).imageURL, at: insertionIndexPath.item)
                                })
                            } else {
                                placeholderContext.deletePlaceholder()
                            }
                        }
                    }
                }
            }
        }
    

    // -------------------------------------------------------------------------------
    // MARK: - Navigation
    // -------------------------------------------------------------------------------
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedImageURL = imageURLs[indexPath.item]
        performSegue(withIdentifier: "Expand Image", sender: self)
    }
    
    private var selectedImageURL: URL?

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Expand Image" {
            if let destination = segue.destination as? SingleImageViewController {
                destination.imageURL = selectedImageURL
            }
        }
    }

}

extension ImageGalleryViewController {
    private var cellWidth: CGFloat {
        return CGFloat(galleryCollectionView.bounds.width / 3.15)
    }
    
    private var horizontalCellSpacing: CGFloat {
        return CGFloat(galleryCollectionView.bounds.width / 100)
    }
}

extension Array {
    mutating func move(from oldIndex: Index, to newIndex: Index) {
        if oldIndex == newIndex { return }
        if abs(newIndex - oldIndex) == 1 { return self.swapAt(oldIndex, newIndex) }
        self.insert(self.remove(at: oldIndex), at: newIndex)
    }
}

