//
//  SingleImageViewController.swift
//  Image Gallery
//
//  Created by Alwin Firmansyah on 5/25/18.
//  Copyright © 2018 Alwin Firmansyah. All rights reserved.
//

import UIKit

class SingleImageViewController: UIViewController, UIScrollViewDelegate {

    var imageURL: URL? {
        didSet {
            image = nil
            if view.window != nil {
                fetchImage()
            }
        }
    }
    
    private var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            imageScrollView?.contentSize = imageView.frame.size
            imageLoadingSpinner?.stopAnimating()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if imageView.image == nil {
            fetchImage()
        }
    }
    
    @IBOutlet weak var imageLoadingSpinner: UIActivityIndicatorView!

    @IBOutlet weak var imageScrollView: UIScrollView! {
        didSet {
            imageScrollView.minimumZoomScale = 1/10
            imageScrollView.maximumZoomScale = 10
            imageScrollView.delegate = self
            imageScrollView.addSubview(imageView)
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    var imageView  = UIImageView()
    
    private func fetchImage() {
        if let url = imageURL {
            imageLoadingSpinner.startAnimating()
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
