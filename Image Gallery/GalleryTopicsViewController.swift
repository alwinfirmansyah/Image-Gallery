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
    
    var topicsList = ["Food", "Sports", "People"]
    var recentlyDeletedList = [String]()
    var currentTopic = ""
    
    @IBAction func addTopic(_ sender: UIBarButtonItem) {
        topicsList += ["Untitled".madeUnique(withRespectTo: topicsList)]
        tableView.reloadData()
    }

    // MARK: - Table view data source
    
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
            return "Topics"
        } else {
            return "Recently Deleted"
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Topic", for: indexPath)
            cell.textLabel?.text = topicsList[indexPath.row]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Topic", for: indexPath)
            cell.textLabel?.text = recentlyDeletedList[indexPath.row]
            return cell
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

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

    
    override func viewDidLoad() {
       self.navigationController?.isToolbarHidden = false
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if splitViewController?.preferredDisplayMode != .primaryOverlay {
            splitViewController?.preferredDisplayMode = .primaryOverlay
        }
    }

}
