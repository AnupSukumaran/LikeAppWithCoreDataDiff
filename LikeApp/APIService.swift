//
//  APIService.swift
//  LikeApp
//
//  Created by Sukumar Anup Sukumaran on 11/04/18.
//  Copyright © 2018 AssaRadviewTech. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

// create two enumerated case with generic type (ie any types of datas are accepted)
enum Result <T> {
    case Success(T)
    case Error(String)
}

// created a class for base url
class baseUrl {
    //http://mobiroidtec.in/laundry/Webservice/
    static let link = "https://rss.itunes.apple.com/api/v1/in/ios-apps/top-free/all/10/explicit.json"
    static let link2 = "http://searchdeal.co.in/business-profile/digital/apideals/usercategorylistsearch.php?"
}

// creating a class for api calling service functions
class APIService: NSObject {
    
    //this is called in static to create a sinletone so you dont need to create a property to cll this class globally.
    static var sharedInstance = APIService()
    
    // this is for the search controller api to serach by keywords
    var keyWords = ""
    
    // this function is called to get datas from the api and if the api calling is completed the success and failure will display , the data will be send in the format of [[string: AnyObject]], ie an array of array of dictinares data type. the completion block returns void.
    
    func getDataWith(completion: @escaping (Result<[[String: AnyObject]]>) -> ()) {
        
        // calling the alamofire request with get method  with no parameters
        Alamofire.request(baseUrl.link, method: .get, parameters: ["":""], encoding: JSONEncoding.default, headers: [:]).validate().responseJSON { (response) in
            switch response.result {
                
                // this is for case SUCCESS in response from api
            case .success:
                print(":validi success")
                // getting the response value which could be dictionary type or array type , in which the response can be type casted as Anyobject
                let json = response.result.value as AnyObject
                
                // calling the guard statement by creating a new constant called itemsJsonArray, the guard statment is used to check is the data type exsist in the json response, here the data type is NSDictionary but can be specified as [[String: AnyObject]], if the binding fails the else statement works,which is calling the "completion block" of ennum case .ERROR
                guard let itemsJsonArray = json.value(forKeyPath: "feed.results") as?  [[String: AnyObject]] else {
                    completion(.Error("missing"))
                    return
                }
                // calling the completion block after parsing the data as type [[String: AnyObject]]
                completion(.Success(itemsJsonArray))
            case .failure(let error):
                print("Error = \(error.localizedDescription)")
                //this si the faliur case calling the completion block
                 completion(.Error("regi"))
                
            }
        }
    }
    
    
    // calling the searchApi function , the api for search fucntion is called with "keywords" parameters received from
    //
    func searchApi(completion: @escaping (Result<[[String: AnyObject]]>) -> ()) {
        
        print("From Api Key = \(keyWords)")
        //let parameters = ["keyword": "atm"]
         // calling the alamofire request with get method  with  parameter Keywords
        Alamofire.request(baseUrl.link2 + "keyword=\(keyWords)", method: .post, parameters: ["":""], encoding: JSONEncoding.default , headers: nil).validate().responseJSON { (response) in
            switch response.result {
            case .success:
                print("ssss")
                let json = response.result.value as! [[String: AnyObject]]
                completion(.Success(json))
              
                
            case .failure(let error):
                print("Error = \(error.localizedDescription)")
                completion(.Error("Error = \(error.localizedDescription)"))
            }
        }
        
    }
    
    
    
    
}
