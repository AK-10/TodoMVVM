//
//  ViewModel.swift
//  TodoMVVM
//
//  Created by Atsushi KONISHI on 2018/12/09.
//  Copyright © 2018 小西篤志. All rights reserved.
//

import Foundation

final class ViewModel: NSObject {
    
    let changeText = Notification.Name("changeText")
    let getData = Notification.Name("getData")
    let addData = Notification.Name("addData")
    let removeData = Notification.Name("removeData")
    
    var items: [ItemEntity] = []
    
    private let notificationCenter: NotificationCenter
    private let searchModel: SearchModelProtocol
    private let itemModel: ItemModelProtocol
    
    init(notificationCenter: NotificationCenter, searchModel: SearchModelProtocol = SearchModel(), itemModel: ItemModelProtocol = ItemModel()) {
        self.notificationCenter = notificationCenter
        self.searchModel = searchModel
        self.itemModel = itemModel
    }
    
    func searchTextChanged(text: String?) {
        print("vm: search")
        let result = searchModel.validate(text: text)
        switch result {
        case .found:
            let filtered = itemModel.searchData(contains: text)
            switch filtered {
            case .success(let items):
                print("vm:search:success")
                self.items.removeAll()
                self.items.append(contentsOf: items)
                notificationCenter.post(name: changeText, object: nil)
            case .failure(let error as ItemModelError):
                print("error: \(error)")
                notificationCenter.post(name: changeText, object: error.errorObject)
            case _:
                fatalError("Unexpected pattern.")
            }
        case .all:
            switch itemModel.getData() {
            case .success(let items):
                self.items.removeAll()
                self.items.append(contentsOf: items)
            case .failure(let err as ItemModelError):
                notificationCenter.post(name: changeText, object: err.errorObject)
            case _:
                fatalError("Unexpected pattern.")
            }
        case .failure(let error as SearchModelError):
            notificationCenter.post(name: changeText, object: error.errorObject)
        case _:
            fatalError("Unexpected pattern.")
        }
    }
    
    
    func itemRequested() {
        let result = itemModel.getData()
        switch result {
        case .success(let items):
            self.items.append(contentsOf: items)
            notificationCenter.post(name: getData, object: items)
        case .failure(let error as ItemModelError):
            print("error: \(error)")
            notificationCenter.post(name: getData, object: [])
        case _:
            fatalError("Unexpected pattern.")
        }
    }
    
    func createItem(text: String?) {
        let result = itemModel.createData(text: text)
        switch result {
        case .success(let item):
            items.append(item)
            notificationCenter.post(name: addData, object: item)
        case .failure(let error as ItemModelError):
            print("error: \(error)")
            notificationCenter.post(name: addData, object: nil)
        case _:
            fatalError("Unexpected pattern.")
        }
    }
}

extension SearchModelError {
    fileprivate var errorObject: String {
        return "search: Error"
    }
}

extension ItemModelError {
    fileprivate var errorObject: String {
        return "item: Error"
    }
}

