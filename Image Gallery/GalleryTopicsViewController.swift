//
//  GalleryTopicsTableViewController.swift
//  Image Gallery
//
//  Created by Alwin Firmansyah on 5/21/18.
//  Copyright © 2018 Alwin Firmansyah. All rights reserved.
//

import UIKit

class GalleryTopicsViewController: UITableViewController {
    
    // MARK: - Model
    var imageGalleries = [String : ImageGalleryViewController]()

    private var topicsList: [String] = ["Food", "Sports", "People"]
    private var recentlyDeletedList = [String]()
    
    @IBAction func addTopic(_ sender: UIBarButtonItem) {
        topicsList += ["Untitled".madeUnique(withRespectTo: topicsList)]
        tableView.reloadData()
    }

    // MARK: - Table view data source
    
    override func viewDidLoad() {
        self.title = "Topics"
    }
    
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

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Image Galleries"
        } else {
            return "Recently Deleted"
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if editableCell == nil {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Topic", for: indexPath)
                cell.textLabel?.text = topicsList[indexPath.row]
                
                // single tap gesture for navigating to image gallery
                let singleTap = UITapGestureRecognizer(target: self, action: #selector(goToImageGallery(_:)))
                singleTap.numberOfTapsRequired = 1
                cell.addGestureRecognizer(singleTap)
                
                // double tap gesture for editing text
                let doubleTap = UITapGestureRecognizer(target: self, action: #selector(editCellText(_:)))
                doubleTap.numberOfTapsRequired = 2
                cell.addGestureRecognizer(doubleTap)
                
                singleTap.require(toFail: doubleTap)
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Text Field", for: indexPath)
                if let inputCell = cell as? TextFieldTableViewCell {
                    inputCell.resignationHandler = { [weak self, unowned inputCell] in
                        if let text = inputCell.textField.text {
                            self?.topicsList[indexPath.row] = text
                        }
                        self?.editableCell = nil
                        self?.tableView.reloadRows(at: [indexPath], with: .none)
                    }
                }
                
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Topic", for: indexPath)
            cell.textLabel?.text = recentlyDeletedList[indexPath.row]
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let inputCell = cell as? TextFieldTableViewCell {
            inputCell.textField.becomeFirstResponder()
        }
    }
    
    private var editableCell: UITableViewCell?
    
    @objc private func editCellText(_ recognizer: UITapGestureRecognizer) {
        if let tappedCell = recognizer.view as? UITableViewCell {
            if let cellIndexPath = tableView.indexPath(for: tappedCell) {
                editableCell = tappedCell
                tableView.reloadRows(at: [cellIndexPath], with: .none)
            }
        }
    }
    
    @objc private func goToImageGallery(_ recognizer: UITapGestureRecognizer) {
        if let tappedCell = recognizer.view as? UITableViewCell {
            if let cellIndexPath = tableView.indexPath(for: tappedCell) {
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
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        currentlySelectedTopic = topicsList[indexPath.row]
//
//        if let imageGalleryVC = imageGalleries[currentlySelectedTopic!] {
//            imageGalleryVC.navigationItem.title = currentlySelectedTopic
//            splitViewController?.showDetailViewController(imageGalleryVC, sender: self)
//        } else {
//            performSegue(withIdentifier: "Show Gallery", sender: self)
//        }
//    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            if indexPath.section == 0 {
                addTopicToRecentlyDeleted(for: topicsList[indexPath.row])
                topicsList.remove(at: indexPath.row)
            } else {
                recentlyDeletedList.remove(at: indexPath.row)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    private func addTopicToRecentlyDeleted(for topic: String) {
        recentlyDeletedList.append(topic)
        tableView.reloadData()
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    

    // MARK: - Navigation

    
//    override func viewDidLoad() {
//       self.navigationController?.isToolbarHidden = false
//    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if splitViewController?.preferredDisplayMode != .primaryOverlay {
            splitViewController?.preferredDisplayMode = .primaryOverlay
        }
    }
    
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
