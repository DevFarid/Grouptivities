//
//  ProfileViewController.swift
//  Grouptivties
//
//  Created by Seyyedfarid Kamizi on 6/11/21.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ProfileViewController: UIViewController {
    
    private let database = Database.database().reference()

    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var displayName: UILabel!
    
    @IBOutlet weak var todayDateLabel: UILabel!
    @IBOutlet weak var potdTitleLabel: UILabel!
    @IBOutlet weak var potdImageView: UIImageView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        todayDateLabel.text = getDateInStyle()
        load()
        
        guard let uID = FirebaseAuth.Auth.auth().currentUser?.uid else { return }
        database.child("users/\(uID)").observeSingleEvent(of: .value, with: {(snapshot) in
            guard let value = snapshot.value as? String else { return }
            self.displayName.text = value
        })
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        if FirebaseAuth.Auth.auth().currentUser != nil
        {
            do {
                try FirebaseAuth.Auth.auth().signOut()
                performSegue(withIdentifier: "signOutToLanding", sender: self)
            }
            catch {
                print(Error.self)
            }
        }
    }
    
    func getDateForNASA() -> String {
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: now)
    }
    
    func load() {
        let baseURL = URL(string: "https://api.nasa.gov/planetary/apod")!
        let query: [String: String] = [
            "api_key": "DEMO_KEY",
            "date": getDateForNASA()
        ]
        
        let url = baseURL.withQueries(query)!
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            guard let data = data, error == nil else { return }
            do {
                let jsonData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: String]
                print(jsonData)
                DispatchQueue.main.async {
                    self.potdTitleLabel.text = jsonData["title"]
                }
            } catch {}
        }).resume()
    }
    
    func getDateInStyle() -> String {
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .none
        return formatter.string(from: now)
    }
}

extension URL {
    func withQueries(_ queries: [String: String]) -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.queryItems = queries.compactMap { URLQueryItem(name: $0.0, value: $0.1)}
        
        return components?.url
    }
}
