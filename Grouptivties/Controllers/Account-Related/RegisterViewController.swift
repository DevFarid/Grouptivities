//
//  RegisterViewController.swift
//  Grouptivties
//
//  Created by Seyyedfarid Kamizi on 6/10/21.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class RegisterViewController: UIViewController, emailValidity, UITextFieldDelegate {
    func isEmailValid(email: String) -> Bool {
        return(email.contains(Character("@")))
    }
    
    private let database = Database.database().reference()

    @IBOutlet weak var usernameDataField: UITextField!
    @IBOutlet weak var emailDataField: UITextField!
    @IBOutlet weak var passwordDataField: UITextField!
    @IBOutlet weak var errorLabelMsg: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        emailDataField.delegate = self
        passwordDataField.delegate = self
    }
    
    @IBAction func buttonTapped(_ sender: Any)
    {
        emailDataField.resignFirstResponder()
        passwordDataField.resignFirstResponder()
        usernameDataField.resignFirstResponder()
        guard let email = emailDataField.text, !email.isEmpty, let password = passwordDataField.text, !password.isEmpty else
        {
            errorLabelMsg.text = "Error! You either left email field, password field blank, or the username field empty."
            return
        }
        if((isEmailValid(email: email) == false))
        {
            errorLabelMsg.text = "Error! Is that a valid email address? Is your password more than 6 characters? Please follow the two requirements in order to create a secure account"
        }
        else
        {
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: {[weak self] result, error in
                guard let strongSelf = self else { return }
                guard error == nil else {
                    strongSelf.errorLabelMsg.text = error?.localizedDescription
                    return
                }
                guard let uid = FirebaseAuth.Auth.auth().currentUser?.uid, let username = self?.usernameDataField.text else {
                    self?.errorLabelMsg.text = "Error! no signed-in account. Couldn't write username in the database! Is the username field blank?"
                    return
                }
                strongSelf.database.child("users/\(uid)").setValue(username)

                
                strongSelf.performSegue(withIdentifier: "registeredToHomePage", sender: self)
            })
        }
    }
    @IBAction func cancelTapped(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
}

extension RegisterViewController {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(emailDataField.isEditing) {
            emailDataField.resignFirstResponder()
            passwordDataField.becomeFirstResponder()
            return true
        }
        else if(passwordDataField.isEditing) {
            passwordDataField.resignFirstResponder()
            buttonTapped("from Function")
            return true
        }
        return false
    }
}

