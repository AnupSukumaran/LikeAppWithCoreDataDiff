//
//  Constants.swift
//  LikeApp
//
//  Created by Sukumar Anup Sukumaran on 05/04/18.
//  Copyright © 2018 AssaRadviewTech. All rights reserved.
//

import Foundation

struct Constants{
    
    //static let sharedInstance = SingleTonPratice()
    static var sharedInt = Constants()
    
    
    var counts: [Int] = []
    var id = 0
   static let sharedInstance = NSNotification.Name("Notify")
    
   
    
}
