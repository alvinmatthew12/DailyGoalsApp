//
//  Todo+CoreDataProperties.swift
//  DailyGoalsApp
//
//  Created by Alvin Matthew Pratama on 11/04/20.
//  Copyright © 2020 Alvin Matthew Pratama. All rights reserved.
//
//

import Foundation
import CoreData


extension Todo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Todo> {
        return NSFetchRequest<Todo>(entityName: "Todo")
    }

    @NSManaged public var todo: String?
    @NSManaged public var start: String?
    @NSManaged public var end: String?
    @NSManaged public var status: String?

}
