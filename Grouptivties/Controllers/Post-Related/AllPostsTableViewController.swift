//
//  AllPostsTableViewController.swift
//  Grouptivties
//
//  Created by Seyyedfarid Kamizi on 6/14/21.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class AllPostsTableViewController: UITableViewController {
    
    static let shared = AllPostsTableViewController()
        
    private let database = Database.database().reference()
    var postData: [Post] = []
    private var currentIndex = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.postData = []
        database.child("posts").observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshotValue = snapshot.value as? [String: [String: String]] else { return }
            let sorted = snapshotValue.sorted { $0.key.lowercased() < $1.key.lowercased() }
            for (key, _) in sorted {

                let keys = snapshotValue[key]
                guard let uuid = keys?["uuid"]
                      ,let title = keys?["title"]
                      ,let description = keys?["description"]
                      ,let date = keys?["date"]
                      ,let poster = keys?["addByUser"]
                      ,let lastModified = keys?["lastModified"] else { return }
                self.postData.append(Post(id: uuid, user: poster, title: title, date: date, content: description, lastModifiedOn: lastModified      ))
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
        
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //print("retunring \(data.count.description)")
        return postData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postReusbleCell", for: indexPath)
        cell.textLabel?.text = postData[indexPath.row].title
        cell.textLabel?.textColor = .white

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentIndex = indexPath.row
        performSegue(withIdentifier: "cellToDetailViewController", sender: self)
    }


    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let userID = FirebaseAuth.Auth.auth().currentUser?.uid else { return nil }
        if(userID == self.postData[indexPath.row].addedByUser) {
            currentIndex = indexPath.row
            let edit = self.edit(rowIndexPathAt: indexPath)
            let delete = self.delete(rowIndexPathAt: indexPath)
            let swipe = UISwipeActionsConfiguration(actions: [delete, edit])
            return swipe
        }
        return nil
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if(!(indexPath.row > postData.count)) {
                postData.remove(at: indexPath.row)
                // Remove from firebase.
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        } else if editingStyle == .insert {
            // direct page to adding a new post view controller
        }    
    }
    // MARK: - UIContexualAction functions
    private func delete(rowIndexPathAt indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, _ in
            guard let self = self else { return }
            self.database.child("posts/\(self.postData[indexPath.row].UUID)").removeValue()
            self.postData.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.tableView.reloadData()
        }
        return action
    }
    
    private func edit(rowIndexPathAt indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Edit", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.performSegue(withIdentifier: "cellToDetailViewController", sender: ac)
            success(true)
        })
        return action
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "cellToDetailViewController") {
            if sender is UIContextualAction {
                let navController = segue.destination as! UINavigationController
                let detailController = navController.topViewController as! PostDetailViewController
                
                detailController.straightToEditing = true
                detailController.data = postData[currentIndex]
                
            } else {
                let navController = segue.destination as! UINavigationController
                let detailController = navController.topViewController as! PostDetailViewController
                
                detailController.data = postData[currentIndex]
            }
        }
    }
 

}
