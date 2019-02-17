//
//  Model.swift
//  TodoMVVM
//
//  Created by Atsushi KONISHI on 2018/12/09.
//  Copyright © 2018 小西篤志. All rights reserved.
//

import Foundation

enum SearchResult<T> {
    case found(T)
    case all(T)
    case failure(Error)
}

enum SearchModelError: Error {
    case invalidText
}

protocol SearchModelProtocol {
    func validate(text: String?) -> SearchResult<Void>
}

final class SearchModel: SearchModelProtocol {
    
    func validate(text: String?) -> SearchResult<Void> {
        switch text {
        case .none:
            return .failure(SearchModelError.invalidText)
        case .some(let text):
            if text.isEmpty {
                return .all(())
            } else {
                return .found(())
            }
        }
    }
}
