//
//  MainSection.swift
//  reactorkitKeyboardExample
//
//  Created by Fernando on 2020/04/21.
//  Copyright © 2020 tmsae. All rights reserved.
//

import Foundation
import RxDataSources

enum MainSection {
    case list([MainSectionItem])
}

extension MainSection: SectionModelType {

    typealias Identify = String
    typealias Item = MainSectionItem
    var identify: String {
        return ""
    }

    var items: [MainSectionItem] {
        switch self {
        case .list(let items):
            return items
        }
    }

    init(original: MainSection, items: [Item]) {
        switch original {
        case .list:
            self = .list(items)
        }
    }
}

enum MainSectionItem {
    case listItem(MainTableViewCellReactor)
}
