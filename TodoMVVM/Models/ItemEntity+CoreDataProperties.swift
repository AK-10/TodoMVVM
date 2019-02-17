//
//  ItemEntity+CoreDataProperties.swift
//  TodoMVVM
//
//  Created by Atsushi KONISHI on 2018/12/12.
//  Copyright © 2018 小西篤志. All rights reserved.
//
//

import Foundation
import CoreData

extension ItemEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemEntity> {
        return NSFetchRequest<ItemEntity>(entityName: "ItemEntity")
    }

    @NSManaged public var id: Int16
    @NSManaged public var text: String?

}
