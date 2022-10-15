//
//  LoginViewController.swift
//  Grouptivties
//
//  Created by Seyyedfarid Kamizi on 6/10/21.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailDataField: UITextField!
    @IBOutlet weak var passwordDataField: UITextField!
    @IBOutlet weak var errorLabelMsg: UILabel!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        emailDataField.delegate = self
        passwordDataField.delegate = self
    }
    

    @IBAction func loginTapped(_ sender: Any)
    {
        emailDataField.resignFirstResponder()
        passwordDataField.resignFirstResponder()
        guard let email = emailDataField.text, !email.isEmpty,
              let password = passwordDataField.text, !password.isEmpty else
        {
            errorLabelMsg.text = "Error! You either left email field or password field blank."
            return
        }

        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: {[weak self] result, error in
            guard let strongSelf = self else { return }
            guard error == nil else {
                strongSelf.errorLabelMsg.text = error?.localizedDescription
                return
            }
            strongSelf.performSegue(withIdentifier: "loginToHomePage", sender: self)
        })
    }
    
    @IBAction func forgotPassTapped(_ sender: Any) {
        performSegue(withIdentifier: "forgotPasswordSegue", sender: self)
    }
    
    @IBAction func doneTapped(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
}

extension LoginViewController {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(emailDataField.isEditing) {
            emailDataField.resignFirstResponder()
            passwordDataField.becomeFirstResponder()
            return true
        }
        else if(passwordDataField.isEditing) {
            passwordDataField.resignFirstResponder()
            loginTapped("from Function")
            return true
        }
        return false
    }
}
