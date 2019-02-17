//
//  ItemEntity+CoreDataClass.swift
//  TodoMVVM
//
//  Created by Atsushi KONISHI on 2018/12/12.
//  Copyright © 2018 小西篤志. All rights reserved.
//
//

import Foundation
import CoreData

@objc(ItemEntity)
public class ItemEntity: NSManagedObject {
//    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemEntity> {
//        return NSFetchRequest<ItemEntity>(entityName: "ItemEntity")
//    }
    
    enum key: String {
        case id, text
    }
    
    public func setValues(id: Int16, text: String) {
        self.id = id
        self.text = text
    }
    
}
