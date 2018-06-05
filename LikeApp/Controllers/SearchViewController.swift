//
//  SearchViewController.swift
//  LikeApp
//
//  Created by Sukumar Anup Sukumaran on 12/04/18.
//  Copyright © 2018 AssaRadviewTech. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    // connection to the tableview that displays the search results
    @IBOutlet weak var searchTable: UITableView!
    //text field to search
    @IBOutlet weak var SearchField: UITextField!
    

    var providersAPI = APIService()
    
    var searchDetails = [SearchDetails]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        SearchField.delegate = self
        SearchField.clearButtonMode = .whileEditing
        
        SearchField.allowsEditingTextAttributes = true
        SearchField.autocorrectionType = UITextAutocorrectionType.no
      
        calllingURl()
    }
    
    // Every time text in textField changes event happens.
    
    @IBAction func TextChanged(_ sender: UITextField) {
        
        // clearing the content in keywords variable just to be safe.
        APIService.sharedInstance.keyWords.removeAll()
        //clearing the searchDetails array
        searchDetails.removeAll()
        //reload tableview
        searchTable.reloadData()
        
        
        let key: AnyObject = SearchField.text as AnyObject
        
        print("Key = \(key)")
        
        // Giving values for keys as String
        APIService.sharedInstance.keyWords = key as! String
       // providersAPI.keyWords = key as! String
        
        // Calling URL
        calllingURl()
    }

    
    // calling ApiService to called the url function for search func
    func calllingURl() {
       
        APIService.sharedInstance.searchApi { (values) in
            switch values {
            case .Success(let data):
                // func to parse data according to data type
                self.jsonResultParse(data as AnyObject)
                
            case .Error(let message):
                print("Error = \(message)")
            }
        }
        
        
    }
    
    //func to parse the data
    func jsonResultParse(_ json:AnyObject) {
        // in the apiservice class we are parsing the data as dictionary and that the data is of array type. so that why the nsArray type.
        let JsonArray = json as! NSArray
        
        print("jsonaArray = \(JsonArray.count)")
        
        // checking if the array is not empty.
        if JsonArray.count != 0 {
            //loop for itterate till the count ends.
            for i:Int in 0 ..< JsonArray.count {
                // since the elements are of type Dictionary
                let jobject = JsonArray[i] as! NSDictionary
                // creating a local variable of type searchDetails class.
                let UsearchDetails: SearchDetails = SearchDetails()
                //calling the elements by key words.
                UsearchDetails.photo = jobject["photo"] as? String ?? ""
                UsearchDetails.name = jobject["name"] as? String ?? ""
                //append the at each loop.
                searchDetails.append(UsearchDetails)
            }
            //reload the table after the loop ends. at each reload uitabledatasource is called
            searchTable.reloadData()
        }
    }
    
    //just to dismiss the present vc.
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}

// extending the class with uitableviewDataSource.
extension SearchViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Couunt = \(searchDetails.count)")
        return searchDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableTableViewCell", for: indexPath) as! SearchTableTableViewCell
        
       cell.nameLabel.text = searchDetails[indexPath.row].name
        
        return cell
    }
  
}

extension SearchViewController: UITextFieldDelegate {
    
    //this is to resign the keyboard of the app at the press of the return button.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //SearchField is the text field
        SearchField.resignFirstResponder()
        
        return true
    }
    
}


