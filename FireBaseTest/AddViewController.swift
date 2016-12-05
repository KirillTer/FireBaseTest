//
//  AddViewController.swift
//  FireBaseTest
//
//  Created by Admin on 12/4/16.
//  Copyright © 2016 KirillTer. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
//import MainTableViewController

class AddViewController: UIViewController {
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func saveAction(_ sender: AnyObject) {
        guard let name = nameText.text else{
            print("incorect inputs")
            return
        }
        guard let email = emailText.text else{
            print("incorect inputs")
            return
        }
        guard let password = passwordText.text else{
            print("incorect inputs")
            return
        }
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                print(error)
                return
            }
            var ref: FIRDatabaseReference!
            ref = FIRDatabase.database().reference(fromURL:"https://fir-test-1d23e.firebaseio.com/")
            let usersReferences = ref.child("users").child((user?.uid)!)
            usersReferences.updateChildValues(["name":name,"email":email])
        })
        navigationController!.popViewController(animated: true)
        
        print("save pressed")
    }
}
