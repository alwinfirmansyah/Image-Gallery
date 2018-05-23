//
//  ImageGalleryViewController.swift
//  Image Gallery
//
//  Created by Alwin Firmansyah on 5/23/18.
//  Copyright © 2018 Alwin Firmansyah. All rights reserved.
//

import UIKit

class ImageGalleryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDragDelegate, UICollectionViewDropDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var galleryCollectionView: UICollectionView! {
        didSet {
            galleryCollectionView.dataSource = self
            galleryCollectionView.delegate = self
            galleryCollectionView.dragDelegate = self
            galleryCollectionView.dropDelegate = self
        }
    }
    
    // MARK: model below
    var topic = ""
//    var imageURLs = [URL(string: "https://upload.wikimedia.org/wikipedia/commons/5/55/Stanford_Oval_September_2013_panorama.jpg"),URL(string: "https://www.jpl.nasa.gov/images/cassini/20090202/pia03883-full.jpg"), URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcReIoYqxU5APOY1fPGRuzLX7x47TsnyakYQXp6dLnNytz3k-2te"), URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRKzBggXsaBjPSlrLnBjDGg6Go6PxUkMph5P2wsjuruPhBA3qBd")]
    
    var imageURLs = [URL]()
    var imageAspectRatios = [Double]()
    
    
    // MARK: - UICollectionViewDataSource
    private let reuseIdentifier = "imageCell"
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        if let imageCell = cell as? ImageCollectionViewCell {
            let url = imageURLs[indexPath.item]
            imageCell.galleryImageURL = url
        }
        return cell
    }
    
    
    
    // MARK: - UICollectionViewDragDelegate
    
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
    
     // MARK: - UICollectionViewDropDelegate
    
        func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
            return session.canLoadObjects(ofClass: NSURL.self)
        }
    
        func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
            let isSelf = (session.localDragSession?.localContext as? UICollectionView) == collectionView
            return UICollectionViewDropProposal(operation: isSelf ? .move : .copy, intent: .insertAtDestinationIndexPath)    }
    
        func collectionView(
            _ collectionView: UICollectionView,
            performDropWith coordinator: UICollectionViewDropCoordinator
            ) {
            let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)
            for item in coordinator.items {
                if let sourceIndexPath = item.sourceIndexPath {
                    if let url = item.dragItem.localObject as? NSURL {
                        collectionView.performBatchUpdates({
                            imageURLs.remove(at: sourceIndexPath.item)
                            imageURLs.insert((url as URL), at: destinationIndexPath.item)
                            collectionView.deleteItems(at: [sourceIndexPath])
                            collectionView.insertItems(at: [destinationIndexPath])
                        })
                        coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
                    }
                } else {
                    let placeholderContext = coordinator.drop(
                        item.dragItem,
                        to: UICollectionViewDropPlaceholder(insertionIndexPath: destinationIndexPath, reuseIdentifier: "DropPlaceholderCell")
                    )
                    item.dragItem.itemProvider.loadObject(ofClass: NSURL.self) { (provider, error) in
                        DispatchQueue.main.async {
                            if let url = provider as? NSURL {
                                placeholderContext.commitInsertion(dataSourceUpdates: { insertionIndexPath in
                                    self.imageURLs.insert((url as URL).imageURL, at: insertionIndexPath.item)
                                })
                            } else {
                                placeholderContext.deletePlaceholder()
                            }
                        }
                    }
                }
            }
        }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
