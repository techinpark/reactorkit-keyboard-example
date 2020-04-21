//
//  SettingMenuTypes.swift
//  reactorkitKeyboardExample
//
//  Created by Fernando on 2020/04/21.
//  Copyright © 2020 tmsae. All rights reserved.
//

import Foundation

enum SettingMenuTypes {
    case openSource
    case githubRepo

    var title: String {
        switch self {
        case .openSource:
            return NSLocalizedString("opensource_title", comment: "Open Source License")
        case .githubRepo:
            return NSLocalizedString("github_repo_title", comment: "Go to Github Repository")
        }
    }
}
