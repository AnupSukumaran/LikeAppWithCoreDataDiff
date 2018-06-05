//
//  ViewController.swift
//  LikeApp
//
//  Created by Sukumar Anup Sukumaran on 05/04/18.
//  Copyright © 2018 AssaRadviewTech. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    // table gets connected to the uiviewcontroller
    @IBOutlet weak var LikeTableView: UITableView!
    
    //calling the model file from like class created for COREDATA ie persistanty saving the data in a variable as Array type
    var likeSaver2 = [LikeClass]()
    
    // creating an instance to store an array of Model file of type ModelContents class
    var modelContent = [ModelContents]()
     
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // calling the function which calls the func from with the completion block from the APIService class.
        calllingURl()
       
    
    }
    

    
    func calllingURl() {
        
        // called the singleton to call the func of api calling with the completion block.
        APIService.sharedInstance.getDataWith { (values) in
            
            //"values" variable can have two case , .Success and .Error, .Success accepts generic data types and .Error accepts String Dataype.
            switch values {
            case .Success(let data):
                
//                self.saveInCoreDataWith(array: (data as AnyObject) as! [[String : AnyObject]])
                self.saveInCoreDataWith(data as [[String: AnyObject]])
            case .Error(let message):
                //just prints the error as localizedDescription
                print("Error = \(message)")
            }
            
        }
  
    }
    
//    private func saveInCoreDataWith(array: [[String: AnyObject]]) {
//
//
//    }
    
    private func saveInCoreDataWith(_ array: [[String: AnyObject]]) {
        
        _  = array.map{ self.createModelBlocks(dictionary: $0)!}
        LikeTableView.reloadData()
        fetchingDataFromCore()
        PostingNotification()
        
    }
    
    
    private func createModelBlocks(dictionary: [String: AnyObject]) -> ModelContents? {
        
        let modelData =  ModelContents()
        
        modelData.artistName = dictionary["artistName"] as? String
        modelData.artistUrl = dictionary["artistUrl"] as? String
        
        modelContent.append(modelData)
        print("Array = \(String(describing: modelContent[0].artistName))")
        return modelData
    }
    
   
    
    // function to fetch data while loading the app ie after calling viewdidload
    func fetchingDataFromCore() {
        
        // creates an instance of type  NSFetchRequest of type LikeClass which is of type NSManagedObject. NSManaged object has a func called "fetchRequest()".
        let fetchRequest: NSFetchRequest<LikeClass> = LikeClass.fetchRequest()
        
        // do catch method is called to catch an error if occured.
        do {
            print("FetchingWorking")
            // created an constant which calls the class "PersistanceService()" which calls the static variable of type "NSManagedObjectContext" called "context"(it returns a "persistentContainer" varible of type NSPersistenctContainer), which has a func called fetch request and accepts constructers of type "NSFetchRequest".
            let likes =  try PersistanceService.context.fetch(fetchRequest)
            
            // likes is of type array of Likeclass([LikeClass]).
            if likes.isEmpty {
                print(" likes.isEmpty = \( likes.isEmpty)")
                //if likes array is empty calls a function to add likes.(fresh new likes)
                addLikes()
            }else{
                //if not empty , likes count which is alwayes be there until app get uninstalled, get saved in the likeSaver2 variable of type array of LikeClass - [LikeClass]().
                self.likeSaver2 = likes
                
                //table gets reloaded after
                self.LikeTableView.reloadData()
            }
            
        } catch (let error){
            //to whats the error when "try PersistanceService.context.fetch(fetchRequest)"
            print("CoreData ERROR = \(error.localizedDescription)")
        }
        
    }
    
    
    
    //this function is called if the like class is empty to fill in the '0' like count in  like label initially
    func addLikes() {
        print("addLikes Working")
        
        //counts the number of likes array count needed according to content 
        for i in 0..<modelContent.count {
            
            print("FORCount = \(i)")
            //since the like class is of "NSManagedObject" class we can call the context parameter for the LikeClass and input context(oftype "NSManageObjectContext") of the PersistanceService class ie "NSManageObjectContext" to "NSManagedObject"
            let data2 = LikeClass(context: PersistanceService.context)
            data2.likecount = 0 // "likecount" is the "attribute" of the "entity" called "LikeClass"
            likeSaver2.append(data2) // append the data2 varaible to the likesaver2
            //then save the context using PersistanceService class ie  closing the lid after putting the data in the box
            PersistanceService.saveContext()
        }
        //
        LikeTableView.reloadData()
    }
    
    //this function gets called from the the vc and adds the observer for Notification center for the name given in singletone.
    func PostingNotification(){
        
        NotificationCenter.default.addObserver(forName: Constants.sharedInstance, object: nil, queue: nil, using: {_ in
    
            print("Cell Id = \(Constants.sharedInt.id)")
            // accessing the likeSave2 array with the selection id made on this cell.
            // likecount will be incremmented on each button click made on the like button on the "LikeGiverViewController" class file.
            self.likeSaver2[Constants.sharedInt.id].likecount += 1
            
            // saving the content
            PersistanceService.saveContext()
            // reload or refresh the table
            self.LikeTableView.reloadData()
            
        })
    }
    
    // if pressed the button call the "SearchViewController" class file
    @IBAction func ToSearchVC(_ sender: UIBarButtonItem) {
        //to SearchViewController
        
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        
       let nav = UINavigationController(rootViewController: vc)
        
        present(nav, animated: true, completion: nil)
        
    }
    
   
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
   


}

//with extension I am going to call an addtional class "UITableViewDataSource" to the viewControler
extension ViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelContent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LikeTableViewCell", for: indexPath) as! LikeTableViewCell
        
        cell.LikeCountLabel.text = String(likeSaver2[indexPath.row].likecount)
        cell.TopLineLabel.text = modelContent[indexPath.row].artistName
        cell.descTextView.text = modelContent[indexPath.row].artistUrl
        
        return cell
    }
    
    
    
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
         
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LikeGiverViewController") as! LikeGiverViewController
        
        // onclick passes the id which is the cell no.
        vc.id = indexPath.row
        
        present(vc, animated: true, completion: nil)
    }
    
}

