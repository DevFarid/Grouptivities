//
//  EditPostViewController.swift
//  Grouptivties
//
//  Created by Seyyedfarid Kamizi on 6/17/21.
//

import UIKit
import FirebaseDatabase

class EditPostViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    var oncomingData: Post = Post()
    private let database = Database.database().reference()

    @IBOutlet weak var postTitle: UITextField!
    @IBOutlet weak var postDescription: UITextView!
    @IBOutlet weak var errorLabelMsg: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postTitle.delegate = self
        postDescription.delegate = self
        
        postTitle.text = oncomingData.title
        postDescription.text = oncomingData.description
        postTitle.becomeFirstResponder()
    }
    

    @IBAction func editPostButtonTapped(_ sender: Any) {
        guard let title = postTitle.text, !title.isEmpty, let description = postDescription.text, !description.isEmpty else {
            errorLabelMsg.text = "You left the title or description blank. Please enter a title and description for respectable fields."
            return
        }
        
        oncomingData = Post(id: oncomingData.UUID, user: oncomingData.addedByUser, title: title, date: oncomingData.date, content: description, lastModifiedOn: oncomingData.modifiedOn)
        let object: [String: String] = [
            "uuid": oncomingData.UUID as String,
            "addByUser": oncomingData.addedByUser as String,
            "title": title as String,
            "date": oncomingData.date as String,
            "lastModified": getCurrentDate() as String,
            "description": description as String
        ]
        
        database.child("posts/\(oncomingData.UUID)").setValue(object)
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func backTapped(_ sender: Any) {
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

extension EditPostViewController {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(postTitle.isEditing) {
            postTitle.resignFirstResponder()
            postDescription.becomeFirstResponder()
        }
        return true
    }
}

extension EditPostViewController {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n")
        {
            textView.resignFirstResponder()
            editPostButtonTapped("from Function")
            return false
        }
        return true
    }
}
