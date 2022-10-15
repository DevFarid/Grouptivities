//
//  ViewController.swift
//  Grouptivties
//
//  Created by Seyyedfarid Kamizi on 6/10/21.
//

import UIKit
import FirebaseAuth

class firstTimeLandingPage: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        if FirebaseAuth.Auth.auth().currentUser != nil {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "cachedSignInfoToHomePage", sender: self)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(close))
    }
    
    
    @objc func close()
    {
        self.dismiss(animated: true)
    }

}

