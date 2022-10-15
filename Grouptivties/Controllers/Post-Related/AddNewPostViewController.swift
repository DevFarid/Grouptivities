//
//  AddNewPostViewController.swift
//  Grouptivties
//
//  Created by Seyyedfarid Kamizi on 6/14/21.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class AddNewPostViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    private let database = Database.database().reference()
    private var currentIndex: Int = 0
    @IBOutlet weak var postTitle: UITextField!
    @IBOutlet weak var postDescription: UITextView!
    @IBOutlet weak var errorLabelMsg: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postTitle.delegate = self
        postDescription.delegate = self
    }
    

    @IBAction func backTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return .portrait
        }
    }
    
    @IBAction func postTapped(_ sender: Any) {
        postTitle.resignFirstResponder()
        postDescription.resignFirstResponder()
        guard let title = postTitle.text, !title.isEmpty, let description = postDescription.text, !description.isEmpty else {
            errorLabelMsg.text = "You left the title or the description empty. Please make your post meaning full!"
            return
        }
        
        guard let user = FirebaseAuth.Auth.auth().currentUser else {
            errorLabelMsg.text = "You are not signed in! Please refresh the app"
            return
        }
        
        let id = UUID()
        
        let object: [String: String] = [
            "uuid": id.description as String,
            "addByUser": user.uid.description as String,
            "title": title as String,
            "date": getCurrentDate() as String,
            "lastModified":"" as String,
            "description": description as String
        ]
        
        database.child("posts/\(id)").setValue(object)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    private func getCurrentDate() -> String {
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .full
        let datetime = formatter.string(from: now)
        
        return datetime
    }
}

extension AddNewPostViewController {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(postTitle.isEditing) {
            postTitle.resignFirstResponder()
            postDescription.becomeFirstResponder()
        }
        return true
    }
}

extension AddNewPostViewController {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n")
        {
            textView.resignFirstResponder()
            postTapped("from Function")
            return false
        }
        return true
    }
}
