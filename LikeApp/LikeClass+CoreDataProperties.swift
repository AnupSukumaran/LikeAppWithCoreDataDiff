//
//  LikeClass+CoreDataProperties.swift
//  LikeApp
//
//  Created by Sukumar Anup Sukumaran on 05/04/18.
//  Copyright © 2018 AssaRadviewTech. All rights reserved.
//
//

import Foundation
import CoreData


extension LikeClass {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LikeClass> {
        return NSFetchRequest<LikeClass>(entityName: "LikeClass")
    }

    @NSManaged public var likecount: Int16

}
