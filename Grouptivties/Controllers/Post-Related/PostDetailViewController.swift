//
//  PostDetailViewController.swift
//  Grouptivties
//
//  Created by Seyyedfarid Kamizi on 6/15/21.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class PostDetailViewController: UIViewController {

    var data: Post = Post()
    private let database = Database.database().reference()
    var straightToEditing: Bool = false

    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postDescription: UILabel!
    @IBOutlet weak var postedBy: UILabel!
    @IBOutlet weak var postedOn: UILabel!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var modifiedOn: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(straightToEditing) {
            editTapped("from Function")
        }
    }
    
    override func viewDidLoad() {
        guard let userID = FirebaseAuth.Auth.auth().currentUser?.uid else { return }
        if(data.addedByUser != userID) {
            editButton.isEnabled = false
        }
        database.child("posts/\(data.UUID)").observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshotValue = snapshot.value as? [String: String] else { return }
            guard let uuid = snapshotValue["uuid"]
                  ,let title = snapshotValue["title"]
                  ,let description = snapshotValue["description"]
                  ,let date = snapshotValue["date"]
                  ,let poster = snapshotValue["addByUser"]
                  ,let modHistory = snapshotValue["lastModified"] else { return }
            DispatchQueue.main.async {
                self.data = Post(id: uuid, user: poster, title: title, date: date, content: description, lastModifiedOn: modHistory)
            }
        })
        
        super.viewDidLoad()
        postTitle.text = data.title
        postDescription.text = data.description
        postedOn.text = "Originally on " + data.date
        
        database.child("users/\(data.addedByUser)").observeSingleEvent(of: .value, with: {(snapshot) in
            guard let value = snapshot.value as? String else { return }
            self.postedBy.text = value
        })
        
        guard let modHis = data.modifiedOn, !modHis.isEmpty else {
            modifiedOn.text = ""
            modifiedOn.isHidden = true
            modifiedOn.isEnabled = false
            return
        }
        modifiedOn.text = "Modified on " + modHis
        
        
    }
    @IBAction func doneTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editTapped(_ sender: Any) {
        performSegue(withIdentifier: "detailToEditSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "detailToEditSegue") {
            let editController = segue.destination as! EditPostViewController
            
            editController.oncomingData = data
   
        }
    }
    
}
