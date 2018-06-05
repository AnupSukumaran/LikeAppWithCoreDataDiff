//
//  LikeGiverViewController.swift
//  LikeApp
//
//  Created by Sukumar Anup Sukumaran on 05/04/18.
//  Copyright © 2018 AssaRadviewTech. All rights reserved.
//

import UIKit

class LikeGiverViewController: UIViewController {
    // the id for variable that stores the cell no. from the viewController tableview
    var id = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        print("ID = \(id)")
        // stores the id in the global variable which is a singletone
       Constants.sharedInt.id = id
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func LikeAction(_ sender: Any) {
        // on action of like button , it post a notification in the name of given in the singleton variable. this communicates with the viewController class and adds the likes in core data class.
        NotificationCenter.default.post(name: Constants.sharedInstance , object: nil)
    }
    
    
    @IBAction func BackAction(_ sender: Any) {
        // dismiss the view controller.
        dismiss(animated: true, completion: nil)
    }
    
    

}
