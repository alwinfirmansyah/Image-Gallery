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

    // computed property for our Model
    // if someone sets this, we'll update our UI
    // if someone asks for this, we'll cons up a Model from the UI
    
    var imageGallery: ImageGalleryModel? {
        didSet {
            if let urls = imageGallery?.imageGalleryURLs, let aspectRatios = imageGallery?.imageAspectRatios.map ({ CGFloat($0) }) {
                imageURLs = urls
                imageAspectRatios = aspectRatios
            }
        }
    }
    
//    var imageGallery: ImageGalleryModel? {
//        get {
//            let urls = imageURLs
//            let aspectRatios = imageAspectRatios.map({ Double($0) })
//            return ImageGalleryModel(topic: topic, urls: urls, aspectRatios: aspectRatios)
//        }
//        set {
//            if let urls = imageGallery?.imageGalleryURLs, let aspectRatios = imageGallery?.imageAspectRatios.map ({ CGFloat($0) }) {
//                imageURLs = urls
//                imageAspectRatios = aspectRatios
//            }
//        }
//    }
    
    // -------------------------------------------------------------------------------
    // MARK: - Collection View Data Source
    // -------------------------------------------------------------------------------

    var topic = ""
    private var imageURLs = [URL?]()
    private var imageAspectRatios = [CGFloat]()
    
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

