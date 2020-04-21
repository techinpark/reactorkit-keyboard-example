//
//  SettingCellReactor.swift
//  reactorkitKeyboardExample
//
//  Created by Fernando on 2020/04/21.
//  Copyright © 2020 tmsae. All rights reserved.
//

import ReactorKit
import RxCocoa
import RxSwift

final class SettingCellReactor: Reactor {
    typealias Action = NoAction

    struct State {
        var type: SettingMenuTypes
    }

    let initialState: State

    init(type: SettingMenuTypes) {
        initialState = State(type: type)
    }
}
