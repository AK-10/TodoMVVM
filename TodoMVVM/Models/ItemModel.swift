//
//  ItemModel.swift
//  TodoMVVM
//
//  Created by Atsushi KONISHI on 2018/12/09.
//  Copyright © 2018 小西篤志. All rights reserved.
//

import Foundation
import CoreData

enum ItemResult<T> {
    case success(T)
    case failure(Error)
}

enum ItemModelError: Error {
    case invalidText
    case failRemove
    case failFetch
    case failCreate
    case contextError
}

protocol ItemModelProtocol {
//    func validate(item: ItemEntity?) -> ItemResult<Void>
    func getData() -> ItemResult<[ItemEntity]>
    func createData(text: String?) -> ItemResult<ItemEntity>
    func removeData(item: ItemEntity?) -> ItemResult<Void>
    func searchData(contains text: String?) -> ItemResult<[ItemEntity]>
}

extension ItemModelProtocol { // 仮置き
    func removeData(item: ItemEntity?) -> ItemResult<Void> {
        return .success(())
    }
}

final class ItemModel: ItemModelProtocol {
//    private static var items: [ItemEntity] = [] //store
    public var context: NSManagedObjectContext?
    
    init() {
        self.context = nil
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func getData() -> ItemResult<[ItemEntity]> {
        let fetchRequest: NSFetchRequest<ItemEntity> = ItemEntity.fetchRequest()
        guard let context = context else {
            return .failure(ItemModelError.failFetch)
        }
        do {
            let items = try context.fetch(fetchRequest) as [ItemEntity]
            return .success(items)
        } catch let e {
            print("Error: \(e)")
            return .failure(ItemModelError.failFetch)
        }

    }
    
    
    func createData(text: String?) -> ItemResult<ItemEntity> {
        switch text {
        case .none:
            return .failure(ItemModelError.invalidText)
        case .some(let text):
            if text.isEmpty {
                return .failure(ItemModelError.invalidText)
            } else {
                guard let context = self.context else {
                    return .failure(ItemModelError.contextError)
                }
                let request: NSFetchRequest<ItemEntity> = ItemEntity.fetchRequest()
                request.sortDescriptors = [NSSortDescriptor(key: ItemEntity.key.id.rawValue, ascending: false)]
                request.fetchLimit = 1
                do {
                    let newId = (try context.fetch(request).first?.id ?? 0) + 1
                    let item: ItemEntity = ItemEntity(context: context)
                    item.id = newId
                    item.text = text
                    return .success(item)
                } catch let e {
                    print("failCreate: \(e)")
                    return .failure(ItemModelError.failCreate)
                }
            }
        }
    }
    
    func searchData(contains text: String?) -> ItemResult<[ItemEntity]> {
        switch text {
        case .none:
            return .failure(ItemModelError.invalidText)
        case .some(let text):
//            let results = ItemModel.items.filter{ $0.text.contains(text) }
            guard let context = self.context else {
                return .failure(ItemModelError.contextError)
            }
            
            let item = NSManagedObjectContext()
            item.setValue("text", forKey: "text")
            item.setValue(1, forKey: "id")
//            return .success(results)
            return .success([ItemEntity(context: item)])
        }
    }
}
