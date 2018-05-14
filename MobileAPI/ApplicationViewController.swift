//
//  ApplicationViewController.swift
//  MobileAPI
//
//  Created by Sage Conger on 5/14/18.
//  Copyright © 2018 DUBTEL. All rights reserved.
//

import UIKit

class ApplicationViewController: UIViewController {
    
    @IBOutlet weak var logOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func inputIsValid(completion: @escaping (Bool) -> Void) {
        
        let authenticateString = "https://api.dubtel.com/v1/logout"
        
        var request = URLRequest(url: URL(string: authenticateString)!)
        request.httpMethod = "POST"
        
        let postString = "session_id=" + session_id + "&user_id=" + user_id
        
        request.httpBody = postString.data(using: .utf8)
        request.setValue("Basic \(token)", forHTTPHeaderField: "Authorization")
        
        // Create and run a URLSession data task with our JSON encoded POST request
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard let unwrappedData = data else { print("Error unwrapping data"); return }
            
            do {
                let jsonDecoder = JSONDecoder()
                let responseJSON = try jsonDecoder.decode(LogoutResponse.self, from: unwrappedData)
                completion(responseJSON.status == "Success")
            } catch {
                completion(false)
            }
            
        }
        task.resume()
    }
    
    @IBAction func logOutPressed(_ sender: UIButton) {
        inputIsValid { valid in
            if valid {
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
}

