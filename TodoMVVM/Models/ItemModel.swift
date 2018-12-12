//
//  ItemModel.swift
//  TodoMVVM
//
//  Created by Atsushi KONISHI on 2018/12/09.
//  Copyright © 2018 小西篤志. All rights reserved.
//

import Foundation

enum ItemResult<T> {
    case success(T)
    case failure(Error)
}

enum ItemModelError: Error {
    case invalidText
    case failRemove
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
    private static var items: [ItemEntity] = [] //store
    
    func getData() -> ItemResult<[ItemEntity]> {
        return .success(ItemModel.items)
    }
    
    func createData(text: String?) -> ItemResult<ItemEntity> {
        switch text {
        case .none:
            return .failure(ItemModelError.invalidText)
        case .some(let text):
            if text.isEmpty {
                return .failure(ItemModelError.invalidText)
            } else {
                // DBへ書き込みして結果を返す
                let id = (ItemModel.items.last?.id ?? 0) + 1
                let item = ItemEntity(id: id, text: text)
                ItemModel.items.append(item)
                return .success(item)
            }
        }
    }
    
    func searchData(contains text: String?) -> ItemResult<[ItemEntity]> {
        switch text {
        case .none:
            return .failure(ItemModelError.invalidText)
        case .some(let text):
            let results = ItemModel.items.filter{ $0.text.contains(text) }
            return .success(results)
        }
    }
}
