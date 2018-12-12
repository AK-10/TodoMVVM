//
//  ItemEntity.swift
//  TodoMVVM
//
//  Created by Atsushi KONISHI on 2018/12/09.
//  Copyright © 2018 小西篤志. All rights reserved.
//

import Foundation

final class ItemEntity {
    var id: Int
    var text: String
    init(id: Int, text: String) {
        self.id = id
        self.text = text
    }
}

