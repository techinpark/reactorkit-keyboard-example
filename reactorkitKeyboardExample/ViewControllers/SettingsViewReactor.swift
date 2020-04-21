//
//  SettingsViewReactor.swift
//  reactorkitKeyboardExample
//
//  Created by Fernando on 2020/04/21.
//  Copyright © 2020 tmsae. All rights reserved.
//

import ReactorKit
import RxCocoa
import RxSwift

final class SettingViewReactor: Reactor {
    typealias Action = NoAction

    struct State {

        var usageSectionItems: [SettingSectionItem] {
              return [
                .openSource(SettingCellReactor(type: .openSource)),
                .githubRepo(SettingCellReactor(type: .githubRepo))
            ]
        }
        var sections: [SettingSection] {
            return [.usage(self.usageSectionItems)]
        }
    }

    let initialState: State

    // MARK: Initializing

    init() {
        initialState = State()
    }
}
