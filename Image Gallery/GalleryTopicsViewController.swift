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
    // MARK: - Tableview Data Related
    // -------------------------------------------------------------------------------
    
    private var recentlyDeletedList = [String]()
    private var recentlyRemovedImageGalleries = [ImageGalleryModel]()
    
    @IBAction func addTopic(_ sender: UIBarButtonItem) {
        let newTopic = "Untitled".madeUnique(withRespectTo: GroupOfImageGalleries.topics)
        GroupOfImageGalleries.topics += [newTopic]
        GroupOfImageGalleries.arrayOfImageGalleries += [ImageGalleryModel(topic: newTopic, identifier: GroupOfImageGalleries.topics.count)]
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return GroupOfImageGalleries.topics.count
        } else {
            return recentlyDeletedList.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Text Field", for: indexPath)
        
        if let inputCell = cell as? TextFieldTableViewCell {
            inputCell.textField.isEnabled = false
            
            if indexPath.section == 0 {
                let text = NSAttributedString(string: GroupOfImageGalleries.topics[indexPath.row], attributes: [.font : font])
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
        let indexPathOfLastRow = IndexPath(row: tableView.numberOfRows(inSection: 1), section: 1)

        if editingStyle == .delete {
            // Delete the row from the data source
            if indexPath.section == 0 {
                tableView.performBatchUpdates({
                    recentlyDeletedList.append(GroupOfImageGalleries.topics[indexPath.row])
                    recentlyRemovedImageGalleries.append(GroupOfImageGalleries.arrayOfImageGalleries[indexPath.row])
                    
                    GroupOfImageGalleries.topics.remove(at: indexPath.row)
                    GroupOfImageGalleries.arrayOfImageGalleries.remove(at: indexPath.row)
                    
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    tableView.insertRows(at: [indexPathOfLastRow], with: .fade)
                })
            } else {
                tableView.performBatchUpdates({
                    recentlyDeletedList.remove(at: indexPath.row)
                    recentlyRemovedImageGalleries.remove(at: indexPath.row)
                    
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    tableView.reloadData()
                })
            }
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
                        GroupOfImageGalleries.topics[cellIndexPath.row] = text
                        GroupOfImageGalleries.arrayOfImageGalleries[cellIndexPath.row].topic = text
                        self?.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    @objc private func goToImageGallery(_ recognizer: UITapGestureRecognizer) {
        if let tappedCell = recognizer.view as? UITableViewCell {
            if let cellIndexPath = tableView.indexPath(for: tappedCell), cellIndexPath.section == 0 {
                currentlySelectedTopic = GroupOfImageGalleries.topics[cellIndexPath.row]
                currentlySelectedImageGallery = GroupOfImageGalleries.arrayOfImageGalleries[cellIndexPath.row]
                performSegue(withIdentifier: "Show Gallery", sender: self)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.section == 1 {
            let undelete = undeleteRow(forRowAtIndexPath: indexPath)
            let swipeConfig = UISwipeActionsConfiguration(actions: [undelete])
            return swipeConfig
        } else {
            return nil
        }
    }
    
    private func undeleteRow(forRowAtIndexPath indexPath: IndexPath) -> UIContextualAction {
        let indexPathOfLastRow = IndexPath(row: tableView.numberOfRows(inSection: 0), section: 0)
        
        let undeleteAction = UIContextualAction(style: .normal, title: "Undelete") {
            [weak self] (contextAction: UIContextualAction, sourceView: UIView, completionHandler: (Bool) -> Void) in
            self?.tableView.performBatchUpdates({
                GroupOfImageGalleries.topics.append(self!.recentlyDeletedList[indexPath.row])
                GroupOfImageGalleries.arrayOfImageGalleries.append(self!.recentlyRemovedImageGalleries[indexPath.row])
                
                self?.recentlyDeletedList.remove(at: indexPath.row)
                self?.recentlyRemovedImageGalleries.remove(at: indexPath.row)
                
                self?.tableView.deleteRows(at: [indexPath], with: .fade)
                self?.tableView.insertRows(at: [indexPathOfLastRow], with: .fade)
            })
            completionHandler(true)
        }
        return undeleteAction
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
    
    private var currentlySelectedTopic: String?
    private var currentlySelectedImageGallery: ImageGalleryModel?
//    private var arrayOfSavedImageGalleries = [ImageGalleryModel]()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show Gallery" {
            if let destination = segue.destination as? ImageGalleryViewController {
                destination.navigationItem.title = currentlySelectedTopic
                destination.imageGallery = currentlySelectedImageGallery
            }
        }
    }

}
