//
//  GalleryTopicsTableViewController.swift
//  Image Gallery
//
//  Created by Alwin Firmansyah on 5/21/18.
//  Copyright © 2018 Alwin Firmansyah. All rights reserved.
//

import UIKit

class GalleryTopicsViewController: UITableViewController, UISplitViewControllerDelegate {
    
    // -------------------------------------------------------------------------------
    // MARK: - Persistence
    // -------------------------------------------------------------------------------

    override func viewWillAppear(_ animated: Bool) {
        imageGalleries = GroupOfImageGalleries()
        
        if let url = try? FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
            ).appendingPathComponent("ImageGallery.json") {
            if let jsonData = try? Data(contentsOf: url) {
                imageGalleries = GroupOfImageGalleries(json: jsonData)!
            }
        }
    }
    
    var imageGalleries = GroupOfImageGalleries()
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        if let json = imageGalleries.json {
            if let url = try? FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            ).appendingPathComponent("ImageGallery.json") {
                do {
                    try json.write(to: url)
                    print("saved successfully!")
                } catch let error {
                    print("couldn't save \(error)")
                }
            }
//            if let jsonString = String(data: json, encoding: .utf8) {
//                print("\n START OF JSON ---------------------------------------------------------")
//                print(jsonString)
//                print("END OF JSON ---------------------------------------------------------" + "\n")
//            }
        }
    }

    // -------------------------------------------------------------------------------
    // MARK: - ViewController LifeCycle and Layout
    // -------------------------------------------------------------------------------
    
    override func viewDidLoad() {
        self.title = "Topics"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        splitViewController?.delegate = self
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        if let imageGalleryVC = secondaryViewController as? ImageGalleryViewController {
            if imageGalleryVC.imageGallery == nil {
                return true
            }
        }
        return false
    }
    
    // -------------------------------------------------------------------------------
    // MARK: - Tableview Data Related
    // -------------------------------------------------------------------------------
    
    @IBAction func addTopic(_ sender: UIBarButtonItem) {
        let newTopic = "Untitled".madeUnique(withRespectTo: GroupOfImageGalleries.topics)
        GroupOfImageGalleries.topics.insert(newTopic, at: 0)
        GroupOfImageGalleries.arrayOfImageGalleries.insert(ImageGalleryModel(topic: newTopic, identifier: GroupOfImageGalleries.topics.count), at: 0)
        imageGalleries = GroupOfImageGalleries()

        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return GroupOfImageGalleries.arrayOfImageGalleries.count
        } else {
            return GroupOfImageGalleries.arrayOfRecentlyDeletedImageGalleries.count
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
                let text = NSAttributedString(string: GroupOfImageGalleries.recentlyDeletedTopics[indexPath.row], attributes: [.font : font])
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
                    GroupOfImageGalleries.recentlyDeletedTopics.append(GroupOfImageGalleries.topics[indexPath.row])
                    GroupOfImageGalleries.arrayOfRecentlyDeletedImageGalleries.append(GroupOfImageGalleries.arrayOfImageGalleries[indexPath.row])
                    
                    GroupOfImageGalleries.topics.remove(at: indexPath.row)
                    GroupOfImageGalleries.arrayOfImageGalleries.remove(at: indexPath.row)
                    imageGalleries = GroupOfImageGalleries()
                    
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    tableView.insertRows(at: [indexPathOfLastRow], with: .fade)
                })
            } else {
                tableView.performBatchUpdates({
                    GroupOfImageGalleries.recentlyDeletedTopics.remove(at: indexPath.row)
                    GroupOfImageGalleries.arrayOfRecentlyDeletedImageGalleries.remove(at: indexPath.row)
                    imageGalleries = GroupOfImageGalleries()
                    
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    tableView.reloadData()
                })
            }
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
                        self?.imageGalleries = GroupOfImageGalleries()
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
        
        let undeleteAction = UIContextualAction(style: .normal, title: "Add") {
            [weak self] (contextAction: UIContextualAction, sourceView: UIView, completionHandler: (Bool) -> Void) in
            self?.tableView.performBatchUpdates({
                GroupOfImageGalleries.topics.append(GroupOfImageGalleries.recentlyDeletedTopics[indexPath.row])
                GroupOfImageGalleries.arrayOfImageGalleries.append(GroupOfImageGalleries.arrayOfRecentlyDeletedImageGalleries[indexPath.row])
                
                GroupOfImageGalleries.recentlyDeletedTopics.remove(at: indexPath.row)
                GroupOfImageGalleries.arrayOfRecentlyDeletedImageGalleries.remove(at: indexPath.row)

                self?.imageGalleries = GroupOfImageGalleries()
                
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
            return "Available"
        } else if section == 1, GroupOfImageGalleries.recentlyDeletedTopics.count > 0 {
            return "Recently Deleted"
        } else {
            return nil
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show Gallery" {
            if let destination = segue.destination as? ImageGalleryViewController {
                destination.navigationItem.title = currentlySelectedTopic
                destination.imageGallery = currentlySelectedImageGallery
            }
        }
    }

}
