//
//  MainTableViewController.swift
//  FireBaseTest
//
//  Created by Admin on 12/4/16.
//  Copyright © 2016 KirillTer. All rights reserved.
//

import UIKit
import Firebase

class MainTableViewController: UITableViewController {

    let cellId = "cell"
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUser()
    }

    func fetchUser() {
        FIRDatabase.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            print(snapshot)
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = User()
                
                //if you use this setter, your app will crash if your class properties don't exactly match up with the firebase dictionary keys
                user.setValuesForKeys(dictionary)
                self.users.append(user)
                
                //this will crash because of background thread, so lets use dispatch_async to fix
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                print(self.users)
            }
            
            }, withCancel: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let uid = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot)
            }, withCancel: nil)
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        print(user.email)
        return cell
    }

}
