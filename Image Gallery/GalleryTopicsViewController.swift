//
//  GalleryTopicsTableViewController.swift
//  Image Gallery
//
//  Created by Alwin Firmansyah on 5/21/18.
//  Copyright © 2018 Alwin Firmansyah. All rights reserved.
//

import UIKit

class GalleryTopicsViewController: UITableViewController {
    
    // -------------------------------------------------------------------------------
    // MARK: - Model
    // -------------------------------------------------------------------------------
    
    var topicsList: [String] = ["Food", "Sports", "People"]
    private var recentlyDeletedList = [String]()
    
    @IBAction func addTopic(_ sender: UIBarButtonItem) {
        topicsList += ["Untitled".madeUnique(withRespectTo: topicsList)]
        tableView.reloadData()
    }
    
    // -------------------------------------------------------------------------------
    // MARK: - Tableview Data Related
    // -------------------------------------------------------------------------------
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return topicsList.count
        } else {
            return recentlyDeletedList.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Text Field", for: indexPath)
        
        if let inputCell = cell as? TextFieldTableViewCell {
            inputCell.textField.isEnabled = false
            
            if indexPath.section == 0 {
                let text = NSAttributedString(string: topicsList[indexPath.row], attributes: [.font : font])
                inputCell.textField.attributedText = text
    
                // single tap gesture for navigating to image gallery
                let singleTap = UITapGestureRecognizer(target: self, action: #selector(goToImageGallery(_:)))
                singleTap.numberOfTapsRequired = 1
                inputCell.addGestureRecognizer(singleTap)
                
                // double tap gesture for editing text
                let doubleTap = UITapGestureRecognizer(target: self, action: #selector(editCellText(_:)))
                doubleTap.numberOfTapsRequired = 2
                inputCell.addGestureRecognizer(doubleTap)
                
                singleTap.require(toFail: doubleTap)
                
                return inputCell
            } else {
                let text = NSAttributedString(string: recentlyDeletedList[indexPath.row], attributes: [.font : font])
                inputCell.textField.attributedText = text
                return inputCell
            }
        } else {
            return cell
        }
    }
    
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            if indexPath.section == 0 {
                addTopicToRecentlyDeleted(for: topicsList[indexPath.row])
                topicsList.remove(at: indexPath.row)
            } else {
                let removedTopic = recentlyDeletedList[indexPath.row]
                imageGalleries[removedTopic] = nil
                recentlyDeletedList.remove(at: indexPath.row)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    // -------------------------------------------------------------------------------
    // MARK: - Gesture and utility functions
    // -------------------------------------------------------------------------------
    
    @objc private func editCellText(_ recognizer: UITapGestureRecognizer) {
        if let tappedCell = recognizer.view as? TextFieldTableViewCell {
            if let cellIndexPath = tableView.indexPath(for: tappedCell), cellIndexPath.section == 0  {
                tappedCell.textField.isEnabled = true
                tappedCell.textField.becomeFirstResponder()
                
                tappedCell.resignationHandler = { [weak self, unowned tappedCell] in
                    if let text = tappedCell.textField.text {
                        self?.topicsList[cellIndexPath.row] = text
//                        self?.tableView.reloadRows(at: [cellIndexPath], with: .none)
                        self?.tableView.reloadData()
                    }
                }
                
            }
        }
    }
    
    @objc private func goToImageGallery(_ recognizer: UITapGestureRecognizer) {
        if let tappedCell = recognizer.view as? UITableViewCell {
            if let cellIndexPath = tableView.indexPath(for: tappedCell), cellIndexPath.section == 0 {
                currentlySelectedTopic = topicsList[cellIndexPath.row]
                
                if let imageGalleryVC = imageGalleries[currentlySelectedTopic!] {
                    imageGalleryVC.navigationItem.title = currentlySelectedTopic
                    splitViewController?.showDetailViewController(imageGalleryVC, sender: self)
                } else {
                    performSegue(withIdentifier: "Show Gallery", sender: self)
                }
            }
        }
    }
    
    private func addTopicToRecentlyDeleted(for topic: String) {
        recentlyDeletedList.append(topic)
        tableView.reloadData()
    }
    
    // -------------------------------------------------------------------------------
    // MARK: - Tableview Design and Font
    // -------------------------------------------------------------------------------
    
    private var font: UIFont {
        return UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont.preferredFont(forTextStyle: .body).withSize(18.0))
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Image Galleries"
        } else {
            return "Recently Deleted"
        }
    }
    
    // -------------------------------------------------------------------------------
    // MARK: - Navigation and Layout
    // -------------------------------------------------------------------------------

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if splitViewController?.preferredDisplayMode != .primaryOverlay {
            splitViewController?.preferredDisplayMode = .primaryOverlay
        }
    }
    
    private var imageGalleries = [String : ImageGalleryViewController]()
    private var currentlySelectedTopic: String?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show Gallery" {
            if let destination = segue.destination as? ImageGalleryViewController {
                destination.navigationItem.title = currentlySelectedTopic
                imageGalleries[currentlySelectedTopic!] = destination
            }
        }
    }

}
