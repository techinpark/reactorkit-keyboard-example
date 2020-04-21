//
//  ListSection.swift
//  keyboard
//
//  Created by Fernando on 2020/04/21.
//  Copyright © 2020 tmsae. All rights reserved.
//

import Foundation
import RxDataSources

enum ListSection {
    case list([ListSectionItem])
}

extension ListSection: SectionModelType {

    typealias Identify = String
    typealias Item = ListSectionItem
    var identify: String {
        return ""
    }

    var items: [ListSectionItem] {
        switch self {
        case .list(let items):
            return items
        }
    }

    init(original: ListSection, items: [Item]) {
        switch original {
        case .list:
            self = .list(items)
        }
    }
}

enum ListSectionItem {
    case listItem(ListCellReactor)
}
