//
//  ViewController.swift
//  Jose.garcia23.03.19.CoreData
//
//  Created by Universidad Politecnica de gómez Palacio on 3/25/19.
//  Copyright © 2019 Universidad Politecnica de gómez Palacio. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad()
    {
        super.viewDidLoad()
       
    }
    
    
    @IBAction func registerUser(_ sender: Any)
    {
        let dictionary: [String:String] = ["email": "Joseluis.com", "password": "password", "username": "Joseluis"]
        DBLocal.save(for: "User", attributes: dictionary)
    }
    
    @IBAction func retriveUser(_ sender: Any)
    {
      print(DBLocal.retrieve(for: "User"))
    }
    
    @IBAction func updateUser(_ sender: Any)
    {
        let dictionary: [String:String] = ["email": "Joseluisgarciavills@gmail.com", "password": "password", "username": "Jose"]
        let predicate: NSPredicate = NSPredicate(format: "username = %@", "Jose")
        DBLocal.save(for: "User", attributes: dictionary, where: predicate)
    }
    @IBAction func deleteUser(_ sender: Any)
    {
        let predicate: NSPredicate = NSPredicate(format: "username = %@", "Jose")
        DBLocal.delete(for: "User", where: predicate)
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }


}

