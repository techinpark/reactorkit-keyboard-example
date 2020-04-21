//
//  SettingSection.swift
//  reactorkitKeyboardExample
//
//  Created by Fernando on 2020/04/21.
//  Copyright © 2020 tmsae. All rights reserved.
//

import RxDataSources

enum SettingSection {
    case usage([SettingSectionItem])
}

extension SettingSection: SectionModelType {

    var items: [SettingSectionItem] {
        switch self {
        case .usage(let items):
            return items
        }
    }

    init(original: SettingSection, items: [SettingSectionItem]) {
        switch original {
        case .usage:
            self = .usage(items)
        }
    }
}

enum SettingSectionItem {
    case openSource(SettingCellReactor)
    case githubRepo(SettingCellReactor)
}

