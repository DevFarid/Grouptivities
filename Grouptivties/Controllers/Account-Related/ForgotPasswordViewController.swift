//
//  ForgotPasswordViewController.swift
//  Grouptivties
//
//  Created by Seyyedfarid Kamizi on 6/11/21.
//

import UIKit
import FirebaseAuth
class ForgotPasswordViewController: UIViewController, emailValidity {
    func isEmailValid(email: String) -> Bool {
        return(email.contains(Character("@")))
    }
    

    @IBOutlet weak var emailDataField: UITextField!
    @IBOutlet weak var errorLabelMsg: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationItem.hidesBackButton = false
    }
    
    @IBAction func recoveryButtonTapped(_ sender: Any)
    {
        guard let email = emailDataField.text, !email.isEmpty else {
            errorLabelMsg.text = "Error! The email field is empty"
            return
        }
        if(isEmailValid(email: email)) == false
        {
            errorLabelMsg.text = "Error! Is that a valid email address? Is your password more than 6 characters? Please follow the two requirements in order to create a secure account"
        }
        else {
            FirebaseAuth.Auth.auth().sendPasswordReset(withEmail: email, completion: {[weak self] error in
                guard let strongSelf = self else { return }
                guard error == nil else {
                    strongSelf.errorLabelMsg.text = error?.localizedDescription
                    return
                }
            })
            errorLabelMsg.text = "Success! A recovery email was sent to you!"
        }
    }
    
    @IBAction func doneTapped(_ sender: Any) {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers
        for vc in viewControllers
        {
            if vc is LoginViewController {
                self.navigationController!.popToViewController(vc, animated: true)
                break
            }
        }
    }
}
