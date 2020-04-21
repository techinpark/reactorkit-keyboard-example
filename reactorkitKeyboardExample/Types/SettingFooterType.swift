//
//  SettingFooterType.swift
//  reactorkitKeyboardExample
//
//  Created by Fernando on 2020/04/21.
//  Copyright © 2020 tmsae. All rights reserved.
//

import Foundation

enum SettingFooterType: Int {
    case dataComment

    var description: String {
        switch self {
        case .dataComment:
            return NSLocalizedString("opensource_comment", comment: "")
        }
    }
}
